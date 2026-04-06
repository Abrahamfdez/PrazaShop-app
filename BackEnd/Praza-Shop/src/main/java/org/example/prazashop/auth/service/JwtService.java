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
 * The type Jwt service.
 */
@Service
@RequiredArgsConstructor
public class JwtService {
    @Value("${application.security.jwt.secret-key}")
    private String secret;
    @Value("${application.security.jwt.expiration}")
    private Long jwtExpiration;
    @Value("${application.security.jwt.refresh-token-expiration}")
    private Long refreshTokenExpiration;

    /**
     * Generate token string.
     *
     * @param user the user
     * @return the string
     */
    public String generateToken(Usuario user) {
        return buidToken(user, jwtExpiration);
    }

    /**
     * Generate refresh token string.
     *
     * @param user the user
     * @return the string
     */
    public String generateRefreshToken(Usuario user) {
        return buidToken(user, refreshTokenExpiration);
    }

    private String buidToken(final Usuario user, final Long expiration) {
        return Jwts.builder()
                .id(user.getId().toString())
                .claims(Map.of("name", user.getNome()))
                .subject(user.getEmail())
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(getSecretKey())
                .compact();
    }

    private SecretKey getSecretKey() {
        byte[] keyBytes = Base64.getDecoder().decode(secret);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(getSecretKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * Extract username string.
     *
     * @param jwt the jwt
     * @return the string
     */
    public String extractUsername(String jwt) {
        return extractAllClaims(jwt).getSubject();
    }

    /**
     * Is token valid boolean.
     *
     * @param jwt         the jwt
     * @param userDetails the user details
     * @return the boolean
     */
    public boolean isTokenValid(String jwt, UserDetails userDetails) {
        var claims = extractAllClaims(jwt);
        String username = claims.getSubject();
        Date expiration = claims.getExpiration();
        boolean notExpired = expiration.after(new Date());
        return username.equals(userDetails.getUsername()) && notExpired;
    }
}
