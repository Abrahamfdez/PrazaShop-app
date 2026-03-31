package org.example.prazashop.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CompraRecorrenteDto {
    private Long id;
    private Long clienteId;
    private Long productoId;
    private Integer cantidade;
    private String frecuencia;
    private LocalDate dataInicio;
    private String estado;
}

