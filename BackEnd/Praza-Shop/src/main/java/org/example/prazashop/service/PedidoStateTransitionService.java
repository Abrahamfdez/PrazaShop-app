package org.example.prazashop.service;

import org.example.prazashop.exception.ConflictException;
import org.example.prazashop.model.entity.DetallePedido;
import org.example.prazashop.model.entity.Pedido;
import org.example.prazashop.model.entity.Producto;
import org.example.prazashop.model.entity.StockMovimiento;
import org.example.prazashop.repository.ProductoRepository;
import org.example.prazashop.repository.StockMovimientoRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * Servicio de máquina de estados para transiciones de pedidos.
 * Centraliza la lógica de cambios de estado incluyendo validaciones de stock y auditoría.
 */
@Service
@Transactional
public class PedidoStateTransitionService {

    private static final Logger log = LoggerFactory.getLogger(PedidoStateTransitionService.class);

    private final ProductoRepository productoRepository;
    private final StockMovimientoRepository stockMovimientoRepository;

    public PedidoStateTransitionService(
            ProductoRepository productoRepository,
            StockMovimientoRepository stockMovimientoRepository) {
        this.productoRepository = productoRepository;
        this.stockMovimientoRepository = stockMovimientoRepository;
    }

    /**
     * Transición a PENDIENTE: Reserva stock para cada detalle.
     *
     * @param pedido the pedido
     * @throws ConflictException si no hay stock disponible
     */
    public void transitionToPendiente(Pedido pedido) throws ConflictException {
        if (pedido.getDetalles() == null || pedido.getDetalles().isEmpty()) {
            throw new ConflictException("El pedido debe tener al menos un detalle");
        }

        // Validar y reservar stock
        for (DetallePedido detalle : pedido.getDetalles()) {
            Producto producto = detalle.getProducto();
            if (producto.getStock() < detalle.getCantidade()) {
                throw new ConflictException(
                    String.format(
                        "Stock insuficiente para %s. Disponible: %d, Solicitado: %d",
                        producto.getNome(),
                        producto.getStock(),
                        detalle.getCantidade()
                    )
                );
            }

            // Registrar RESERVA en auditoría
            StockMovimiento movimiento = StockMovimiento.builder()
                    .producto(producto)
                    .pedido(pedido)
                    .tipo(StockMovimiento.TipoMovimiento.RESERVA)
                    .cantidad(detalle.getCantidade())
                    .notas("Stock reservado al crear pedido")
                    .build();
            stockMovimientoRepository.save(movimiento);
            log.info("Stock reservado: {} unidades de {} para pedido #{}", 
                    detalle.getCantidade(), producto.getNome(), pedido.getIdPedido());
        }

        pedido.setEstado("PENDIENTE");
    }

    /**
     * Transición a CONFIRMADO: Valida y decrementa stock de verdad.
     *
     * @param pedido the pedido
     * @throws ConflictException si no hay stock disponible
     */
    public void transitionToConfirmado(Pedido pedido) throws ConflictException {
        if (!"PENDIENTE".equals(pedido.getEstado())) {
            throw new ConflictException("Solo se pueden confirmar pedidos en estado PENDIENTE");
        }

        // Validar que todavía hay stock disponible
        for (DetallePedido detalle : pedido.getDetalles()) {
            Producto producto = detalle.getProducto();
            if (producto.getStock() < detalle.getCantidade()) {
                throw new ConflictException(
                    String.format(
                        "Stock insuficiente para confirmar %s. Disponible: %d, Requerido: %d",
                        producto.getNome(),
                        producto.getStock(),
                        detalle.getCantidade()
                    )
                );
            }
        }

        // Decrement stock de verdad
        for (DetallePedido detalle : pedido.getDetalles()) {
            Producto producto = detalle.getProducto();
            producto.setStock(producto.getStock() - detalle.getCantidade());
            productoRepository.save(producto);

            // Registrar CONFIRMACION en auditoría
            StockMovimiento movimiento = StockMovimiento.builder()
                    .producto(producto)
                    .pedido(pedido)
                    .tipo(StockMovimiento.TipoMovimiento.CONFIRMACION)
                    .cantidad(detalle.getCantidade())
                    .notas("Stock confirmado y decrementado")
                    .build();
            stockMovimientoRepository.save(movimiento);
            log.info("Stock decrementado: {} unidades de {} al confirmar pedido #{}", 
                    detalle.getCantidade(), producto.getNome(), pedido.getIdPedido());
        }

        pedido.setEstado("CONFIRMADO");
        pedido.setDataConfirmacion(LocalDateTime.now());
    }

    /**
     * Transición a ENTREGADO: Solo actualiza el timestamp.
     *
     * @param pedido the pedido
     * @throws ConflictException si no está en CONFIRMADO
     */
    public void transitionToEntregado(Pedido pedido) throws ConflictException {
        if (!"CONFIRMADO".equals(pedido.getEstado())) {
            throw new ConflictException("Solo se pueden entregar pedidos en estado CONFIRMADO");
        }

        pedido.setEstado("ENTREGADO");
        pedido.setDataEntrega(LocalDateTime.now());
        log.info("Pedido #{} entregado", pedido.getIdPedido());
    }

    /**
     * Transición a CANCELADO: Libera stock si estaba confirmado.
     *
     * @param pedido the pedido
     * @throws ConflictException si no se puede cancelar
     */
    public void transitionToCancelado(Pedido pedido) throws ConflictException {
        String estadoActual = pedido.getEstado();
        if (!"PENDIENTE".equals(estadoActual) && !"CONFIRMADO".equals(estadoActual)) {
            throw new ConflictException("No se puede cancelar un pedido en estado " + estadoActual);
        }

        // Si estaba CONFIRMADO, liberar stock
        if ("CONFIRMADO".equals(estadoActual)) {
            for (DetallePedido detalle : pedido.getDetalles()) {
                Producto producto = detalle.getProducto();
                producto.setStock(producto.getStock() + detalle.getCantidade());
                productoRepository.save(producto);

                // Registrar LIBERACION en auditoría
                StockMovimiento movimiento = StockMovimiento.builder()
                        .producto(producto)
                        .pedido(pedido)
                        .tipo(StockMovimiento.TipoMovimiento.LIBERACION)
                        .cantidad(detalle.getCantidade())
                        .notas("Stock liberado al cancelar pedido CONFIRMADO")
                        .build();
                stockMovimientoRepository.save(movimiento);
                log.info("Stock liberado: {} unidades de {} al cancelar pedido #{}", 
                        detalle.getCantidade(), producto.getNome(), pedido.getIdPedido());
            }
        }

        pedido.setEstado("CANCELADO");
        pedido.setDataCancelacion(LocalDateTime.now());
    }
}
