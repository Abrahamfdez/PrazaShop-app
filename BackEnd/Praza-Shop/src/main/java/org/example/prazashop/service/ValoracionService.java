package org.example.prazashop.service;

import org.example.prazashop.model.dto.ValoracionDto;

import java.util.List;
import java.util.Optional;

/**
 * Define las operaciones de negocio para valoraciones.
 */
public interface ValoracionService {
    /**
     * Find all list.
     *
     * @return the list
     */
    List<ValoracionDto> findAll();

    /**
     * Find by id optional.
     *
     * @param id the id
     * @return the optional
     */
    Optional<ValoracionDto> findById(Long id);

    /**
     * Create valoracion dto.
     *
     * @param valoracion the valoracion
     * @return the valoracion dto
     */
    ValoracionDto create(ValoracionDto valoracion);

    /**
     * Update valoracion dto.
     *
     * @param id         the id
     * @param valoracion the valoracion
     * @return the valoracion dto
     */
    ValoracionDto update(Long id, ValoracionDto valoracion);

    /**
     * Delete by id.
     *
     * @param id the id
     */
    void deleteById(Long id);

    /**
     * Busca valoraciones por id de negocio.
     *
     * @param negocioId id del negocio
     * @return lista de valoraciones
     */
    List<ValoracionDto> findByNegocioId(Long negocioId);

    /**
     * Busca valoraciones por id de cliente.
     *
     * @param clienteId id del cliente
     * @return lista de valoraciones
     */
    List<ValoracionDto> findByClienteId(Long clienteId);
}
