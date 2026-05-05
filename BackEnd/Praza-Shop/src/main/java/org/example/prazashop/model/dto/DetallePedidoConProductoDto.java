package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para detalle de pedido con información del producto.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DetallePedidoConProductoDto {
    private Long idDetalle;
    private Long pedidoId;
    private Long productoId;
    private String nombreProducto;
    private Integer cantidade;
    private Double prezoUnitario;
    private Double subtotal;
}

