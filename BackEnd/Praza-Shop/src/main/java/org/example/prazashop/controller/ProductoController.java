package org.example.prazashop.controller;

import org.example.prazashop.model.dto.ProductoDto;
import org.example.prazashop.model.dto.ProductoDetallesDto;
import org.example.prazashop.service.ProductoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Controlador para gestionar productos.
 */
@RestController
@RequestMapping("/api/productos")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ProductoController {

    private final ProductoService productoService;
    private static final Logger logger = LoggerFactory.getLogger(ProductoController.class);

    public ProductoController(ProductoService productoService) {
        this.productoService = productoService;
    }

    /**
     * Obtiene todos los productos.
     *
     * @return lista de productos
     */
    @GetMapping
    public ResponseEntity<List<ProductoDto>> getAllProductos(HttpServletRequest request) {
        logger.info("GET /api/productos invoked - Authorization present: {}", request.getHeader("Authorization") != null);
        List<ProductoDto> productos = productoService.findAll();
        logger.info("ProductoService.findAll returned {} items", productos == null ? 0 : productos.size());
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
        ProductoDto dto = productoService.findById(id);
        return ResponseEntity.ok(dto);
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

    /**
     * Obtiene todos los productos de un negocio por su ID.
     * @param negocioId identificador del negocio
     * @return lista de productos del negocio
     */
    @GetMapping("/negocio/{negocioId}")
    public ResponseEntity<List<ProductoDto>> getProductosByNegocio(@PathVariable Long negocioId) {
        List<ProductoDto> productos = productoService.findByNegocioId(negocioId);
        return ResponseEntity.ok(productos);
    }

    /**
     * Obtiene los detalles de un producto incluyendo info del negocio y estadísticas.
     *
     * @param id identificador del producto
     * @return producto con detalles del negocio y stats
     */
    @GetMapping("/{id}/detalles")
    public ResponseEntity<ProductoDetallesDto> getProductoDetalles(@PathVariable Long id) {
        ProductoDetallesDto detalles = productoService.getProductoDetalles(id);
        return ResponseEntity.ok(detalles);
    }
}
