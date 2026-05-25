package org.example.prazashop.repository;

import org.example.prazashop.model.entity.CompraRecorrente;
import org.example.prazashop.model.entity.Cliente;
import org.example.prazashop.model.entity.Producto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * The interface Compra recorrente repository.
 */
public interface CompraRecorrenteRepository extends JpaRepository<CompraRecorrente, Long> {
    /**
     * Find all compras recurrentes by cliente.
     *
     * @param cliente the cliente entity
     * @return the list of compras recurrentes
     */
    List<CompraRecorrente> findByCliente(Cliente cliente);

    /**
     * Find all compras recurrentes by producto.
     *
     * @param producto the producto entity
     * @return the list of compras recurrentes
     */
    List<CompraRecorrente> findByProducto(Producto producto);
}
