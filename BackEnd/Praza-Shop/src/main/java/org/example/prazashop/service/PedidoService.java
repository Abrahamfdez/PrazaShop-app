package org.example.prazashop.service;

import org.example.prazashop.model.dto.PedidoDto;

import java.util.List;
import java.util.Optional;

/**
 * Servicios de negocio relacionados con pedidos.
 */
public interface PedidoService {
    /**
     * Find all list.
     *
     * @return the list
     */
    List<PedidoDto> findAll();

    /**
     * Find by id optional.
     *
     * @param id the id
     * @return the optional
     */
    Optional<PedidoDto> findById(Long id);

    /**
     * Create pedido dto.
     *
     * @param pedido the pedido
     * @return the pedido dto
     */
    PedidoDto create(PedidoDto pedido);

    /**
     * Update pedido dto.
     *
     * @param id     the id
     * @param pedido the pedido
     * @return the pedido dto
     */
    PedidoDto update(Long id, PedidoDto pedido);

    /**
     * Delete by id.
     *
     * @param id the id
     */
    void deleteById(Long id);
}
