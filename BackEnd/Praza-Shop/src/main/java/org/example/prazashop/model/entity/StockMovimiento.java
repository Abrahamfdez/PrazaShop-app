package org.example.prazashop.model.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

/**
 * Auditoría de movimientos de stock: reservas, confirmaciones, liberaciones.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "stock_movimiento")
public class StockMovimiento {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_producto", nullable = false)
    private Producto producto;

    @ManyToOne
    @JoinColumn(name = "id_pedido")
    private Pedido pedido;

    /**
     * RESERVA: Se reserva stock en PENDIENTE
     * CONFIRMACION: Se decrementa stock en CONFIRMADO
     * LIBERACION: Se incrementa stock si pasa de CONFIRMADO a CANCELADO
     */
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private TipoMovimiento tipo;

    @Column(nullable = false)
    private Integer cantidad;

    @Column(nullable = false)
    private LocalDateTime timestamp;

    @Column(length = 255)
    private String notas;

    public enum TipoMovimiento {
        RESERVA, CONFIRMACION, LIBERACION, AJUSTE_MANUAL
    }

    @PrePersist
    protected void onCreate() {
        if (timestamp == null) {
            timestamp = LocalDateTime.now();
        }
    }
}
