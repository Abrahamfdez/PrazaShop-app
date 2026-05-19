package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request para registrar un nuevo vendedor (usuario + negocio).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VendedorRegistroRequest {
    private String email;
    private String contraseña;
    private String nombreNegocio;
    private String descripcion;
}
