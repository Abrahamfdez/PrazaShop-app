package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NoContentException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.PedidoDto;
import org.example.prazashop.model.dto.PedidoConDetallesDto;
import org.example.prazashop.model.dto.DetallePedidoConProductoDto;
import org.example.prazashop.model.dto.PedidoCreacionRequest;
import org.example.prazashop.model.dto.PedidoSearchResponse;
import org.example.prazashop.model.entity.Cliente;
import org.example.prazashop.model.entity.Negocio;
import org.example.prazashop.model.entity.Pedido;
import org.example.prazashop.model.entity.Producto;
import org.example.prazashop.model.entity.DetallePedido;
import org.example.prazashop.repository.ClienteRepository;
import org.example.prazashop.repository.NegocioRepository;
import org.example.prazashop.repository.PedidoRepository;
import org.example.prazashop.repository.ProductoRepository;
import org.example.prazashop.repository.DetallePedidoRepository;
import org.example.prazashop.service.PedidoService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;

/**
 * The type Pedido service.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class PedidoServiceImpl implements PedidoService {

    private final PedidoRepository pedidoRepository;
    private final ClienteRepository clienteRepository;
    private final NegocioRepository negocioRepository;
    private final ProductoRepository productoRepository;
    private final DetallePedidoRepository detallePedidoRepository;

    @Override
    @Transactional(readOnly = true)
    public List<PedidoDto> findAll() {
        return pedidoRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public PedidoDto findById(Long id) {
        return pedidoRepository.findById(id)
                .map(this::toDto)
                .orElseThrow(() -> new NoContentException("Pedido no encontrado"));
    }

    @Override
    public PedidoDto create(PedidoDto pedido) {
        validateDto(pedido);
        Pedido entity = new Pedido();
        applyDto(entity, pedido);
        return toDto(pedidoRepository.save(entity));
    }

    @Override
    public PedidoDto update(Long id, PedidoDto pedido) {
        Pedido existing = pedidoRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Pedido no encontrado con id " + id));
        validateDto(pedido);
        applyDto(existing, pedido);
        return toDto(pedidoRepository.save(existing));
    }

    @Override
    public void deleteById(Long id) {
        if (!pedidoRepository.existsById(id)) {
            throw new NotFoundException("Pedido no encontrado con id " + id);
        }
        pedidoRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PedidoDto> findByClienteId(Long clienteId) {
        return pedidoRepository.findByCliente_IdCliente(clienteId).stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<PedidoDto> findByNegocioId(Long negocioId) {
        return pedidoRepository.findByNegocio_IdNegocio(negocioId).stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<PedidoConDetallesDto> findByClienteIdConDetalles(Long clienteId) {
        return pedidoRepository.findByCliente_IdCliente(clienteId).stream()
                .map(this::toDtoConDetalles)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public List<PedidoConDetallesDto> findByNegocioIdConDetalles(Long negocioId) {
        return pedidoRepository.findByNegocio_IdNegocio(negocioId).stream()
                .map(this::toDtoConDetalles)
                .toList();
    }

    private PedidoDto toDto(Pedido pedido) {
        return PedidoDto.builder()
                .id(pedido.getIdPedido())
                .clienteId(pedido.getCliente() != null ? pedido.getCliente().getIdCliente() : null)
                .negocioId(pedido.getNegocio() != null ? pedido.getNegocio().getIdNegocio() : null)
                .dataPedido(pedido.getDataPedido())
                .dataConfirmacion(pedido.getDataConfirmacion())
                .dataEntrega(pedido.getDataEntrega())
                .dataCancelacion(pedido.getDataCancelacion())
                .estado(pedido.getEstado())
                .total(pedido.getTotal())
                .build();
    }

    private void applyDto(Pedido pedido, PedidoDto dto) {
    if (dto.getClienteId() != null) {
        Cliente cliente = clienteRepository.findById(dto.getClienteId())
                .orElseThrow(() -> new NotFoundException("Cliente no encontrado con id " + dto.getClienteId()));
        pedido.setCliente(cliente);
    } else if (pedido.getCliente() == null) {
        throw new BadRequestException("clienteId es obligatorio");
    }

    if (dto.getNegocioId() != null) {
        Negocio negocio = negocioRepository.findById(dto.getNegocioId())
                .orElseThrow(() -> new NotFoundException("Negocio no encontrado con id " + dto.getNegocioId()));
        pedido.setNegocio(negocio);
    } else if (pedido.getNegocio() == null) {
        throw new BadRequestException("negocioId es obligatorio");
    }

    pedido.setDataPedido(dto.getDataPedido());
    
    // Actualizar timestamps según el nuevo estado
    String nuevoEstado = dto.getEstado();
    String estadoAnterior = pedido.getEstado();
    
    if (nuevoEstado != null && !nuevoEstado.equals(estadoAnterior)) {
        java.time.LocalDateTime ahora = java.time.LocalDateTime.now();
        switch (nuevoEstado.toUpperCase()) {
            case "CONFIRMADO":
                pedido.setDataConfirmacion(ahora);
                break;
            case "ENTREGADO":
                pedido.setDataEntrega(ahora);
                break;
            case "CANCELADO":
                pedido.setDataCancelacion(ahora);
                break;
        }
    }
    
    // Preservar timestamps existentes si no cambian
    if (dto.getDataConfirmacion() != null) {
        pedido.setDataConfirmacion(dto.getDataConfirmacion());
    }
    if (dto.getDataEntrega() != null) {
        pedido.setDataEntrega(dto.getDataEntrega());
    }
    if (dto.getDataCancelacion() != null) {
        pedido.setDataCancelacion(dto.getDataCancelacion());
    }
    
    pedido.setEstado(nuevoEstado);
    pedido.setTotal(dto.getTotal());
}

    private void validateDto(PedidoDto dto) {
        if (dto == null) {
            throw new BadRequestException("El cuerpo de pedido es obligatorio");
        }
        if (dto.getDataPedido() == null) {
            throw new BadRequestException("dataPedido es obligatorio");
        }
        if (!StringUtils.hasText(dto.getEstado())) {
            throw new BadRequestException("estado es obligatorio");
        }
        if (dto.getTotal() == null || dto.getTotal() < 0) {
            throw new BadRequestException("total debe ser mayor o igual a 0");
        }
    }

    private PedidoConDetallesDto toDtoConDetalles(Pedido pedido) {
        List<DetallePedidoConProductoDto> detalles = pedido.getDetalles() != null ?
                pedido.getDetalles().stream()
                        .map(detalle -> DetallePedidoConProductoDto.builder()
                                .idDetalle(detalle.getIdDetalle())
                                .pedidoId(detalle.getPedido() != null ? detalle.getPedido().getIdPedido() : null)
                                .productoId(detalle.getProducto() != null ? detalle.getProducto().getIdProducto() : null)
                                .nombreProducto(detalle.getProducto() != null ? detalle.getProducto().getNome() : null)
                                .cantidade(detalle.getCantidade())
                                .prezoUnitario(detalle.getPrezoUnitario())
                                .subtotal(detalle.getCantidade() != null && detalle.getPrezoUnitario() != null ?
                                        detalle.getCantidade() * detalle.getPrezoUnitario() : null)
                                .build())
                        .toList()
                : List.of();

        return PedidoConDetallesDto.builder()
                .idPedido(pedido.getIdPedido())
                .clienteId(pedido.getCliente() != null ? pedido.getCliente().getIdCliente() : null)
                .negocioId(pedido.getNegocio() != null ? pedido.getNegocio().getIdNegocio() : null)
                .dataPedido(pedido.getDataPedido())
                .dataConfirmacion(pedido.getDataConfirmacion())
                .dataEntrega(pedido.getDataEntrega())
                .dataCancelacion(pedido.getDataCancelacion())
                .estado(pedido.getEstado())
                .total(pedido.getTotal())
                .detalles(detalles)
                .build();
    }

    @Override
    public PedidoConDetallesDto crearPedidoCompleto(PedidoCreacionRequest request) {
        if (request == null || request.getDetalles() == null || request.getDetalles().isEmpty()) {
            throw new BadRequestException("Debe incluir al menos un detalle de pedido");
        }

        // Validar cliente y negocio
        Cliente cliente = clienteRepository.findById(request.getClienteId())
                .orElseThrow(() -> new NotFoundException("Cliente no encontrado con id " + request.getClienteId()));
        
        Negocio negocio = negocioRepository.findById(request.getNegocioId())
                .orElseThrow(() -> new NotFoundException("Negocio no encontrado con id " + request.getNegocioId()));

        // Validar productos y calcular total
        Double total = 0.0;
        List<DetallePedido> detalles = new java.util.ArrayList<>();

        for (PedidoCreacionRequest.DetallePedidoRequest detaqueRequest : request.getDetalles()) {
            Producto producto = productoRepository.findById(detaqueRequest.getProductoId())
                    .orElseThrow(() -> new NotFoundException("Producto no encontrado con id " + detaqueRequest.getProductoId()));

            if (detaqueRequest.getCantidad() == null || detaqueRequest.getCantidad() <= 0) {
                throw new BadRequestException("Cantidad debe ser mayor a 0");
            }

            Double subtotal = producto.getPrezo() * detaqueRequest.getCantidad();
            total += subtotal;

            // Crear detalle (sin asociar aún al pedido)
            DetallePedido detalle = new DetallePedido();
            detalle.setProducto(producto);
            detalle.setCantidade(detaqueRequest.getCantidad());
            detalle.setPrezoUnitario(producto.getPrezo());
            detalles.add(detalle);
        }

        // Crear pedido
        Pedido pedido = new Pedido();
        pedido.setCliente(cliente);
        pedido.setNegocio(negocio);
        pedido.setDataPedido(LocalDateTime.now());
        pedido.setEstado("PENDIENTE");
        pedido.setTotal(total);

        // Guardar pedido
        Pedido pedidoGuardado = pedidoRepository.save(pedido);

        // Asociar detalles al pedido y guardar
        for (DetallePedido detalle : detalles) {
            detalle.setPedido(pedidoGuardado);
            detallePedidoRepository.save(detalle);
        }

        return toDtoConDetalles(pedidoGuardado);
    }

    @Override
    @Transactional(readOnly = true)
    public PedidoSearchResponse buscarPedidos(
            String estado,
            LocalDateTime fechaDesde,
            LocalDateTime fechaHasta,
            Double precioDesde,
            Double precioHasta,
            String ordenar,
            Integer pagina,
            Integer tamaño) {

        // Validar parámetros
        if (pagina == null || pagina < 0) pagina = 0;
        if (tamaño == null || tamaño <= 0) tamaño = 10;

        // Obtener todos los pedidos y filtrar en memoria (simplificado)
        List<Pedido> pedidos = pedidoRepository.findAll();

        // Aplicar filtros
        List<Pedido> filtrados = pedidos.stream()
                .filter(p -> estado == null || p.getEstado().equalsIgnoreCase(estado))
                .filter(p -> fechaDesde == null || p.getDataPedido().isAfter(fechaDesde))
                .filter(p -> fechaHasta == null || p.getDataPedido().isBefore(fechaHasta))
                .filter(p -> precioDesde == null || p.getTotal() >= precioDesde)
                .filter(p -> precioHasta == null || p.getTotal() <= precioHasta)
                .toList();

        // Aplicar ordenamiento
        List<Pedido> ordenados = filtrados;
        if (ordenar != null) {
            if ("fecha_asc".equalsIgnoreCase(ordenar)) {
                ordenados = filtrados.stream().sorted((a, b) -> a.getDataPedido().compareTo(b.getDataPedido())).toList();
            } else if ("fecha_desc".equalsIgnoreCase(ordenar)) {
                ordenados = filtrados.stream().sorted((a, b) -> b.getDataPedido().compareTo(a.getDataPedido())).toList();
            } else if ("total_asc".equalsIgnoreCase(ordenar)) {
                ordenados = filtrados.stream().sorted((a, b) -> a.getTotal().compareTo(b.getTotal())).toList();
            } else if ("total_desc".equalsIgnoreCase(ordenar)) {
                ordenados = filtrados.stream().sorted((a, b) -> b.getTotal().compareTo(a.getTotal())).toList();
            }
        }

        // Aplicar paginación
        int start = pagina * tamaño;
        int end = Math.min(start + tamaño, ordenados.size());
        List<PedidoDto> contenido = ordenados.subList(start, end).stream().map(this::toDto).toList();

        return PedidoSearchResponse.builder()
                .content(contenido)
                .pageNumber(pagina)
                .pageSize(tamaño)
                .totalElements((long) ordenados.size())
                .totalPages((ordenados.size() + tamaño - 1) / tamaño)
                .last(end >= ordenados.size())
                .build();
    }
}
