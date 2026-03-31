package org.example.prazashop.service;

import org.example.prazashop.model.dto.NegocioDto;

import java.util.List;
import java.util.Optional;

/**
 * Contrato de operaciones para la gestión de negocios.
 */
public interface NegocioService {
    List<NegocioDto> findAll();
    Optional<NegocioDto> findById(Long id);
    NegocioDto create(NegocioDto negocio);
    NegocioDto update(Long id, NegocioDto negocio);
    void deleteById(Long id);
}
