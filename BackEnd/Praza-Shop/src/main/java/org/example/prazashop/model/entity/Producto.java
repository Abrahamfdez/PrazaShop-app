package org.example.prazashop.model.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * The type Producto.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "producto")
public class Producto {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idProducto;
    @ManyToOne
    @JoinColumn(name = "id_negocio")
    private Negocio negocio;
    private String nome;
    private String descricion;
    private Double prezo;
    private Integer stock;
    private String categoria;
    private String duracionOferta;
    private String imaxe;
    private String estado;
}