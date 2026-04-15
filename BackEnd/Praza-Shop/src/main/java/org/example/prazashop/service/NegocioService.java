package org.example.prazashop.service;

import org.example.prazashop.exception.NoContentException;
import org.example.prazashop.model.dto.NegocioDto;

import java.util.List;

/**
 * Contrato de operaciones para la gestión de negocios.
 */
public interface NegocioService {
    /**
     * Find all list.
     *
     * @return the list
     */
    List<NegocioDto> findAll();

    /**
     * Busca un negocio por su id. Lanza NoContentException si no se encuentra.
     *
     * @param id the id
     * @return negocio encontrado
     * @throws NoContentException si no se encuentra el negocio
     */
    NegocioDto findById(Long id);

    /**
     * Create negocio dto.
     *
     * @param negocio the negocio
     * @return the negocio dto
     */
    NegocioDto create(NegocioDto negocio);

    /**
     * Update negocio dto.
     *
     * @param id      the id
     * @param negocio the negocio
     * @return the negocio dto
     */
    NegocioDto update(Long id, NegocioDto negocio);

    /**
     * Delete by id.
     *
     * @param id the id
     */
    void deleteById(Long id);

    /**
     * Busca un negocio por el id de usuario asociado. Lanza NoContentException si no se encuentra.
     *
     * @param usuarioId id del usuario
     * @return negocio encontrado
     * @throws NoContentException si no se encuentra el negocio
     */
    NegocioDto findByUsuarioId(Long usuarioId);
}
