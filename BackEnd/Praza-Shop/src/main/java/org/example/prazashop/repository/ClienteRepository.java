package org.example.prazashop.repository;

import org.example.prazashop.model.entity.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * The interface Cliente repository.
 */
public interface ClienteRepository extends JpaRepository<Cliente, Long> {
    /**
     * Busca un cliente por el id de usuario asociado.
     *
     * @param usuarioId id del usuario
     * @return cliente encontrado
     */
    Optional<Cliente> findByUsuario_Id(Long usuarioId);
}
