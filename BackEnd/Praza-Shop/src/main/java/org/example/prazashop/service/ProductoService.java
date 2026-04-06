package org.example.prazashop.service;

import org.example.prazashop.model.dto.ProductoDto;

import java.util.List;
import java.util.Optional;

/**
 * Interfaz para la lógica de negocio de productos.
 */
public interface ProductoService {
    /**
     * Find all list.
     *
     * @return the list
     */
    List<ProductoDto> findAll();

    /**
     * Find by id optional.
     *
     * @param id the id
     * @return the optional
     */
    Optional<ProductoDto> findById(Long id);

    /**
     * Create producto dto.
     *
     * @param producto the producto
     * @return the producto dto
     */
    ProductoDto create(ProductoDto producto);

    /**
     * Update producto dto.
     *
     * @param id       the id
     * @param producto the producto
     * @return the producto dto
     */
    ProductoDto update(Long id, ProductoDto producto);

    /**
     * Delete by id.
     *
     * @param id the id
     */
    void deleteById(Long id);
}
