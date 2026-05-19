package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Request para crear un pedido completo con detalles en una sola transacción.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PedidoCreacionRequest {
    private Long clienteId;
    private Long negocioId;
    private List<DetallePedidoRequest> detalles;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DetallePedidoRequest {
        private Long productoId;
        private Integer cantidad;
    }
}
