package org.example.prazashop.controller;

import org.example.prazashop.model.dto.ProductoDto;
import org.example.prazashop.service.ProductoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador para gestionar productos.
 */
@RestController
@RequestMapping("/api/productos")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ProductoController {

    private final ProductoService productoService;

    public ProductoController(ProductoService productoService) {
        this.productoService = productoService;
    }

    /**
     * Obtiene todos los productos.
     *
     * @return lista de productos
     */
    @GetMapping
    public ResponseEntity<List<ProductoDto>> getAllProductos() {
        List<ProductoDto> productos = productoService.findAll();
        return ResponseEntity.ok(productos);
    }

    /**
     * Obtiene un producto por ID.
     *
     * @param id identificador del producto
     * @return producto encontrado
     */
    @GetMapping("/{id}")
    public ResponseEntity<ProductoDto> getProductoById(@PathVariable Long id) {
        return productoService.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    /**
     * Crea un nuevo producto.
     *
     * @param productoDto datos del producto
     * @return producto creado
     */
    @PostMapping
    public ResponseEntity<ProductoDto> createProducto(@RequestBody ProductoDto productoDto) {
        ProductoDto productoCreado = productoService.create(productoDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(productoCreado);
    }

    /**
     * Actualiza un producto.
     *
     * @param id identificador del producto
     * @param productoDto datos actualizados
     * @return producto actualizado
     */
    @PutMapping("/{id}")
    public ResponseEntity<ProductoDto> updateProducto(
            @PathVariable Long id,
            @RequestBody ProductoDto productoDto) {
        ProductoDto productoActualizado = productoService.update(id, productoDto);
        return ResponseEntity.ok(productoActualizado);
    }

    /**
     * Elimina un producto.
     *
     * @param id identificador del producto
     * @return respuesta vacía
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProducto(@PathVariable Long id) {
        productoService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}

