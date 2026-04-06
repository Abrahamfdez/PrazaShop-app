package org.example.prazashop.model.entity;

import jakarta.persistence.*;
import lombok.*;
import org.example.prazashop.auth.repository.Token;
import org.example.prazashop.model.TipoUsuario;

import java.util.List;

/**
 * The type Usuario.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "usuario")
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String contrasinal;

    private String telefono;

    @Enumerated(EnumType.STRING)
    private TipoUsuario tipoUsuario;
    @OneToMany(mappedBy = "usuario", fetch = FetchType.LAZY)
    private List<Token> tokens;

}