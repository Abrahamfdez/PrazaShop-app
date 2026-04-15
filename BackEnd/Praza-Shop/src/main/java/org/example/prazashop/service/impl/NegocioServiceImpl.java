package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NoContentException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.NegocioDto;
import org.example.prazashop.model.entity.Negocio;
import org.example.prazashop.model.entity.Usuario;
import org.example.prazashop.repository.NegocioRepository;
import org.example.prazashop.repository.UsuarioRepository;
import org.example.prazashop.service.NegocioService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * The type Negocio service.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class NegocioServiceImpl implements NegocioService {

    private final NegocioRepository negocioRepository;
    private final UsuarioRepository usuarioRepository;

    @Override
    @Transactional(readOnly = true)
    public List<NegocioDto> findAll() {
        return negocioRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public NegocioDto findById(Long id) {
        return negocioRepository.findById(id)
                .map(this::toDto)
                .orElseThrow(() -> new NoContentException("Negocio no encontrado"));
    }

    @Override
    public NegocioDto create(NegocioDto negocio) {
        validateDto(negocio);
        Negocio entity = new Negocio();
        applyDto(entity, negocio);
        return toDto(negocioRepository.save(entity));
    }

    @Override
    public NegocioDto update(Long id, NegocioDto negocio) {
        Negocio existing = negocioRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Negocio no encontrado con id " + id));
        validateDto(negocio);
        applyDto(existing, negocio);
        return toDto(negocioRepository.save(existing));
    }

    @Override
    public void deleteById(Long id) {
        if (!negocioRepository.existsById(id)) {
            throw new NotFoundException("Negocio no encontrado con id " + id);
        }
        negocioRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public NegocioDto findByUsuarioId(Long usuarioId) {
        return negocioRepository.findByUsuario_Id(usuarioId)
                .map(this::toDto)
                .orElseThrow(() -> new NoContentException("Negocio no encontrado para el usuario"));
    }

    private NegocioDto toDto(Negocio negocio) {
        return NegocioDto.builder()
                .id(negocio.getIdNegocio())
                .usuarioId(negocio.getUsuario() != null ? negocio.getUsuario().getId() : null)
                .nomeNegocio(negocio.getNomeNegocio())
                .direccion(negocio.getDireccion())
                .descricion(negocio.getDescricion())
                .build();
    }

    private void applyDto(Negocio negocio, NegocioDto dto) {
        if (dto.getUsuarioId() != null) {
            Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                    .orElseThrow(() -> new NotFoundException("Usuario no encontrado con id " + dto.getUsuarioId()));
            negocio.setUsuario(usuario);
        } else if (negocio.getUsuario() == null) {
            throw new BadRequestException("usuarioId es obligatorio");
        }
        negocio.setNomeNegocio(dto.getNomeNegocio());
        negocio.setDireccion(dto.getDireccion());
        negocio.setDescricion(dto.getDescricion());
    }

    private void validateDto(NegocioDto dto) {
        if (dto == null) {
            throw new BadRequestException("El cuerpo de negocio es obligatorio");
        }
        if (!StringUtils.hasText(dto.getNomeNegocio())) {
            throw new BadRequestException("nomeNegocio es obligatorio");
        }
        if (!StringUtils.hasText(dto.getDireccion())) {
            throw new BadRequestException("direccion es obligatoria");
        }
    }
}
