package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.example.prazashop.model.TipoUsuario;

/**
 * The type Usuario dto.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioDto {
    private Long id;
    private String nome;
    private String email;
    private String contrasinal;
    private String telefono;
    private TipoUsuario tipoUsuario;
}

