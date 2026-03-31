package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductoDto {
    private Long id;
    private Long negocioId;
    private String nome;
    private String descricion;
    private Double prezo;
    private Integer stock;
    private String categoria;
    private String duracionOferta;
    private String imaxe;
    private String estado;
}

