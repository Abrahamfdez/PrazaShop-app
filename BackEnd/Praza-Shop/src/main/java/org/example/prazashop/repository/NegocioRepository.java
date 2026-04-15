package org.example.prazashop.repository;

import org.example.prazashop.model.entity.Negocio;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * The interface Negocio repository.
 */
public interface NegocioRepository extends JpaRepository<Negocio, Long> {
    /**
     * Busca un negocio por el id de usuario asociado.
     *
     * @param usuarioId id del usuario
     * @return negocio encontrado
     */
    Optional<Negocio> findByUsuario_Id(Long usuarioId);
}
