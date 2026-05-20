package org.example.prazashop.controller;

import org.example.prazashop.model.dto.ProductoDto;
import org.example.prazashop.model.dto.ProductoDetallesDto;
import org.example.prazashop.service.ProductoService;
import org.example.prazashop.service.UsuarioContextService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Controlador para gestionar productos.
 */
@RestController
@CrossOrigin(origins = "*", maxAge = 3600)
public class ProductoController {

    private final ProductoService productoService;
    private final UsuarioContextService usuarioContextService;
    private static final Logger logger = LoggerFactory.getLogger(ProductoController.class);

    public ProductoController(
            ProductoService productoService,
            UsuarioContextService usuarioContextService) {
        this.productoService = productoService;
        this.usuarioContextService = usuarioContextService;
    }

    /**
     * Obtiene todos los productos.
     * 
     * @deprecated Usar {@link #misProductos(Integer, Integer)} para el negocio autenticado
     * @return lista de productos
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @GetMapping("/api/productos")
    public ResponseEntity<List<ProductoDto>> getAllProductos(HttpServletRequest request) {
        logger.info("GET /api/productos invoked - Authorization present: {}", request.getHeader("Authorization") != null);
        List<ProductoDto> productos = productoService.findAll();
        logger.info("ProductoService.findAll returned {} items", productos == null ? 0 : productos.size());
        return ResponseEntity.ok(productos);
    }

    /**
     * Obtiene un producto por ID.
     * 
     * @deprecated Este endpoint es público sin autenticación. Mantener para compatibilidad.
     * @param id identificador del producto
     * @return producto encontrado
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @GetMapping("/api/productos/{id}")
    public ResponseEntity<ProductoDto> getProductoById(@PathVariable Long id) {
        ProductoDto dto = productoService.findById(id);
        return ResponseEntity.ok(dto);
    }

    /**
     * Crea un nuevo producto.
     * 
     * @deprecated Usar {@link #crearProductoEnNegocio(ProductoDto)} en su lugar.
     * El nuevo endpoint auto-resuelve el negocioId del usuario autenticado.
     * @param productoDto datos del producto
     * @return producto creado
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @PostMapping("/api/productos")
    public ResponseEntity<ProductoDto> createProducto(@RequestBody ProductoDto productoDto) {
        ProductoDto productoCreado = productoService.create(productoDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(productoCreado);
    }

    /**
     * Actualiza un producto.
     * 
     * @deprecated Usar {@link #actualizarProductoEnNegocio(Long, ProductoDto)} en su lugar
     * @param id identificador del producto
     * @param productoDto datos actualizados
     * @return producto actualizado
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @PutMapping("/api/productos/{id}")
    public ResponseEntity<ProductoDto> updateProducto(
            @PathVariable Long id,
            @RequestBody ProductoDto productoDto) {
        ProductoDto productoActualizado = productoService.update(id, productoDto);
        return ResponseEntity.ok(productoActualizado);
    }

    /**
     * Elimina un producto.
     * 
     * @deprecated Usar {@link #eliminarProductoDelNegocio(Long)} en su lugar
     * @param id identificador del producto
     * @return respuesta vacía
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @DeleteMapping("/api/productos/{id}")
    public ResponseEntity<Void> deleteProducto(@PathVariable Long id) {
        productoService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Obtiene todos los productos de un negocio por su ID.
     * 
     * @deprecated Usar {@link #misProductos(Integer, Integer)} para el negocio autenticado
     * @param negocioId identificador del negocio
     * @return lista de productos del negocio
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @GetMapping("/api/productos/negocio/{negocioId}")
    public ResponseEntity<List<ProductoDto>> getProductosByNegocio(@PathVariable Long negocioId) {
        List<ProductoDto> productos = productoService.findByNegocioId(negocioId);
        return ResponseEntity.ok(productos);
    }

    /**
     * Obtiene los detalles de un producto incluyendo info del negocio y estadísticas.
     * 
     * @deprecated Este endpoint es público sin autenticación. Mantener para compatibilidad.
     * @param id identificador del producto
     * @return producto con detalles del negocio y stats
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @GetMapping("/api/productos/{id}/detalles")
    public ResponseEntity<ProductoDetallesDto> getProductoDetalles(@PathVariable Long id) {
        ProductoDetallesDto detalles = productoService.getProductoDetalles(id);
        return ResponseEntity.ok(detalles);
    }

    // ========== ENDPOINTS USER-SCOPED (Fase 3) ==========

    /**
     * Crea un nuevo producto para el negocio del usuario autenticado.
     * El negocioId se auto-resuelve del usuario.
     * 
     * @param productoDto datos del producto (sin negocioId)
     * @return 201 CREATED con ProductoDto
     */
    @PostMapping("/api/mi-negocio/productos")
    public ResponseEntity<ProductoDto> crearProductoEnNegocio(
            @Valid @RequestBody ProductoDto productoDto) {
        var negocio = usuarioContextService.getNegocioOfCurrentUser();
        productoDto.setNegocioId(negocio.getIdNegocio());
        ProductoDto creado = productoService.create(productoDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(creado);
    }

    /**
     * Actualiza un producto (solo propietario del negocio).
     * 
     * @param productoId ID del producto
     * @param productoDto datos actualizados
     * @return 200 OK o 403 FORBIDDEN si no es propietario
     */
    @PutMapping("/api/mi-negocio/productos/{productoId}")
    public ResponseEntity<ProductoDto> actualizarProductoEnNegocio(
            @PathVariable Long productoId,
            @Valid @RequestBody ProductoDto productoDto) {
        usuarioContextService.isOwnerOfProducto(productoId);
        ProductoDto actualizado = productoService.update(productoId, productoDto);
        return ResponseEntity.ok(actualizado);
    }

    /**
     * Elimina un producto del negocio (solo propietario, sin pedidos activos).
     * 
     * @param productoId ID del producto
     * @return 204 NO_CONTENT o 403 FORBIDDEN o 409 CONFLICT
     */
    @DeleteMapping("/api/mi-negocio/productos/{productoId}")
    public ResponseEntity<Void> eliminarProductoDelNegocio(@PathVariable Long productoId) {
        usuarioContextService.isOwnerOfProducto(productoId);
        productoService.deleteById(productoId);
        return ResponseEntity.noContent().build();
    }

    /**
     * Obtiene todos los productos del negocio autenticado con paginación.
     * 
     * @param pagina número de página (default: 0)
     * @param tamaño cantidad por página (default: 20)
     * @return Page<ProductoDto>
     */
    @GetMapping("/api/mi-negocio/productos")
    public ResponseEntity<List<ProductoDto>> misProductos(
            @RequestParam(required = false, defaultValue = "0") Integer pagina,
            @RequestParam(required = false, defaultValue = "20") Integer tamaño) {
        var negocio = usuarioContextService.getNegocioOfCurrentUser();
        List<ProductoDto> productos = productoService.findByNegocioId(negocio.getIdNegocio());
        return ResponseEntity.ok(productos);
    }
}
