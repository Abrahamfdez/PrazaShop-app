package org.example.prazashop.confg.security;

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
 * The type Jwt authentication filter.
 */
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UserDetailsService userDetailsService;
    @Autowired
    private TokenRepository tokenRepository;

    private static final Logger logger = LoggerFactory.getLogger(JwtAuthenticationFilter.class);

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    )
            throws ServletException, IOException {

        String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        logger.debug("Request {} {} - Authorization present: {}", request.getMethod(), request.getRequestURI(), authHeader != null);

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            logger.debug("No Authorization header or not Bearer - continuing filter chain");
            filterChain.doFilter(request, response);
            return;
        }

        String jwt = authHeader.substring(7).trim();
        String userEmail;
        try {
            userEmail = jwtService.extractUsername(jwt);
        } catch (Exception e) {
            logger.warn("Failed to parse JWT (possible malformed token): {}", e.getMessage());
            filterChain.doFilter(request, response);
            return;
        }

        try {
            if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                UserDetails userDetails = userDetailsService.loadUserByUsername(userEmail);
                if (jwtService.isTokenValid(jwt, userDetails)) {
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

            // Validar que el token no esté revocado ni expirado en BD
            Optional<Token> tokenOpt = tokenRepository.findByToken(jwt);
            if (tokenOpt.isEmpty() || tokenOpt.get().isRevocado() || tokenOpt.get().isExpirado()) {
                logger.debug("Token not present or revoked/expired in DB (token={})", (jwt.length() > 8 ? jwt.substring(0,8)+"..." : jwt));
                filterChain.doFilter(request, response);
                return;
            }

        } catch (Exception ex) {
            logger.error("Unexpected error in JwtAuthenticationFilter: {}", ex.getMessage(), ex);
            filterChain.doFilter(request, response);
            return;
        }

        // Token válido: continuar la cadena de filtros
        logger.debug("Token validated and present in DB - continuing filter chain");
        filterChain.doFilter(request, response);
    }
}