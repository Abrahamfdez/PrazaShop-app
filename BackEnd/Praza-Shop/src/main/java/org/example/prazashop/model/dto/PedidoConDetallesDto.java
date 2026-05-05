package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO que combina un pedido con todos sus detalles.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PedidoConDetallesDto {
    private Long idPedido;
    private Long clienteId;
    private Long negocioId;
    private LocalDateTime dataPedido;
    private LocalDateTime dataConfirmacion;
    private LocalDateTime dataEntrega;
    private LocalDateTime dataCancelacion;
    private String estado;
    private Double total;
    private List<DetallePedidoConProductoDto> detalles;
}

