package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Producto con detalles del negocio y estadísticas.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductoDetallesDto {
    private ProductoDto producto;
    private NegocioInfoDto negocio;
    private ProductoStats stats;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class NegocioInfoDto {
        private Long id;
        private String nomeNegocio;
        private String descricion;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ProductoStats {
        private Double ratingPromedio;
        private Integer cantidadValoraciones;
    }
}
