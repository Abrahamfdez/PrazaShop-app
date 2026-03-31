package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.PedidoDto;
import org.example.prazashop.model.entity.Cliente;
import org.example.prazashop.model.entity.Negocio;
import org.example.prazashop.model.entity.Pedido;
import org.example.prazashop.repository.ClienteRepository;
import org.example.prazashop.repository.NegocioRepository;
import org.example.prazashop.repository.PedidoRepository;
import org.example.prazashop.service.PedidoService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class PedidoServiceImpl implements PedidoService {

    private final PedidoRepository pedidoRepository;
    private final ClienteRepository clienteRepository;
    private final NegocioRepository negocioRepository;

    @Override
    @Transactional(readOnly = true)
    public List<PedidoDto> findAll() {
        return pedidoRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<PedidoDto> findById(Long id) {
        return pedidoRepository.findById(id).map(this::toDto);
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
        pedido.setDataConfirmacion(dto.getDataConfirmacion());
        pedido.setDataEntrega(dto.getDataEntrega());
        pedido.setDataCancelacion(dto.getDataCancelacion());
        pedido.setEstado(dto.getEstado());
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
}
