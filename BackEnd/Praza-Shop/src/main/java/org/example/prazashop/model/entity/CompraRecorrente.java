package org.example.prazashop.model.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "compra_recorrente")
public class CompraRecorrente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idRecorrente;

    @ManyToOne
    @JoinColumn(name = "id_cliente")
    private Cliente cliente;

    @ManyToOne
    @JoinColumn(name = "id_producto")
    private Producto producto;

    private Integer cantidade;
    private String frecuencia;
    private LocalDate dataInicio;
    private String estado;
}
