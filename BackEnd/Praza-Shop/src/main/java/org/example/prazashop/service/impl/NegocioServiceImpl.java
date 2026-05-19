package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NoContentException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.NegocioDto;
import org.example.prazashop.model.dto.PedidoConDetallesDto;
import org.example.prazashop.model.dto.NegocioDashboardDto;
import org.example.prazashop.model.dto.ProductoDto;
import org.example.prazashop.model.dto.PedidoDto;
import org.example.prazashop.model.entity.Negocio;
import org.example.prazashop.model.entity.Usuario;
import org.example.prazashop.repository.NegocioRepository;
import org.example.prazashop.repository.UsuarioRepository;
import org.example.prazashop.repository.ProductoRepository;
import org.example.prazashop.repository.PedidoRepository;
import org.example.prazashop.service.NegocioService;
import org.example.prazashop.service.ProductoService;
import org.example.prazashop.service.PedidoService;
import org.example.prazashop.service.ValoracionService;
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
    private final ProductoRepository productoRepository;
    private final PedidoRepository pedidoRepository;
    private final ProductoService productoService;
    private final PedidoService pedidoService;
    private final ValoracionService valoracionService;

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

    @Override
    @Transactional(readOnly = true)
    public NegocioDashboardDto getDashboard(Long negocioId) {
        // Obtener negocio
        Negocio negocio = negocioRepository.findById(negocioId)
                .orElseThrow(() -> new NotFoundException("Negocio no encontrado con id " + negocioId));

        // Obtener últimos 10 productos
        List<ProductoDto> productos = productoService.findByNegocioId(negocioId).stream()
                .limit(10)
                .toList();

        // Obtener últimos 10 pedidos
        List<PedidoConDetallesDto> pedidosRecientes = pedidoService.findByNegocioIdConDetalles(negocioId).stream()
                .limit(10)
                .toList();

        // Calcular estadísticas
        Double ratingPromedio = valoracionService.getAveragePuntuacionByNegocioId(negocioId);
        Long cantidadValoraciones = valoracionService.getCountValoracionesByNegocioId(negocioId);
        
        // Calcular ingresos totales
        Double ingresosTotales = pedidoService.findByNegocioId(negocioId).stream()
                .mapToDouble(p -> p.getTotal() != null ? p.getTotal() : 0.0)
                .sum();

        // Construir dashboard
        return NegocioDashboardDto.builder()
                .negocio(toDto(negocio))
                .productos(productos)
                .pedidosRecientes(pedidosRecientes)
                .stats(NegocioDashboardDto.DashboardStats.builder()
                        .ratingPromedio(ratingPromedio != null ? ratingPromedio : 0.0)
                        .totalVentasCount(pedidosRecientes.size())
                        .ingresosTotales(ingresosTotales)
                        .cantidadValoraciones(cantidadValoraciones != null ? cantidadValoraciones.intValue() : 0)
                        .build())
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isOwnerOfNegocio(Long negocioId, String email) {
        // Obtener negocio
        Negocio negocio = negocioRepository.findById(negocioId)
                .orElseThrow(() -> new NotFoundException("Negocio no encontrado con id " + negocioId));
        
        // Obtener usuario propietario del negocio
        Usuario usuario = negocio.getUsuario();
        if (usuario == null) {
            throw new NotFoundException("Usuario propietario no encontrado");
        }
        
        // Verificar si el email coincide
        return usuario.getEmail().equalsIgnoreCase(email);
    }
}
