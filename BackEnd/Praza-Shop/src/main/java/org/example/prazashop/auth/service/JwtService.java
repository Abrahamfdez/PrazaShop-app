package org.example.prazashop.auth.service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.entity.Usuario;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Base64;
import java.util.Date;
import java.util.Map;

/**
 * Servicio encargado de la generación, validación y extracción de información de tokens JWT.
 */
@Service
@RequiredArgsConstructor
public class JwtService {
    // Clave secreta para firmar los tokens, se obtiene de application.properties
    @Value("${application.security.jwt.secret-key}")
    private String secret;
    // Tiempo de expiración del access token en milisegundos
    @Value("${application.security.jwt.expiration}")
    private Long jwtExpiration;
    // Tiempo de expiración del refresh token en milisegundos
    @Value("${application.security.jwt.refresh-token-expiration}")
    private Long refreshTokenExpiration;

    /**
     * Genera un access token JWT para el usuario proporcionado.
     * @param user usuario para el que se genera el token
     * @return token JWT como String
     */
    public String generateToken(Usuario user) {
        return buidToken(user, jwtExpiration);
    }

    /**
     * Genera un refresh token JWT para el usuario proporcionado.
     * @param user usuario para el que se genera el refresh token
     * @return refresh token JWT como String
     */
    public String generateRefreshToken(Usuario user) {
        return buidToken(user, refreshTokenExpiration);
    }

    /**
     * Construye un token JWT con los datos del usuario y el tiempo de expiración indicado.
     * @param user usuario para el que se genera el token
     * @param expiration tiempo de expiración en milisegundos
     * @return token JWT como String
     */
    private String buidToken(final Usuario user, final Long expiration) {
        return Jwts.builder()
                .id(user.getId().toString()) // ID del usuario como identificador del token
                .claims(Map.of("name", user.getNome())) // Se añade el nombre como claim
                .subject(user.getEmail()) // El email será el subject del token
                .issuedAt(new Date(System.currentTimeMillis())) // Fecha de emisión
                .expiration(new Date(System.currentTimeMillis() + expiration)) // Fecha de expiración
                .signWith(getSecretKey()) // Firma el token con la clave secreta
                .compact();
    }

    /**
     * Obtiene la clave secreta en formato SecretKey a partir del string base64.
     * @return clave secreta para firmar/verificar tokens
     */
    private SecretKey getSecretKey() {
        byte[] keyBytes = Base64.getDecoder().decode(secret);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    /**
     * Extrae todos los claims (información) de un token JWT.
     * @param token JWT
     * @return objeto Claims con la información del token
     */
    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(getSecretKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * Extrae el email (subject) del token JWT.
     * @param jwt token JWT
     * @return email del usuario
     */
    public String extractUsername(String jwt) {
        return extractAllClaims(jwt).getSubject();
    }

    /**
     * Valida si el token es válido para el usuario y no ha expirado.
     * @param jwt token JWT
     * @param userDetails detalles del usuario
     * @return true si el token es válido y no ha expirado
     */
    public boolean isTokenValid(String jwt, UserDetails userDetails) {
        var claims = extractAllClaims(jwt);
        String username = claims.getSubject();
        Date expiration = claims.getExpiration();
        boolean notExpired = expiration.after(new Date());
        return username.equals(userDetails.getUsername()) && notExpired;
    }
}
