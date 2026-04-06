package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * The type Valoracion dto.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ValoracionDto {
    private Long id;
    private Long clienteId;
    private Long negocioId;
    private Integer puntuacion;
    private String comentario;
    private LocalDateTime dataValoracion;
}

