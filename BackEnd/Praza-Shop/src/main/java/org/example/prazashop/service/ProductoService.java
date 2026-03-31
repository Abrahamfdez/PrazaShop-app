package org.example.prazashop.service;

import org.example.prazashop.model.dto.ProductoDto;

import java.util.List;
import java.util.Optional;

/**
 * Interfaz para la lógica de negocio de productos.
 */
public interface ProductoService {
    List<ProductoDto> findAll();
    Optional<ProductoDto> findById(Long id);
    ProductoDto create(ProductoDto producto);
    ProductoDto update(Long id, ProductoDto producto);
    void deleteById(Long id);
}
