package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NegocioDto {
    private Long id;
    private Long usuarioId;
    private String nomeNegocio;
    private String direccion;
    private String descricion;
}

