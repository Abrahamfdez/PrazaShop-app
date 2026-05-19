package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Dashboard consolidado del negocio con estadísticas.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NegocioDashboardDto {
    private NegocioDto negocio;
    private List<ProductoDto> productos;
    private List<PedidoDto> pedidosRecientes;
    private DashboardStats stats;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DashboardStats {
        private Double ratingPromedio;
        private Integer totalVentasCount;
        private Double ingresosTotales;
        private Integer cantidadValoraciones;
    }
}
