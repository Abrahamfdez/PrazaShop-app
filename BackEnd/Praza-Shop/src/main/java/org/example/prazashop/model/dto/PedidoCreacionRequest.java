package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.*;

import java.util.List;

/**
 * Request para crear un pedido completo con detalles en una sola transacción.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PedidoCreacionRequest {
    @NotNull(message = "El ID del cliente es obligatorio")
    private Long clienteId;
    
    @NotNull(message = "El ID del negocio es obligatorio")
    private Long negocioId;
    
    @NotEmpty(message = "Debe tener al menos un detalle")
    private List<DetallePedidoRequest> detalles;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DetallePedidoRequest {
        @NotNull(message = "El ID del producto es obligatorio")
        private Long productoId;
        
        @NotNull(message = "La cantidad es obligatoria")
        @Positive(message = "La cantidad debe ser mayor a 0")
        private Integer cantidad;
    }
}
