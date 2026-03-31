package org.example.prazashop.service;

import org.example.prazashop.model.dto.PedidoDto;

import java.util.List;
import java.util.Optional;

/**
 * Servicios de negocio relacionados con pedidos.
 */
public interface PedidoService {
    List<PedidoDto> findAll();
    Optional<PedidoDto> findById(Long id);
    PedidoDto create(PedidoDto pedido);
    PedidoDto update(Long id, PedidoDto pedido);
    void deleteById(Long id);
}
