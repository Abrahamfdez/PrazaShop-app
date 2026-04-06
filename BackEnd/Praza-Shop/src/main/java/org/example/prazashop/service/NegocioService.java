package org.example.prazashop.service;

import org.example.prazashop.model.dto.NegocioDto;

import java.util.List;
import java.util.Optional;

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
     * Find by id optional.
     *
     * @param id the id
     * @return the optional
     */
    Optional<NegocioDto> findById(Long id);

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
}
