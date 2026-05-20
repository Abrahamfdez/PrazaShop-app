package org.example.prazashop.repository;

import org.example.prazashop.model.entity.StockMovimiento;
import org.example.prazashop.model.entity.Producto;
import org.example.prazashop.model.entity.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StockMovimientoRepository extends JpaRepository<StockMovimiento, Long> {
    List<StockMovimiento> findByProducto(Producto producto);

    List<StockMovimiento> findByPedido(Pedido pedido);

    List<StockMovimiento> findByProductoAndTipo(Producto producto, StockMovimiento.TipoMovimiento tipo);
}
