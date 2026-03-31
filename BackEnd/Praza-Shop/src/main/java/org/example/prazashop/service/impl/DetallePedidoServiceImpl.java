package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.DetallePedidoDto;
import org.example.prazashop.model.entity.DetallePedido;
import org.example.prazashop.model.entity.Pedido;
import org.example.prazashop.model.entity.Producto;
import org.example.prazashop.repository.DetallePedidoRepository;
import org.example.prazashop.repository.PedidoRepository;
import org.example.prazashop.repository.ProductoRepository;
import org.example.prazashop.service.DetallePedidoService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class DetallePedidoServiceImpl implements DetallePedidoService {

    private final DetallePedidoRepository detallePedidoRepository;
    private final PedidoRepository pedidoRepository;
    private final ProductoRepository productoRepository;

    @Override
    @Transactional(readOnly = true)
    public List<DetallePedidoDto> findAll() {
        return detallePedidoRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<DetallePedidoDto> findById(Long id) {
        return detallePedidoRepository.findById(id).map(this::toDto);
    }

    @Override
    public DetallePedidoDto create(DetallePedidoDto detallePedido) {
        validateDto(detallePedido);
        DetallePedido entity = new DetallePedido();
        applyDto(entity, detallePedido);
        return toDto(detallePedidoRepository.save(entity));
    }

    @Override
    public DetallePedidoDto update(Long id, DetallePedidoDto detallePedido) {
        DetallePedido existing = detallePedidoRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Detalle de pedido no encontrado con id " + id));
        validateDto(detallePedido);
        applyDto(existing, detallePedido);
        return toDto(detallePedidoRepository.save(existing));
    }

    @Override
    public void deleteById(Long id) {
        if (!detallePedidoRepository.existsById(id)) {
            throw new NotFoundException("Detalle de pedido no encontrado con id " + id);
        }
        detallePedidoRepository.deleteById(id);
    }

    private DetallePedidoDto toDto(DetallePedido detallePedido) {
        return DetallePedidoDto.builder()
                .id(detallePedido.getIdDetalle())
                .pedidoId(detallePedido.getPedido() != null ? detallePedido.getPedido().getIdPedido() : null)
                .productoId(detallePedido.getProducto() != null ? detallePedido.getProducto().getIdProducto() : null)
                .cantidade(detallePedido.getCantidade())
                .prezoUnitario(detallePedido.getPrezoUnitario())
                .build();
    }

    private void applyDto(DetallePedido entity, DetallePedidoDto dto) {
        if (dto.getPedidoId() != null) {
            Pedido pedido = pedidoRepository.findById(dto.getPedidoId())
                    .orElseThrow(() -> new NotFoundException("Pedido no encontrado con id " + dto.getPedidoId()));
            entity.setPedido(pedido);
        } else if (entity.getPedido() == null) {
            throw new BadRequestException("pedidoId es obligatorio");
        }

        if (dto.getProductoId() != null) {
            Producto producto = productoRepository.findById(dto.getProductoId())
                    .orElseThrow(() -> new NotFoundException("Producto no encontrado con id " + dto.getProductoId()));
            entity.setProducto(producto);
        } else if (entity.getProducto() == null) {
            throw new BadRequestException("productoId es obligatorio");
        }
        entity.setCantidade(dto.getCantidade());
        entity.setPrezoUnitario(dto.getPrezoUnitario());
    }

    private void validateDto(DetallePedidoDto dto) {
        if (dto == null) {
            throw new BadRequestException("El cuerpo de detalle de pedido es obligatorio");
        }
        if (dto.getCantidade() == null || dto.getCantidade() <= 0) {
            throw new BadRequestException("cantidade debe ser mayor a 0");
        }
        if (dto.getPrezoUnitario() == null || dto.getPrezoUnitario() < 0) {
            throw new BadRequestException("prezoUnitario debe ser mayor o igual a 0");
        }
    }
}
