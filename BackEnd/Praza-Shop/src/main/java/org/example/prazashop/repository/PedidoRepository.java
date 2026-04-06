package org.example.prazashop.repository;

import org.example.prazashop.model.entity.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * The interface Pedido repository.
 */
public interface PedidoRepository extends JpaRepository<Pedido, Long> {
}
