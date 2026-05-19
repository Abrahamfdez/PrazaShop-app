package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Response para búsqueda de pedidos con paginación.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PedidoSearchResponse {
    private List<PedidoDto> content;
    private Integer pageNumber;
    private Integer pageSize;
    private Long totalElements;
    private Integer totalPages;
    private Boolean last;
}
