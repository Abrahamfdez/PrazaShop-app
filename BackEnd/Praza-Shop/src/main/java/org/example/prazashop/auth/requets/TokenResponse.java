package org.example.prazashop.auth.requets;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * The type Token response.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TokenResponse {
    /**
     * The Access token.
     */
    @JsonProperty("access_token")
    String accessToken;
    /**
     * The Refresh token.
     */
    @JsonProperty("refresh_token")
    String refreshToken;
}
