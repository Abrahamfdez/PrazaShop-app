package org.example.prazashop.service;

import org.example.prazashop.model.dto.PedidoDto;

import java.util.List;

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
     * Busca un pedido por su id. Lanza NoContentException si no se encuentra.
     *
     * @param id the id
     * @return pedido encontrado
     * @throws NoContentException si no se encuentra el pedido
     */
    PedidoDto findById(Long id);

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

    /**
     * Busca pedidos por id de cliente.
     *
     * @param clienteId id del cliente
     * @return lista de pedidos
     */
    List<PedidoDto> findByClienteId(Long clienteId);

    /**
     * Busca pedidos por id de negocio.
     *
     * @param negocioId id del negocio
     * @return lista de pedidos
     */
    List<PedidoDto> findByNegocioId(Long negocioId);
}
