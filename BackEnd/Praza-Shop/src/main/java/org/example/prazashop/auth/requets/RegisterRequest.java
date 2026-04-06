package org.example.prazashop.auth.requets;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import org.example.prazashop.model.TipoUsuario;

/**
 * The type Register request.
 */
@Data
public class RegisterRequest {
    @NotBlank
    private String nome;

    @NotBlank
    @Email
    private String email;

    @NotBlank
    private String contrasinal;
    private String telefono;
    private TipoUsuario tipoUsuario;
}
