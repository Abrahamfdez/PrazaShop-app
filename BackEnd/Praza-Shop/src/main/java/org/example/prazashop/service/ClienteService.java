package org.example.prazashop.service;

import org.example.prazashop.model.dto.ClienteDto;

import java.util.List;
import java.util.Optional;

/**
 * Operaciones de negocio para la gestión de clientes.
 */
public interface ClienteService {
    /**
     * Find all list.
     *
     * @return the list
     */
    List<ClienteDto> findAll();

    /**
     * Find by id optional.
     *
     * @param id the id
     * @return the optional
     */
    ClienteDto findById(Long id);

    /**
     * Create cliente dto.
     *
     * @param cliente the cliente
     * @return the cliente dto
     */
    ClienteDto create(ClienteDto cliente);

    /**
     * Update cliente dto.
     *
     * @param id      the id
     * @param cliente the cliente
     * @return the cliente dto
     */
    ClienteDto update(Long id, ClienteDto cliente);

    /**
     * Delete by id.
     *
     * @param id the id
     */
    void deleteById(Long id);

    /**
     * Busca un cliente por el id de usuario asociado.
     *
     * @param usuarioId id del usuario
     * @return cliente encontrado
     */
    Optional<ClienteDto> findByUsuarioId(Long usuarioId);
}
