package org.example.prazashop.repository;

import org.example.prazashop.model.entity.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * The interface Cliente repository.
 */
public interface ClienteRepository extends JpaRepository<Cliente, Long> {
}
