package org.example.prazashop.auth.service;

import lombok.RequiredArgsConstructor;
import org.example.prazashop.auth.requets.LoginRequest;
import org.example.prazashop.auth.requets.RegisterRequest;
import org.example.prazashop.auth.requets.TokenResponse;
import org.example.prazashop.auth.repository.Token;
import org.example.prazashop.auth.repository.TokenRepository;
import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.ConflictException;
import org.example.prazashop.exception.NotFoundException;
import org.example.prazashop.model.entity.Usuario;
import org.example.prazashop.repository.UsuarioRepository;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * The type Auth service.
 */
@Service
@RequiredArgsConstructor
public class AuthService {
    private final TokenRepository tokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final UsuarioRepository usuarioRepository;
    private final JwtService JwtService;

    /**
     * Register token response.
     *
     * @param registerRequest the register request
     * @return the token response
     */
    @Transactional
    public TokenResponse register(RegisterRequest registerRequest) {
        String email = registerRequest.getEmail() != null ? registerRequest.getEmail().trim().toLowerCase() : null;
        if (email == null || email.isBlank()) {
            throw new BadRequestException("Email requerido");
        }

        // Validación previa: si ya existe, responder inmediatamente
        if (usuarioRepository.existsByEmail(email)) {
            throw new ConflictException("Email ya registrado");
        }

        var user = Usuario.builder()
                .nome(registerRequest.getNome())
                .contrasinal(passwordEncoder.encode(registerRequest.getContrasinal()))
                .tipoUsuario(registerRequest.getTipoUsuario())
                .email(email)
                .telefono(registerRequest.getTelefono())
                .build();

        try {
            var guardado = usuarioRepository.save(user);

            var jwtToken = JwtService.generateToken(guardado);
            var refreshToken = JwtService.generateRefreshToken(guardado);

            saveUserToken(guardado, jwtToken, Token.TipoToken.ACCESS);
            saveUserToken(guardado, refreshToken, Token.TipoToken.REFRESH);

            return TokenResponse.builder()
                    .accessToken(jwtToken)
                    .refreshToken(refreshToken)
                    .build();

        } catch (DataIntegrityViolationException ex) {
            // Retornar Conflict para indicar que ya existe un recurso con ese identificador.
            throw new ConflictException("Email ya registrado");
        }
    }

    /**
     * Login token response.
     *
     * @param loginRequest the login request
     * @return the token response
     */
    public TokenResponse login(LoginRequest loginRequest) {
        // Buscamos el correo en la BD o Lanzamos Excepcion
        var user = usuarioRepository.findByEmail(loginRequest.getEmail())
                .orElseThrow(() -> new BadRequestException("Usuario incorrecto"));
        // Comporbamos si hay mach enj las contraseñas
        if (!passwordEncoder.matches(loginRequest.getContrasinal(), user.getContrasinal())) {
            throw new BadRequestException("Contraseña  incorrecta");
        }
        // Revocar todos los access tokens anteriores del usuario antes de guardar el nuevo
        java.util.List<Token> tokens = tokenRepository.findAllByUsuarioId(user.getId());
        for (Token t : tokens) {
            if (t.getTipoToken() == Token.TipoToken.ACCESS && !t.isRevocado() && !t.isExpirado()) {
                t.setRevocado(true);
                t.setExpirado(true);
                tokenRepository.save(t);
            }
        }
        // Generamos tokens y los guardamos
        var jwtToken = JwtService.generateToken(user);
        var refreshToken = JwtService.generateRefreshToken(user);
        saveUserToken(user, jwtToken, Token.TipoToken.ACCESS);
        saveUserToken(user, refreshToken, Token.TipoToken.REFRESH);
        return TokenResponse.builder()
                .accessToken(jwtToken)
                .refreshToken(refreshToken)
                .build();
    }

    private void saveUserToken(Usuario usuario, String jwtToken,Token.TipoToken tipo) {
        var token = Token.builder()
                .usuario(usuario)
                .token(jwtToken)
                .tipoToken(tipo)
                .revocado(false)
                .expirado(false)
                .build();
        tokenRepository.save(token);
    }

    /**
     * Refresh token token response.
     *
     * @param rawRefreshToken the raw refresh token
     * @return the token response
     */
    public TokenResponse refreshToken(String rawRefreshToken) {
        // Se acepta como "Bearer <token>" o token solo
        String refreshToken = rawRefreshToken.startsWith("Bearer ") ? rawRefreshToken.substring(7) : rawRefreshToken;

        // extrae  (email)
        String email;
        try {
            email = JwtService.extractUsername(refreshToken);
        } catch (Exception ex) {
            throw new BadRequestException("Refresh token inválido");
        }

        var user = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("Usuario no encontrado"));

        // comprobar que el refresh token existe en BD y no esté revocado/expirado
        var tokenEntityOpt = tokenRepository.findByToken(refreshToken);
        if (tokenEntityOpt.isEmpty()) {
            throw new BadRequestException("Refresh token no encontrado");
        }
        var tokenEntity = tokenEntityOpt.get();
        if (tokenEntity.isRevocado() || tokenEntity.isExpirado() || tokenEntity.getTipoToken() != Token.TipoToken.REFRESH) {
            throw new BadRequestException("Refresh token inválido o revocado");
        }

        // validar firma y expiración con JwtService
        // construimos UserDetails ligero para validar username y expiración
        var userDetails = new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getContrasinal(),
                List.of(new SimpleGrantedAuthority("ROLE_USER"))
        );

        if (!JwtService.isTokenValid(refreshToken, userDetails)) {
            throw new BadRequestException("Refresh token no válido o expirado");
        }

        // generar nuevo access token (no regeneramos refresh por defecto)
        var newAccessToken = JwtService.generateToken(user);

        // guardar nuevo access token y  revocar tokens antiguos (ejemplo: no revocamos aquí)

        List<Token> tokens = tokenRepository.findAllByUsuarioId(user.getId());
        for (Token t : tokens) {
            if (t.getTipoToken() == Token.TipoToken.ACCESS && !t.isRevocado() && !t.isExpirado()) {
                t.setRevocado(true);
                t.setExpirado(true);
                tokenRepository.save(t);
            }
        }
        saveUserToken(user, newAccessToken, Token.TipoToken.ACCESS);

        return TokenResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(refreshToken)
                .build();
    }
}
