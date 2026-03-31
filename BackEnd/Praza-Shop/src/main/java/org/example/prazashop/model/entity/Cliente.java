package org.example.prazashop.model.entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cliente")
public class Cliente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idCliente;
    @OneToOne
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;
    private String direccionEnvio;
}
