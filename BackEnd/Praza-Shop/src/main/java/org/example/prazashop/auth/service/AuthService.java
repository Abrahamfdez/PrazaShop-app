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
 * Servicio encargado de la autenticación y gestión de tokens JWT.
 * Incluye registro, login y refresh de tokens.
 */
@Service
@RequiredArgsConstructor
public class AuthService {
    // Repositorio para gestionar los tokens en la base de datos
    private final TokenRepository tokenRepository;
    // Codificador de contraseñas para almacenar contraseñas seguras
    private final PasswordEncoder passwordEncoder;
    // Repositorio de usuarios para acceder a los datos de usuario
    private final UsuarioRepository usuarioRepository;
    // Servicio para generar y validar JWT
    private final JwtService JwtService;

    /**
     * Registra un nuevo usuario y genera tokens de acceso y refresh.
     * @param registerRequest datos del usuario a registrar
     * @return respuesta con access y refresh token
     */
    @Transactional
    public TokenResponse register(RegisterRequest registerRequest) {
        // Normalizamos el email (sin espacios y en minúsculas)
        String email = registerRequest.getEmail() != null ? registerRequest.getEmail().trim().toLowerCase() : null;
        if (email == null || email.isBlank()) {
            // Si el email es nulo o vacío, lanzamos excepción 400
            throw new BadRequestException("Email requerido");
        }

        // Si ya existe un usuario con ese email, lanzamos excepción 409
        if (usuarioRepository.existsByEmail(email)) {
            throw new ConflictException("Email ya registrado");
        }

        // Creamos el usuario con los datos recibidos y la contraseña codificada
        var user = Usuario.builder()
                .nome(registerRequest.getNome())
                .contrasinal(passwordEncoder.encode(registerRequest.getContrasinal()))
                .tipoUsuario(registerRequest.getTipoUsuario())
                .email(email)
                .telefono(registerRequest.getTelefono())
                .build();

        try {
            // Guardamos el usuario en la base de datos
            var guardado = usuarioRepository.save(user);

            // Generamos los tokens JWT
            var jwtToken = JwtService.generateToken(guardado);
            var refreshToken = JwtService.generateRefreshToken(guardado);

            // Guardamos los tokens en la base de datos
            saveUserToken(guardado, jwtToken, Token.TipoToken.ACCESS);
            saveUserToken(guardado, refreshToken, Token.TipoToken.REFRESH);

            // Devolvemos los tokens al cliente
            return TokenResponse.builder()
                    .accessToken(jwtToken)
                    .refreshToken(refreshToken)
                    .build();

        } catch (DataIntegrityViolationException ex) {
            // Si hay un error de integridad (email duplicado), lanzamos excepción 409
            throw new ConflictException("Email ya registrado");
        }
    }

    /**
     * Autentica al usuario y genera nuevos tokens, revocando los anteriores.
     * @param loginRequest datos de login (email y contraseña)
     * @return respuesta con access y refresh token
     */
    public TokenResponse login(LoginRequest loginRequest) {
        // Buscamos el usuario por email o lanzamos excepción si no existe
        var user = usuarioRepository.findByEmail(loginRequest.getEmail())
                .orElseThrow(() -> new BadRequestException("Usuario incorrecto"));
        // Comprobamos si la contraseña es correcta
        if (!passwordEncoder.matches(loginRequest.getContrasinal(), user.getContrasinal())) {
            throw new BadRequestException("Contraseña  incorrecta");
        }
        // Revocamos todos los access tokens anteriores del usuario
        java.util.List<Token> tokens = tokenRepository.findAllByUsuarioId(user.getId());
        for (Token t : tokens) {
            if (t.getTipoToken() == Token.TipoToken.ACCESS && !t.isRevocado() && !t.isExpirado()) {
                t.setRevocado(true);
                t.setExpirado(true);
                tokenRepository.save(t);
            }
        }
        // Generamos nuevos tokens y los guardamos
        var jwtToken = JwtService.generateToken(user);
        var refreshToken = JwtService.generateRefreshToken(user);
        saveUserToken(user, jwtToken, Token.TipoToken.ACCESS);
        saveUserToken(user, refreshToken, Token.TipoToken.REFRESH);
        // Devolvemos los tokens al cliente
        return TokenResponse.builder()
                .accessToken(jwtToken)
                .refreshToken(refreshToken)
                .build();
    }

    /**
     * Guarda un token asociado a un usuario en la base de datos.
     * @param usuario usuario al que pertenece el token
     * @param jwtToken valor del token
     * @param tipo tipo de token (ACCESS o REFRESH)
     */
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
     * Refresca el access token usando un refresh token válido.
     * @param rawRefreshToken refresh token recibido (puede venir con 'Bearer ')
     * @return respuesta con nuevo access token y el mismo refresh token
     */
    public TokenResponse refreshToken(String rawRefreshToken) {
        // Se acepta como "Bearer <token>" o solo el token
        String refreshToken = rawRefreshToken.startsWith("Bearer ") ? rawRefreshToken.substring(7) : rawRefreshToken;

        // Extraemos el email del token
        String email;
        try {
            email = JwtService.extractUsername(refreshToken);
        } catch (Exception ex) {
            throw new BadRequestException("Refresh token inválido");
        }

        // Buscamos el usuario por email
        var user = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("Usuario no encontrado"));

        // Comprobamos que el refresh token existe y no está revocado/expirado
        var tokenEntityOpt = tokenRepository.findByToken(refreshToken);
        if (tokenEntityOpt.isEmpty()) {
            throw new BadRequestException("Refresh token no encontrado");
        }
        var tokenEntity = tokenEntityOpt.get();
        if (tokenEntity.isRevocado() || tokenEntity.isExpirado() || tokenEntity.getTipoToken() != Token.TipoToken.REFRESH) {
            throw new BadRequestException("Refresh token inválido o revocado");
        }

        // Validamos la firma y expiración del token
        var userDetails = new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getContrasinal(),
                List.of(new SimpleGrantedAuthority("ROLE_USER"))
        );

        if (!JwtService.isTokenValid(refreshToken, userDetails)) {
            throw new BadRequestException("Refresh token no válido o expirado");
        }

        // Generamos un nuevo access token
        var newAccessToken = JwtService.generateToken(user);

        // Revocamos los access tokens anteriores
        List<Token> tokens = tokenRepository.findAllByUsuarioId(user.getId());
        for (Token t : tokens) {
            if (t.getTipoToken() == Token.TipoToken.ACCESS && !t.isRevocado() && !t.isExpirado()) {
                t.setRevocado(true);
                t.setExpirado(true);
                tokenRepository.save(t);
            }
        }
        // Guardamos el nuevo access token
        saveUserToken(user, newAccessToken, Token.TipoToken.ACCESS);

        // Devolvemos el nuevo access token y el mismo refresh token
        return TokenResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(refreshToken)
                .build();
    }
}
