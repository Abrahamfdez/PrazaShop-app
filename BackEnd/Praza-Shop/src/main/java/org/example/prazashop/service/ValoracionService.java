package org.example.prazashop.service;

import org.example.prazashop.model.dto.ValoracionDto;

import java.util.List;

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
     * Busca una valoración por su id. Lanza NoContentException si no se encuentra.
     *
     * @param id the id
     * @return valoración encontrada
     * @throws NoContentException si no se encuentra la valoración
     */
    ValoracionDto findById(Long id);

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

    /**
     * Obtiene la cantidad de valoraciones de un negocio.
     *
     * @param negocioId id del negocio
     * @return cantidad de valoraciones
     */
    Long getCountValoracionesByNegocioId(Long negocioId);

    /**
     * Obtiene la media de puntuación de un negocio.
     *
     * @param negocioId id del negocio
     * @return media de puntuación
     */
    Double getAveragePuntuacionByNegocioId(Long negocioId);
}
