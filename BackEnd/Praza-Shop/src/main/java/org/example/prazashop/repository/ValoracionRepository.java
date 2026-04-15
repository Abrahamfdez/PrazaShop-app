package org.example.prazashop.repository;

import org.example.prazashop.model.entity.Valoracion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * The interface Valoracion repository.
 */
public interface ValoracionRepository extends JpaRepository<Valoracion, Long> {
    /**
     * Busca valoraciones por id de negocio.
     *
     * @param negocioId id del negocio
     * @return lista de valoraciones
     */
    List<Valoracion> findByNegocio_IdNegocio(Long negocioId);

    /**
     * Busca valoraciones por id de cliente.
     *
     * @param clienteId id del cliente
     * @return lista de valoraciones
     */
    List<Valoracion> findByCliente_IdCliente(Long clienteId);
}
