package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.UsuarioDto;
import org.example.prazashop.model.entity.Usuario;
import org.example.prazashop.repository.UsuarioRepository;
import org.example.prazashop.service.UsuarioService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class UsuarioServiceImpl implements UsuarioService {

    private final UsuarioRepository usuarioRepository;

    @Override
    @Transactional(readOnly = true)
    public List<UsuarioDto> findAll() {
        return usuarioRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<UsuarioDto> findById(Long id) {
        return usuarioRepository.findById(id).map(this::toDto);
    }

    @Override
    public UsuarioDto create(UsuarioDto usuario) {
        validateDto(usuario);
        Usuario entity = new Usuario();
        applyDto(entity, usuario);
        return toDto(usuarioRepository.save(entity));
    }

    @Override
    public UsuarioDto update(Long id, UsuarioDto usuario) {
        Usuario existing = usuarioRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Usuario no encontrado con id " + id));
        validateDto(usuario);
        applyDto(existing, usuario);
        return toDto(usuarioRepository.save(existing));
    }

    @Override
    public void deleteById(Long id) {
        if (!usuarioRepository.existsById(id)) {
            throw new NotFoundException("Usuario no encontrado con id " + id);
        }
        usuarioRepository.deleteById(id);
    }

    private UsuarioDto toDto(Usuario usuario) {
        return UsuarioDto.builder()
                .id(usuario.getId())
                .nome(usuario.getNome())
                .email(usuario.getEmail())
                .contrasinal(usuario.getContrasinal())
                .telefono(usuario.getTelefono())
                .tipoUsuario(usuario.getTipoUsuario())
                .build();
    }

    private void applyDto(Usuario usuario, UsuarioDto dto) {
        usuario.setNome(dto.getNome());
        usuario.setEmail(dto.getEmail());
        usuario.setContrasinal(dto.getContrasinal());
        usuario.setTelefono(dto.getTelefono());
        usuario.setTipoUsuario(dto.getTipoUsuario());
    }

    private void validateDto(UsuarioDto dto) {
        if (dto == null) {
            throw new BadRequestException("El cuerpo de usuario es obligatorio");
        }
        if (!StringUtils.hasText(dto.getEmail())) {
            throw new BadRequestException("email es obligatorio");
        }
        if (!StringUtils.hasText(dto.getContrasinal())) {
            throw new BadRequestException("contrasinal es obligatorio");
        }
        if (dto.getTipoUsuario() == null) {
            throw new BadRequestException("tipoUsuario es obligatorio");
        }
    }
}
