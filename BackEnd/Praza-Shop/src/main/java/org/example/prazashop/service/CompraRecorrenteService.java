package org.example.prazashop.service;

import org.example.prazashop.model.dto.CompraRecorrenteDto;

import java.util.List;
import java.util.Optional;

/**
 * Define la API de negocio para compras recorrentes.
 */
public interface CompraRecorrenteService {
    /**
     * Find all list.
     *
     * @return the list
     */
    List<CompraRecorrenteDto> findAll();

    /**
     * Find by id optional.
     *
     * @param id the id
     * @return the optional
     */
    Optional<CompraRecorrenteDto> findById(Long id);

    /**
     * Create compra recorrente dto.
     *
     * @param compraRecorrente the compra recorrente
     * @return the compra recorrente dto
     */
    CompraRecorrenteDto create(CompraRecorrenteDto compraRecorrente);

    /**
     * Update compra recorrente dto.
     *
     * @param id               the id
     * @param compraRecorrente the compra recorrente
     * @return the compra recorrente dto
     */
    CompraRecorrenteDto update(Long id, CompraRecorrenteDto compraRecorrente);

    /**
     * Delete by id.
     *
     * @param id the id
     */
    void deleteById(Long id);
}
