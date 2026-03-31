package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DetallePedidoDto {
    private Long id;
    private Long pedidoId;
    private Long productoId;
    private Integer cantidade;
    private Double prezoUnitario;
}

