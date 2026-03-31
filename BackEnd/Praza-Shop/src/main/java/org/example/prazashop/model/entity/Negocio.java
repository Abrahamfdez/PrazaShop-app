package org.example.prazashop.model.entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "negocio")
public class Negocio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idNegocio;

    @OneToOne
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;

    private String nomeNegocio;
    private String direccion;
    private String descricion;
}