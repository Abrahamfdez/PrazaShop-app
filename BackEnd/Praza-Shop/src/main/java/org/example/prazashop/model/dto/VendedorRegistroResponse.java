package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Response para registro de vendedor con tokens JWT.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VendedorRegistroResponse {
    private UsuarioDto usuario;
    private NegocioDto negocio;
    private String token;
    private String refreshToken;
}
