package org.example.prazashop.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * The interface Token repository.
 */
public interface TokenRepository extends JpaRepository<Token, Long> {
    /**
     * Find by token optional.
     *
     * @param token the token
     * @return the optional
     */
    Optional<Token> findByToken(String token);

    /**
     * Devuelve todos los tokens de un usuario por su id.
     *
     * @param usuarioId id del usuario
     * @return lista de tokens
     */
    List<Token> findAllByUsuarioId(Long usuarioId);
}
