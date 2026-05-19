package org.example.prazashop.controller;

import org.example.prazashop.model.dto.PedidoDto;
import org.example.prazashop.model.dto.PedidoConDetallesDto;
import org.example.prazashop.model.dto.PedidoCreacionRequest;
import org.example.prazashop.model.dto.PedidoSearchResponse;
import org.example.prazashop.service.PedidoService;
import org.example.prazashop.confg.ratelimit.RateLimit;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Controlador para gestionar pedidos.
 */
@RestController
@RequestMapping("/api/pedidos")
@CrossOrigin(origins = "*", maxAge = 3600)
public class PedidoController {

    private final PedidoService pedidoService;

    public PedidoController(PedidoService pedidoService) {
        this.pedidoService = pedidoService;
    }

    /**
     * Obtiene todos los pedidos.
     *
     * @return lista de pedidos
     */
    @GetMapping
    public ResponseEntity<List<PedidoDto>> getAllPedidos() {
        List<PedidoDto> pedidos = pedidoService.findAll();
        return ResponseEntity.ok(pedidos);
    }

    /**
     * Obtiene un pedido por ID.
     *
     * @param id identificador del pedido
     * @return pedido encontrado
     */
    @GetMapping("/{id}")
    public ResponseEntity<PedidoDto> getPedidoById(@PathVariable Long id) {
        PedidoDto dto = pedidoService.findById(id);
        return ResponseEntity.ok(dto);
    }

    /**
     * Crea un nuevo pedido.
     *
     * @param pedidoDto datos del pedido
     * @return pedido creado
     */
    @PostMapping
    public ResponseEntity<PedidoDto> createPedido(@RequestBody PedidoDto pedidoDto) {
        PedidoDto pedidoCreado = pedidoService.create(pedidoDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(pedidoCreado);
    }

    /**
     * Actualiza un pedido.
     *
     * @param id identificador del pedido
     * @param pedidoDto datos actualizados
     * @return pedido actualizado
     */
    @PutMapping("/{id}")
    public ResponseEntity<PedidoDto> updatePedido(
            @PathVariable Long id,
            @RequestBody PedidoDto pedidoDto) {
        PedidoDto pedidoActualizado = pedidoService.update(id, pedidoDto);
        return ResponseEntity.ok(pedidoActualizado);
    }

    /**
     * Elimina un pedido.
     *
     * @param id identificador del pedido
     * @return respuesta vacía
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletePedido(@PathVariable Long id) {
        pedidoService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Obtiene todos los pedidos de un cliente por su id.
     *
     * @param clienteId identificador del cliente
     * @return lista de pedidos
     */
    @GetMapping("/cliente/{clienteId}")
    public ResponseEntity<List<PedidoDto>> getPedidosByClienteId(@PathVariable Long clienteId) {
        List<PedidoDto> pedidos = pedidoService.findByClienteId(clienteId);
        return ResponseEntity.ok(pedidos);
    }

    /**
     * Obtiene todos los pedidos con detalles de un cliente por su id.
     *
     * @param clienteId identificador del cliente
     * @return lista de pedidos con sus detalles
     */
    @GetMapping("/cliente/{clienteId}/detalles")
    public ResponseEntity<List<PedidoConDetallesDto>> getPedidosByClienteIdConDetalles(@PathVariable Long clienteId) {
        List<PedidoConDetallesDto> pedidos = pedidoService.findByClienteIdConDetalles(clienteId);
        return ResponseEntity.ok(pedidos);
    }

    /**
     * Obtiene todos los pedidos de un negocio por su id.
     *
     * @param negocioId identificador del negocio
     * @return lista de pedidos
     */
    @GetMapping("/negocio/{negocioId}")
    public ResponseEntity<List<PedidoDto>> getPedidosByNegocioId(@PathVariable Long negocioId) {
        List<PedidoDto> pedidos = pedidoService.findByNegocioId(negocioId);
        return ResponseEntity.ok(pedidos);
    }

    /**
     * Crea un pedido completo con detalles en una transacción atómica.
     *
     * @param request request con clienteId, negocioId y detalles
     * @return pedido creado con detalles
     */
    @PostMapping("/crear-completo")
    public ResponseEntity<PedidoConDetallesDto> crearPedidoCompleto(@RequestBody PedidoCreacionRequest request) {
        PedidoConDetallesDto pedidoCreado = pedidoService.crearPedidoCompleto(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(pedidoCreado);
    }

    /**
     * Busca pedidos con filtros y paginación.
     *
     * @param estado estado del pedido (opcional)
     * @param fechaDesde fecha mínima (opcional, formato: yyyy-MM-dd'T'HH:mm:ss)
     * @param fechaHasta fecha máxima (opcional, formato: yyyy-MM-dd'T'HH:mm:ss)
     * @param precioDesde precio mínimo (opcional)
     * @param precioHasta precio máximo (opcional)
     * @param ordenar criterio de ordenamiento (opcional: fecha_asc, fecha_desc, total_asc, total_desc)
     * @param pagina número de página (0-indexed, default: 0)
     * @param tamaño cantidad de resultados por página (default: 10)
     * @return response con pedidos paginados
     */
    @RateLimit(requestsPerMinute = 100) // Límite de 100 peticiones por minuto por usuario
    @GetMapping("/buscar")
    public ResponseEntity<PedidoSearchResponse> buscarPedidos(
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) String fechaDesde,
            @RequestParam(required = false) String fechaHasta,
            @RequestParam(required = false) Double precioDesde,
            @RequestParam(required = false) Double precioHasta,
            @RequestParam(required = false, defaultValue = "fecha_desc") String ordenar,
            @RequestParam(required = false, defaultValue = "0") Integer pagina,
            @RequestParam(required = false, defaultValue = "10") Integer tamaño) {

        // Convertir strings a LocalDateTime si están presentes
        LocalDateTime fechaDesdeLocal = null;
        LocalDateTime fechaHastaLocal = null;
        
        if (fechaDesde != null && !fechaDesde.isEmpty()) {
            fechaDesdeLocal = LocalDateTime.parse(fechaDesde);
        }
        if (fechaHasta != null && !fechaHasta.isEmpty()) {
            fechaHastaLocal = LocalDateTime.parse(fechaHasta);
        }

        PedidoSearchResponse resultado = pedidoService.buscarPedidos(
                estado,
                fechaDesdeLocal,
                fechaHastaLocal,
                precioDesde,
                precioHasta,
                ordenar,
                pagina,
                tamaño
        );
        return ResponseEntity.ok(resultado);
    }
}
