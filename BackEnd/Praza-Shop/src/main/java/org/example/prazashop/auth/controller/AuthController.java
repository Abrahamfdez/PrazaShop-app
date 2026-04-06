package org.example.prazashop.auth.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.auth.requets.LoginRequest;
import org.example.prazashop.auth.requets.RegisterRequest;
import org.example.prazashop.auth.requets.TokenResponse;
import org.example.prazashop.auth.service.AuthService;
import org.example.prazashop.exception.BadRequestException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * The type Auth controller.
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    /**
     * Login response entity.
     *
     * @param loginRequest the login request
     * @return the response entity
     */
    @PostMapping("/login")
    public ResponseEntity<TokenResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        return ResponseEntity.ok(authService.login(loginRequest));
    }

    /**
     * Register response entity.
     *
     * @param registerRequest the register request
     * @return the response entity
     */
    @PostMapping("/register")
    public ResponseEntity<TokenResponse> register(@Valid @RequestBody RegisterRequest registerRequest) {
        var tokenResponse = authService.register(registerRequest);
        return ResponseEntity.ok(tokenResponse);
    }

    /**
     * Refresh response entity.
     *
     * @param authHeader the auth header
     * @param body       the body
     * @return the response entity
     */
    @PostMapping("/refresh")
    public ResponseEntity<TokenResponse> refresh(@RequestHeader(name = HttpHeaders.AUTHORIZATION, required = false) String authHeader,
                                                 @RequestBody(required = false) Map<String, String> body) {
        String token = null;
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
        } else if (body != null && body.containsKey("refreshToken")) {
            token = body.get("refreshToken");
        } else {
            throw new BadRequestException("Falta refresh token en header Authorization o en body {\"refreshToken\": \"...\"}");
        }
        return ResponseEntity.ok(authService.refreshToken(token));
    }

}
