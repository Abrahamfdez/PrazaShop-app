package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.ClienteDto;
import org.example.prazashop.model.entity.Cliente;
import org.example.prazashop.model.entity.Usuario;
import org.example.prazashop.repository.ClienteRepository;
import org.example.prazashop.repository.UsuarioRepository;
import org.example.prazashop.service.ClienteService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;

/**
 * The type Cliente service.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class ClienteServiceImpl implements ClienteService {

    private final ClienteRepository clienteRepository;
    private final UsuarioRepository usuarioRepository;

    @Override
    @Transactional(readOnly = true)
    public List<ClienteDto> findAll() {
        return clienteRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<ClienteDto> findById(Long id) {
        return clienteRepository.findById(id).map(this::toDto);
    }

    @Override
    public ClienteDto create(ClienteDto cliente) {
        validateDto(cliente);
        Cliente entity = new Cliente();
        applyDto(entity, cliente);
        return toDto(clienteRepository.save(entity));
    }

    @Override
    public ClienteDto update(Long id, ClienteDto cliente) {
        Cliente existing = clienteRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Cliente no encontrado con id " + id));
        validateDto(cliente);
        applyDto(existing, cliente);
        return toDto(clienteRepository.save(existing));
    }

    @Override
    public void deleteById(Long id) {
        if (!clienteRepository.existsById(id)) {
            throw new NotFoundException("Cliente no encontrado con id " + id);
        }
        clienteRepository.deleteById(id);
    }

    private ClienteDto toDto(Cliente cliente) {
        return ClienteDto.builder()
                .id(cliente.getIdCliente())
                .usuarioId(cliente.getUsuario() != null ? cliente.getUsuario().getId() : null)
                .direccionEnvio(cliente.getDireccionEnvio())
                .build();
    }

    private void applyDto(Cliente cliente, ClienteDto dto) {
        if (dto.getUsuarioId() != null) {
            Usuario usuario = usuarioRepository.findById(dto.getUsuarioId())
                    .orElseThrow(() -> new NotFoundException("Usuario no encontrado con id " + dto.getUsuarioId()));
            cliente.setUsuario(usuario);
        } else if (cliente.getUsuario() == null) {
            throw new BadRequestException("usuarioId es obligatorio");
        }
        cliente.setDireccionEnvio(dto.getDireccionEnvio());
    }

    private void validateDto(ClienteDto dto) {
        if (dto == null) {
            throw new BadRequestException("El cuerpo de cliente es obligatorio");
        }
        if (!StringUtils.hasText(dto.getDireccionEnvio())) {
            throw new BadRequestException("direccionEnvio es obligatorio");
        }
    }
}
