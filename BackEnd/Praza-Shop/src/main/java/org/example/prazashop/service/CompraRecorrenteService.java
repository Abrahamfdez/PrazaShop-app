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

    /**
     * Find by cliente id (user-scoped endpoint).
     *
     * @param clienteId the cliente id
     * @return the list
     */
    List<CompraRecorrenteDto> findByClienteId(Long clienteId);

    /**
     * Create compra recurrente for authenticated cliente (user-scoped endpoint).
     *
     * @param compraRecorrente the compra recorrente
     * @param clienteId the cliente id (from context)
     * @return the compra recorrente dto
     */
    CompraRecorrenteDto createForCliente(CompraRecorrenteDto compraRecorrente, Long clienteId);

    /**
     * Find compras recurrentes by negocio id (user-scoped endpoint for business).
     *
     * @param negocioId the negocio id
     * @return list of compras recurrentes for that business's products
     */
    List<CompraRecorrenteDto> findByNegocioId(Long negocioId);

    /**
     * Delete compra recurrente for authenticated cliente (user-scoped endpoint).
     * Verifies that the compra recurrente belongs to the cliente before deleting.
     *
     * @param id the compra recorrente id
     * @param clienteId the cliente id (from context)
     */
    void deleteForCliente(Long id, Long clienteId);
}
