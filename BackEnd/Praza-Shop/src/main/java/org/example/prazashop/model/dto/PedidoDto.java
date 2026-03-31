package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PedidoDto {
    private Long id;
    private Long clienteId;
    private Long negocioId;
    private LocalDateTime dataPedido;
    private LocalDateTime dataConfirmacion;
    private LocalDateTime dataEntrega;
    private LocalDateTime dataCancelacion;
    private String estado;
    private Double total;
}

