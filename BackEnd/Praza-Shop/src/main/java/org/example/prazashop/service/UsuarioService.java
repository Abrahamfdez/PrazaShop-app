package org.example.prazashop.service;

import org.example.prazashop.exception.NoContentException;
import org.example.prazashop.model.dto.UsuarioDto;

import java.util.List;

/**
 * API de servicios alrededor de usuarios.
 */
public interface UsuarioService {
    /**
     * Find all list.
     *
     * @return the list
     */
    List<UsuarioDto> findAll();

    /**
     * Busca un usuario por su id. Lanza NoContentException si no se encuentra.
     *
     * @param id the id
     * @return el usuario encontrado
     * @throws NoContentException si no se encuentra el usuario
     */
    UsuarioDto findById(Long id);

    /**
     * Create usuario dto.
     *
     * @param usuario the usuario
     * @return the usuario dto
     */
    UsuarioDto create(UsuarioDto usuario);

    /**
     * Update usuario dto.
     *
     * @param id      the id
     * @param usuario the usuario
     * @return the usuario dto
     */
    UsuarioDto update(Long id, UsuarioDto usuario);

    /**
     * Delete by id.
     *
     * @param id the id
     */
    void deleteById(Long id);
}
