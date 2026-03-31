package org.example.prazashop.service;

import org.example.prazashop.model.dto.CompraRecorrenteDto;

import java.util.List;
import java.util.Optional;

/**
 * Define la API de negocio para compras recorrentes.
 */
public interface CompraRecorrenteService {
    List<CompraRecorrenteDto> findAll();
    Optional<CompraRecorrenteDto> findById(Long id);
    CompraRecorrenteDto create(CompraRecorrenteDto compraRecorrente);
    CompraRecorrenteDto update(Long id, CompraRecorrenteDto compraRecorrente);
    void deleteById(Long id);
}
