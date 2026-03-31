package org.example.prazashop.service;

import org.example.prazashop.model.dto.DetallePedidoDto;

import java.util.List;
import java.util.Optional;

/**
 * Servicio para la lógica asociada a los detalles de pedido.
 */
public interface DetallePedidoService {
    List<DetallePedidoDto> findAll();
    Optional<DetallePedidoDto> findById(Long id);
    DetallePedidoDto create(DetallePedidoDto detallePedido);
    DetallePedidoDto update(Long id, DetallePedidoDto detallePedido);
    void deleteById(Long id);
}
