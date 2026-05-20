package org.example.prazashop.exception;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * Representa un error de validación en un campo específico.
 */
@Data
@AllArgsConstructor
public class FieldError {
    private String field;
    private String message;
}
