package org.example.prazashop.auth.repository;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.example.prazashop.model.entity.Usuario;

/**
 * The type Token.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Token {
    /**
     * The enum Tipo token.
     */
    public enum TipoToken {
        /**
         * Access tipo token.
         */
        ACCESS,
        /**
         * Refresh tipo token.
         */
        REFRESH
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(unique = true, nullable = false)
    private String token;
    @Enumerated(EnumType.STRING)
    private TipoToken tipoToken = TipoToken.ACCESS;
    private boolean revocado;
    private boolean expirado;
    @ManyToOne(fetch = FetchType.LAZY)
    private Usuario usuario;
}
