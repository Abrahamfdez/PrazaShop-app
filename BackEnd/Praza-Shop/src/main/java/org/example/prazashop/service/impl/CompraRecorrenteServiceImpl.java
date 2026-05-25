package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.CompraRecorrenteDto;
import org.example.prazashop.model.entity.Cliente;
import org.example.prazashop.model.entity.CompraRecorrente;
import org.example.prazashop.model.entity.Negocio;
import org.example.prazashop.model.entity.Producto;
import org.example.prazashop.repository.ClienteRepository;
import org.example.prazashop.repository.CompraRecorrenteRepository;
import org.example.prazashop.repository.ProductoRepository;
import org.example.prazashop.service.CompraRecorrenteService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;

/**
 * The type Compra recorrente service.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class CompraRecorrenteServiceImpl implements CompraRecorrenteService {

    private final CompraRecorrenteRepository compraRecorrenteRepository;
    private final ClienteRepository clienteRepository;
    private final ProductoRepository productoRepository;

    @Override
    @Transactional(readOnly = true)
    public List<CompraRecorrenteDto> findAll() {
        return compraRecorrenteRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<CompraRecorrenteDto> findById(Long id) {
        return compraRecorrenteRepository.findById(id).map(this::toDto);
    }

    @Override
    public CompraRecorrenteDto create(CompraRecorrenteDto compraRecorrente) {
        validateDto(compraRecorrente);
        CompraRecorrente entity = new CompraRecorrente();
        applyDto(entity, compraRecorrente);
        return toDto(compraRecorrenteRepository.save(entity));
    }

    @Override
    public CompraRecorrenteDto update(Long id, CompraRecorrenteDto compraRecorrente) {
        CompraRecorrente existing = compraRecorrenteRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Compra recorrente no encontrada con id " + id));
        validateDto(compraRecorrente);
        applyDto(existing, compraRecorrente);
        return toDto(compraRecorrenteRepository.save(existing));
    }

    @Override
    public void deleteById(Long id) {
        if (!compraRecorrenteRepository.existsById(id)) {
            throw new NotFoundException("Compra recorrente no encontrada con id " + id);
        }
        compraRecorrenteRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CompraRecorrenteDto> findByClienteId(Long clienteId) {
        Cliente cliente = clienteRepository.findById(clienteId)
                .orElseThrow(() -> new NotFoundException("Cliente no encontrado con id " + clienteId));
        return compraRecorrenteRepository.findByCliente(cliente).stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    public CompraRecorrenteDto createForCliente(CompraRecorrenteDto compraRecorrente, Long clienteId) {
        // Validar que el DTO venga sin clienteId o con el mismo del contexto
        if (compraRecorrente.getClienteId() != null && !compraRecorrente.getClienteId().equals(clienteId)) {
            throw new BadRequestException("No puedes crear compras recurrentes para otros clientes");
        }

        // Obtener el cliente del contexto
        Cliente cliente = clienteRepository.findById(clienteId)
                .orElseThrow(() -> new NotFoundException("Cliente no encontrado con id " + clienteId));

        // Forzar el clienteId al del contexto
        CompraRecorrenteDto dto = CompraRecorrenteDto.builder()
                .clienteId(clienteId)
                .productoId(compraRecorrente.getProductoId())
                .cantidade(compraRecorrente.getCantidade())
                .frecuencia(compraRecorrente.getFrecuencia())
                .dataInicio(compraRecorrente.getDataInicio())
                .estado(compraRecorrente.getEstado() != null ? compraRecorrente.getEstado() : "ACTIVO")
                .build();

        validateDto(dto);

        CompraRecorrente entity = new CompraRecorrente();
        applyDto(entity, dto);
        return toDto(compraRecorrenteRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public List<CompraRecorrenteDto> findByNegocioId(Long negocioId) {
        if (negocioId == null) {
            return java.util.Collections.emptyList();
        }
        
        // Obtener todas las compras recurrentes cuyos productos pertenecen al negocio
        // JPA sigue la relación: CompraRecorrente -> Producto -> Negocio
        return compraRecorrenteRepository.findByProducto_Negocio_IdNegocio(negocioId).stream()
                .map(this::toDto)
                .toList();
    }

    private CompraRecorrenteDto toDto(CompraRecorrente compraRecorrente) {
        return CompraRecorrenteDto.builder()
                .id(compraRecorrente.getIdRecorrente())
                .clienteId(compraRecorrente.getCliente() != null ? compraRecorrente.getCliente().getIdCliente() : null)
                .productoId(compraRecorrente.getProducto() != null ? compraRecorrente.getProducto().getIdProducto() : null)
                .cantidade(compraRecorrente.getCantidade())
                .frecuencia(compraRecorrente.getFrecuencia())
                .dataInicio(compraRecorrente.getDataInicio())
                .estado(compraRecorrente.getEstado())
                .build();
    }

    private void applyDto(CompraRecorrente entity, CompraRecorrenteDto dto) {
        if (dto.getClienteId() != null) {
            Cliente cliente = clienteRepository.findById(dto.getClienteId())
                    .orElseThrow(() -> new NotFoundException("Cliente no encontrado con id " + dto.getClienteId()));
            entity.setCliente(cliente);
        } else if (entity.getCliente() == null) {
            throw new BadRequestException("clienteId es obligatorio");
        }

        if (dto.getProductoId() != null) {
            Producto producto = productoRepository.findById(dto.getProductoId())
                    .orElseThrow(() -> new NotFoundException("Producto no encontrado con id " + dto.getProductoId()));
            entity.setProducto(producto);
        } else if (entity.getProducto() == null) {
            throw new BadRequestException("productoId es obligatorio");
        }
        entity.setCantidade(dto.getCantidade());
        entity.setFrecuencia(dto.getFrecuencia());
        entity.setDataInicio(dto.getDataInicio());
        entity.setEstado(dto.getEstado());
    }

    private void validateDto(CompraRecorrenteDto dto) {
        if (dto == null) {
            throw new BadRequestException("El cuerpo de compra recorrente es obligatorio");
        }
        if (dto.getCantidade() == null || dto.getCantidade() <= 0) {
            throw new BadRequestException("cantidade debe ser mayor a 0");
        }
        if (!StringUtils.hasText(dto.getFrecuencia())) {
            throw new BadRequestException("frecuencia es obligatoria");
        }
        if (dto.getDataInicio() == null) {
            throw new BadRequestException("dataInicio es obligatoria");
        }
    }

    @Override
    @Transactional
    public void deleteForCliente(Long id, Long clienteId) {
        // Obtener la compra recurrente
        CompraRecorrente compra = compraRecorrenteRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Compra recorrente no encontrada con id " + id));

        // Verificar que pertenece al cliente autenticado
        if (!compra.getCliente().getIdCliente().equals(clienteId)) {
            throw new BadRequestException("No puedes eliminar compras recurrentes de otros clientes");
        }

        compraRecorrenteRepository.deleteById(id);
    }
}
