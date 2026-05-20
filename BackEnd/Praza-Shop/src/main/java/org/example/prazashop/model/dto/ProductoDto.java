package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import jakarta.validation.constraints.*;

/**
 * The type Producto dto.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductoDto {
    private Long id;
    private Long negocioId;
    
    @NotBlank(message = "El nombre del producto es obligatorio")
    private String nome;
    
    private String descricion;
    
    @NotNull(message = "El precio es obligatorio")
    @DecimalMin(value = "0.0", inclusive = true, message = "El precio no puede ser negativo")
    private Double prezo;
    
    @NotNull(message = "El stock es obligatorio")
    @Min(value = 0, message = "El stock no puede ser negativo")
    private Integer stock;
    
    private String categoria;
    private String duracionOferta;
    private String imaxe;
    private String estado;
}

