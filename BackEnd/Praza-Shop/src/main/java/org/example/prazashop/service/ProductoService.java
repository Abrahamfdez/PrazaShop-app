package org.example.prazashop.service;

import org.example.prazashop.model.dto.ProductoDto;

import java.util.List;

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
     * Busca un producto por su id. Lanza NoContentException si no se encuentra.
     *
     * @param id the id
     * @return el producto encontrado
     * @throws NoContentException si no se encuentra el producto
     */
    ProductoDto findById(Long id);

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

    /**
     * Devuelve todos los productos de un negocio por su ID.
     * @param negocioId identificador del negocio
     * @return lista de productos del negocio
     */
    List<ProductoDto> findByNegocioId(Long negocioId);
}
