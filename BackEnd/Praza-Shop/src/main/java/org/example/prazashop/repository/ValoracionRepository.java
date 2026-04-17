package org.example.prazashop.repository;

import org.example.prazashop.model.entity.Valoracion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

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

    /**
     * Cuenta el número de valoraciones de un negocio.
     *
     * @param negocioId id del negocio
     * @return cantidad de valoraciones
     */
    @Query("SELECT COUNT(v) FROM Valoracion v WHERE v.negocio.idNegocio = :negocioId")
    Long countByNegocioId(@Param("negocioId") Long negocioId);

    /**
     * Calcula la media de puntuación de un negocio.
     *
     * @param negocioId id del negocio
     * @return media de puntuación
     */
    @Query("SELECT AVG(v.puntuacion) FROM Valoracion v WHERE v.negocio.idNegocio = :negocioId")
    Double getAveragePuntuacionByNegocioId(@Param("negocioId") Long negocioId);
}
