package org.example.prazashop.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "pedido")
public class Pedido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idPedido;

    @ManyToOne
    @JoinColumn(name = "id_cliente")
    private Cliente cliente;

    @ManyToOne
    @JoinColumn(name = "id_negocio")
    private Negocio negocio;

    private LocalDateTime dataPedido;
    private LocalDateTime dataConfirmacion;
    private LocalDateTime dataEntrega;
    private LocalDateTime dataCancelacion;

    private String estado;

    private Double total;
}