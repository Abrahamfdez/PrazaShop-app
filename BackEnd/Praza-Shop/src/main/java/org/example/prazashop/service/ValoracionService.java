package org.example.prazashop.service;

import org.example.prazashop.model.dto.ValoracionDto;

import java.util.List;
import java.util.Optional;

/**
 * Define las operaciones de negocio para valoraciones.
 */
public interface ValoracionService {
    List<ValoracionDto> findAll();
    Optional<ValoracionDto> findById(Long id);
    ValoracionDto create(ValoracionDto valoracion);
    ValoracionDto update(Long id, ValoracionDto valoracion);
    void deleteById(Long id);
}
