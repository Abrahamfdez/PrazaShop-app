package org.example.prazashop.confg.security;

// Importaciones necesarias para el filtro y la autenticación JWT
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.auth.repository.Token;
import org.example.prazashop.auth.repository.TokenRepository;
import org.example.prazashop.auth.service.JwtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Optional;

/**
 * Filtro de autenticación JWT: intercepta cada petición HTTP para validar el token JWT.
 */
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    // Servicio para manejar JWT (extraer usuario, validar token, etc.)
    private final JwtService jwtService;
    // Servicio para cargar los detalles del usuario desde la base de datos
    private final UserDetailsService userDetailsService;
    // Repositorio para acceder a los tokens almacenados en la base de datos
    @Autowired
    private TokenRepository tokenRepository;

    // Logger para registrar información y errores
    private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);

    /**
     * Método principal que se ejecuta en cada petición HTTP.
     * Valida el JWT y establece la autenticación en el contexto de seguridad si es válido.
     */
    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    )
            throws ServletException, IOException {

        // Obtiene el header Authorization de la petición
        String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        logger.debug("Request {} {} - Authorization present: {}", request.getMethod(), request.getRequestURI(), authHeader != null);

        // Si no hay header o no empieza por 'Bearer ', continúa la cadena de filtros sin hacer nada
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            logger.debug("No Authorization header or not Bearer - continuing filter chain");
            filterChain.doFilter(request, response);
            return;
        }

        // Extrae el token JWT del header
        String jwt = authHeader.substring(7).trim();
        String userEmail;
        try {
            // Intenta extraer el email/usuario del token
            userEmail = jwtService.extractUsername(jwt);
        } catch (Exception e) {
            // Si falla, probablemente el token está mal formado
            logger.warn("Failed to parse JWT (possible malformed token): {}", e.getMessage());
            filterChain.doFilter(request, response);
            return;
        }

        try {
            // Si se obtuvo el usuario y no hay autenticación previa en el contexto
            if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                // Carga los detalles del usuario desde la base de datos
                UserDetails userDetails = userDetailsService.loadUserByUsername(userEmail);
                // Verifica si el token es válido para ese usuario
                if (jwtService.isTokenValid(jwt, userDetails)) {
                    // Si es válido, crea un objeto de autenticación y lo pone en el contexto de seguridad
                    UsernamePasswordAuthenticationToken authToken =
                            new UsernamePasswordAuthenticationToken(
                                    userDetails,
                                    null,
                                    userDetails.getAuthorities()
                            );
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                    logger.debug("Authentication set for user {}", userEmail);
                } else {
                    logger.debug("JWT not valid for user {}", userEmail);
                }
            }

            // Comprueba en la base de datos que el token no esté revocado ni expirado
            Optional<Token> tokenOpt = tokenRepository.findByToken(jwt);
            if (tokenOpt.isEmpty() || tokenOpt.get().isRevocado() || tokenOpt.get().isExpirado()) {
                logger.debug("Token not present or revoked/expired in DB (token={})", (jwt.length() > 8 ? jwt.substring(0,8)+"..." : jwt));
                filterChain.doFilter(request, response);
                return;
            }

        } catch (Exception ex) {
            // Si ocurre cualquier error inesperado, lo registra y continúa la cadena de filtros
            logger.error("Unexpected error in JwtAuthenticationFilter: {}", ex.getMessage(), ex);
            filterChain.doFilter(request, response);
            return;
        }

        // Si todo es correcto, continúa la cadena de filtros normalmente
        logger.debug("Token validated and present in DB - continuing filter chain");
        filterChain.doFilter(request, response);
    }
}