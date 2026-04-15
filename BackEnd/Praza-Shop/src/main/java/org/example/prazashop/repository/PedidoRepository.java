package org.example.prazashop.repository;

import org.example.prazashop.model.entity.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * The interface Pedido repository.
 */
public interface PedidoRepository extends JpaRepository<Pedido, Long> {
    /**
     * Busca pedidos por id de cliente.
     *
     * @param clienteId id del cliente
     * @return lista de pedidos
     */
    List<Pedido> findByCliente_IdCliente(Long clienteId);

    /**
     * Busca pedidos por id de negocio.
     *
     * @param negocioId id del negocio
     * @return lista de pedidos
     */
    List<Pedido> findByNegocio_IdNegocio(Long negocioId);
}
