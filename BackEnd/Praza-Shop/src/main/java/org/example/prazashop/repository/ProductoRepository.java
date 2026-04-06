package org.example.prazashop.repository;

import org.example.prazashop.model.entity.Producto;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * The interface Producto repository.
 */
public interface ProductoRepository extends JpaRepository<Producto, Long> {
}
