package org.example.prazashop.repository;

import org.example.prazashop.model.entity.Producto;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * The interface Producto repository.
 */
public interface ProductoRepository extends JpaRepository<Producto, Long> {
    /**
     * Busca productos por id de negocio.
     *
     * @param negocioId id del negocio
     * @return lista de productos
     */
    List<Producto> findByNegocio_IdNegocio(Long negocioId);
}
