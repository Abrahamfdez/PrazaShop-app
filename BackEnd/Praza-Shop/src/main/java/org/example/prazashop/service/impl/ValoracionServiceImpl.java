package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.ValoracionDto;
import org.example.prazashop.model.entity.Cliente;
import org.example.prazashop.model.entity.Negocio;
import org.example.prazashop.model.entity.Valoracion;
import org.example.prazashop.repository.ClienteRepository;
import org.example.prazashop.repository.NegocioRepository;
import org.example.prazashop.repository.ValoracionRepository;
import org.example.prazashop.service.ValoracionService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * The type Valoracion service.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class ValoracionServiceImpl implements ValoracionService {

    private final ValoracionRepository valoracionRepository;
    private final ClienteRepository clienteRepository;
    private final NegocioRepository negocioRepository;

    @Override
    @Transactional(readOnly = true)
    public List<ValoracionDto> findAll() {
        return valoracionRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ValoracionDto> findById(Long id) {
        return valoracionRepository.findById(id).map(this::toDto);
    }

    @Override
    public ValoracionDto create(ValoracionDto valoracion) {
        validateDto(valoracion);
        Valoracion entity = new Valoracion();
        applyDto(entity, valoracion);
        return toDto(valoracionRepository.save(entity));
    }

    @Override
    public ValoracionDto update(Long id, ValoracionDto valoracion) {
        Valoracion existing = valoracionRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Valoración no encontrada con id " + id));
        validateDto(valoracion);
        applyDto(existing, valoracion);
        return toDto(valoracionRepository.save(existing));
    }

    @Override
    public void deleteById(Long id) {
        if (!valoracionRepository.existsById(id)) {
            throw new NotFoundException("Valoración no encontrada con id " + id);
        }
        valoracionRepository.deleteById(id);
    }

    private ValoracionDto toDto(Valoracion valoracion) {
        return ValoracionDto.builder()
                .id(valoracion.getIdValoracion())
                .clienteId(valoracion.getCliente() != null ? valoracion.getCliente().getIdCliente() : null)
                .negocioId(valoracion.getNegocio() != null ? valoracion.getNegocio().getIdNegocio() : null)
                .puntuacion(valoracion.getPuntuacion())
                .comentario(valoracion.getComentario())
                .dataValoracion(valoracion.getDataValoracion())
                .build();
    }

    private void applyDto(Valoracion valoracion, ValoracionDto dto) {
        if (dto.getClienteId() != null) {
            Cliente cliente = clienteRepository.findById(dto.getClienteId())
                    .orElseThrow(() -> new NotFoundException("Cliente no encontrado con id " + dto.getClienteId()));
            valoracion.setCliente(cliente);
        } else if (valoracion.getCliente() == null) {
            throw new BadRequestException("clienteId es obligatorio");
        }

        if (dto.getNegocioId() != null) {
            Negocio negocio = negocioRepository.findById(dto.getNegocioId())
                    .orElseThrow(() -> new NotFoundException("Negocio no encontrado con id " + dto.getNegocioId()));
            valoracion.setNegocio(negocio);
        } else if (valoracion.getNegocio() == null) {
            throw new BadRequestException("negocioId es obligatorio");
        }

        valoracion.setPuntuacion(dto.getPuntuacion());
        valoracion.setComentario(dto.getComentario());
        valoracion.setDataValoracion(dto.getDataValoracion());
    }

    private void validateDto(ValoracionDto dto) {
        if (dto == null) {
            throw new BadRequestException("El cuerpo de valoración es obligatorio");
        }
        if (dto.getPuntuacion() == null || dto.getPuntuacion() < 1 || dto.getPuntuacion() > 5) {
            throw new BadRequestException("puntuacion debe estar entre 1 y 5");
        }
    }
}
