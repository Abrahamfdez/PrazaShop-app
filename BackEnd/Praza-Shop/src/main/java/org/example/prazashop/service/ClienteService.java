package org.example.prazashop.service;

import org.example.prazashop.model.dto.ClienteDto;

import java.util.List;
import java.util.Optional;

/**
 * Operaciones de negocio para la gestión de clientes.
 */
public interface ClienteService {
    List<ClienteDto> findAll();
    Optional<ClienteDto> findById(Long id);
    ClienteDto create(ClienteDto cliente);
    ClienteDto update(Long id, ClienteDto cliente);
    void deleteById(Long id);
}
