package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.*;

/**
 * Request para actualizar el estado de un pedido.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PedidoActualizarEstadoRequest {
    @NotBlank(message = "El estado es obligatorio")
    @Pattern(
        regexp = "^(PENDIENTE|CONFIRMADO|ENTREGADO|CANCELADO)$",
        message = "Estado no válido. Valores permitidos: PENDIENTE, CONFIRMADO, ENTREGADO, CANCELADO"
    )
    private String nuevoEstado;
}
