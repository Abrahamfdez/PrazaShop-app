package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para las estadísticas de valoraciones de un negocio.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ValoracionEstadisticasDto {
    /**
     * ID del negocio.
     */
    private Long negocioId;

    /**
     * Cantidad total de valoraciones.
     */
    private Long cantidadValoraciones;

    /**
     * Media de puntuación.
     */
    private Double mediaPuntuacion;
}

