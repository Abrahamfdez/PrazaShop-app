package org.example.prazashop.service;

import org.example.prazashop.model.dto.DetallePedidoDto;

import java.util.List;
import java.util.Optional;

/**
 * Servicio para la lógica asociada a los detalles de pedido.
 */
public interface DetallePedidoService {
    /**
     * Find all list.
     *
     * @return the list
     */
    List<DetallePedidoDto> findAll();

    /**
     * Find by id optional.
     *
     * @param id the id
     * @return the optional
     */
    Optional<DetallePedidoDto> findById(Long id);

    /**
     * Create detalle pedido dto.
     *
     * @param detallePedido the detalle pedido
     * @return the detalle pedido dto
     */
    DetallePedidoDto create(DetallePedidoDto detallePedido);

    /**
     * Update detalle pedido dto.
     *
     * @param id            the id
     * @param detallePedido the detalle pedido
     * @return the detalle pedido dto
     */
    DetallePedidoDto update(Long id, DetallePedidoDto detallePedido);

    /**
     * Delete by id.
     *
     * @param id the id
     */
    void deleteById(Long id);
}
