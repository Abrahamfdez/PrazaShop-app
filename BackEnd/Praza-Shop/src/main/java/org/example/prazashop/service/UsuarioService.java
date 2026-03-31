package org.example.prazashop.service;

import org.example.prazashop.model.dto.UsuarioDto;

import java.util.List;
import java.util.Optional;

/**
 * API de servicios alrededor de usuarios.
 */
public interface UsuarioService {
    List<UsuarioDto> findAll();
    Optional<UsuarioDto> findById(Long id);
    UsuarioDto create(UsuarioDto usuario);
    UsuarioDto update(Long id, UsuarioDto usuario);
    void deleteById(Long id);
}
