package org.example.prazashop.controller;

import org.example.prazashop.model.dto.*;
import org.example.prazashop.model.entity.Pedido;
import org.example.prazashop.service.PedidoService;
import org.example.prazashop.service.UsuarioContextService;
import org.example.prazashop.service.PedidoStateTransitionService;
import org.example.prazashop.repository.PedidoRepository;
import org.example.prazashop.confg.ratelimit.RateLimit;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Controlador para gestionar pedidos.
 */
@RestController
@CrossOrigin(origins = "*", maxAge = 3600)
public class PedidoController {

    private final PedidoService pedidoService;
    private final UsuarioContextService usuarioContextService;
    private final PedidoStateTransitionService stateTransitionService;
    private final PedidoRepository pedidoRepository;

    public PedidoController(
            PedidoService pedidoService,
            UsuarioContextService usuarioContextService,
            PedidoStateTransitionService stateTransitionService,
            PedidoRepository pedidoRepository) {
        this.pedidoService = pedidoService;
        this.usuarioContextService = usuarioContextService;
        this.stateTransitionService = stateTransitionService;
        this.pedidoRepository = pedidoRepository;
    }

    /**
     * Obtiene todos los pedidos.
     * 
     * @deprecated Usar {@link #misPedidos(Integer, Integer)} o {@link #misVentas(Integer, Integer)} según el contexto
     * @return lista de pedidos
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @GetMapping("/api/pedidos")
    public ResponseEntity<List<PedidoDto>> getAllPedidos() {
        List<PedidoDto> pedidos = pedidoService.findAll();
        return ResponseEntity.ok(pedidos);
    }

    /**
     * Obtiene un pedido por ID.
     * 
     * @deprecated Usar {@link #misPedidos(Integer, Integer)} o {@link #misVentas(Integer, Integer)} según el contexto
     * @param id identificador del pedido
     * @return pedido encontrado
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @GetMapping("/api/pedidos/{id}")
    public ResponseEntity<PedidoDto> getPedidoById(@PathVariable Long id) {
        PedidoDto dto = pedidoService.findById(id);
        return ResponseEntity.ok(dto);
    }

    /**
     * Crea un nuevo pedido.
     * 
     * @deprecated Usar {@link #crearPedidoComoCliente(PedidoCreacionRequest)} en su lugar
     * @param pedidoDto datos del pedido
     * @return pedido creado
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @PostMapping("/api/pedidos")
    public ResponseEntity<PedidoDto> createPedido(@RequestBody PedidoDto pedidoDto) {
        PedidoDto pedidoCreado = pedidoService.create(pedidoDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(pedidoCreado);
    }

    /**
     * Actualiza un pedido.
     * 
     * @deprecated Usar {@link #actualizarEstadoPedido(Long, PedidoActualizarEstadoRequest)} en su lugar
     * @param id identificador del pedido
     * @param pedidoDto datos actualizados
     * @return pedido actualizado
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @PutMapping("/api/pedidos/{id}")
    public ResponseEntity<PedidoDto> updatePedido(
            @PathVariable Long id,
            @RequestBody PedidoDto pedidoDto) {
        PedidoDto pedidoActualizado = pedidoService.update(id, pedidoDto);
        return ResponseEntity.ok(pedidoActualizado);
    }

    /**
     * Elimina un pedido.
     * 
     * @deprecated No recomendado. Los pedidos no deben eliminarse, sino cancelarse.
     * @param id identificador del pedido
     * @return respuesta vacía
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @DeleteMapping("/api/pedidos/{id}")
    public ResponseEntity<Void> deletePedido(@PathVariable Long id) {
        pedidoService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Obtiene todos los pedidos de un cliente por su id.
     * 
     * @deprecated Usar {@link #misPedidos(Integer, Integer)} en su lugar
     * @param clienteId identificador del cliente
     * @return lista de pedidos
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @GetMapping("/api/pedidos/cliente/{clienteId}")
    public ResponseEntity<List<PedidoDto>> getPedidosByClienteId(@PathVariable Long clienteId) {
        List<PedidoDto> pedidos = pedidoService.findByClienteId(clienteId);
        return ResponseEntity.ok(pedidos);
    }

    /**
     * Obtiene todos los pedidos con detalles de un cliente por su id.
     * 
     * @deprecated Usar {@link #misPedidos(Integer, Integer)} en su lugar
     * @param clienteId identificador del cliente
     * @return lista de pedidos con sus detalles
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @GetMapping("/api/pedidos/cliente/{clienteId}/detalles")
    public ResponseEntity<List<PedidoConDetallesDto>> getPedidosByClienteIdConDetalles(@PathVariable Long clienteId) {
        List<PedidoConDetallesDto> pedidos = pedidoService.findByClienteIdConDetalles(clienteId);
        return ResponseEntity.ok(pedidos);
    }

    /**
     * Obtiene todos los pedidos de un negocio por su id.
     * 
     * @deprecated Usar {@link #misVentas(Integer, Integer)} en su lugar
     * @param negocioId identificador del negocio
     * @return lista de pedidos
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @GetMapping("/negocio/{negocioId}")
    public ResponseEntity<List<PedidoDto>> getPedidosByNegocioId(@PathVariable Long negocioId) {
        List<PedidoDto> pedidos = pedidoService.findByNegocioId(negocioId);
        return ResponseEntity.ok(pedidos);
    }

    /**
     * Crea un pedido completo con detalles en una transacción atómica.
     * 
     * @deprecated Usar {@link #crearPedidoComoCliente(PedidoCreacionRequest)} en su lugar.
     * Este endpoint requiere conocer clienteId y negocioId en el frontend.
     * El nuevo endpoint auto-resuelve el clienteId del usuario autenticado.
     * @param request request con clienteId, negocioId y detalles
     * @return pedido creado con detalles
     */
    @Deprecated(since = "2.0", forRemoval = true)
    @PostMapping("/api/pedidos/crear-completo")
    public ResponseEntity<PedidoConDetallesDto> crearPedidoCompleto(@RequestBody PedidoCreacionRequest request) {
        PedidoConDetallesDto pedidoCreado = pedidoService.crearPedidoCompleto(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(pedidoCreado);
    }

    /**
     * Busca pedidos con filtros y paginación.
     * 
     * @deprecated Usar {@link #misPedidos(Integer, Integer)} o {@link #misVentas(Integer, Integer)} según el contexto
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
    @Deprecated(since = "2.0", forRemoval = true)
    @RateLimit(requestsPerMinute = 100) // Límite de 100 peticiones por minuto por usuario
    @GetMapping("/api/pedidos/buscar")
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

    // ========== ENDPOINTS USER-SCOPED (Fase 3) ==========

    /**
     * Crea un nuevo pedido como cliente (auto-resuelve clienteId del usuario autenticado).
     * 
     * @param request con negocioId y detalles
     * @return 201 CREATED con PedidoConDetallesDto
     */
    @PostMapping("/api/mi-compra/pedidos")
    public ResponseEntity<PedidoConDetallesDto> crearPedidoComoCliente(
            @Valid @RequestBody PedidoCreacionRequest request) {
        
        // Auto-resolver clienteId del usuario autenticado
        var cliente = usuarioContextService.getClienteOfCurrentUser();
        request.setClienteId(cliente.getIdCliente());
        
        // Crear pedido
        PedidoConDetallesDto pedidoCreado = pedidoService.crearPedidoCompleto(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(pedidoCreado);
    }

    /**
     * Obtiene los pedidos del cliente autenticado con paginación.
     * 
     * @param pagina número de página (default: 0)
     * @param tamaño cantidad por página (default: 10)
     * @return Page<PedidoConDetallesDto>
     */
    @RateLimit(requestsPerMinute = 100)
    @GetMapping("/api/mi-compra/pedidos")
    public ResponseEntity<PedidoSearchResponse> misPedidos(
            @RequestParam(required = false, defaultValue = "0") Integer pagina,
            @RequestParam(required = false, defaultValue = "10") Integer tamaño) {
        
        var cliente = usuarioContextService.getClienteOfCurrentUser();
        List<PedidoConDetallesDto> pedidos = pedidoService.findByClienteIdConDetalles(cliente.getIdCliente());
        
        // Aplicar paginación
        int start = pagina * tamaño;
        int end = Math.min(start + tamaño, pedidos.size());
        List<PedidoConDetallesDto> contenido = start < pedidos.size() ? pedidos.subList(start, end) : List.of();
        
        PedidoSearchResponse resultado = PedidoSearchResponse.builder()
                .content(contenido)
                .pageNumber(pagina)
                .pageSize(tamaño)
                .totalElements((long) pedidos.size())
                .totalPages((pedidos.size() + tamaño - 1) / tamaño)
                .last(end >= pedidos.size())
                .build();
        return ResponseEntity.ok(resultado);
    }

    /**
     * Obtiene las ventas del negocio autenticado (pedidos de clientes).
     * 
     * @param pagina número de página (default: 0)
     * @param tamaño cantidad por página (default: 10)
     * @return Page<PedidoConDetallesDto>
     */
    @RateLimit(requestsPerMinute = 100)
    @GetMapping("/api/mi-negocio/ventas")
    public ResponseEntity<PedidoSearchResponse> misVentas(
            @RequestParam(required = false, defaultValue = "0") Integer pagina,
            @RequestParam(required = false, defaultValue = "10") Integer tamaño) {
        
        var negocio = usuarioContextService.getNegocioOfCurrentUser();
        List<PedidoConDetallesDto> pedidos = pedidoService.findByNegocioIdConDetalles(negocio.getIdNegocio());
        
        // Aplicar paginación
        int start = pagina * tamaño;
        int end = Math.min(start + tamaño, pedidos.size());
        List<PedidoConDetallesDto> contenido = start < pedidos.size() ? pedidos.subList(start, end) : List.of();
        
        PedidoSearchResponse resultado = PedidoSearchResponse.builder()
                .content(contenido)
                .pageNumber(pagina)
                .pageSize(tamaño)
                .totalElements((long) pedidos.size())
                .totalPages((pedidos.size() + tamaño - 1) / tamaño)
                .last(end >= pedidos.size())
                .build();
        return ResponseEntity.ok(resultado);
    }

    /**
     * Actualiza el estado de un pedido (solo propietario del negocio).
     * 
     * @param pedidoId ID del pedido
     * @param request con nuevoEstado
     * @return 200 OK con PedidoConDetallesDto o 409 CONFLICT si hay error
     */
    @PutMapping("/api/mi-negocio/ventas/{pedidoId}/estado")
    @Transactional
    public ResponseEntity<PedidoConDetallesDto> actualizarEstadoPedido(
            @PathVariable Long pedidoId,
            @Valid @RequestBody PedidoActualizarEstadoRequest request) {
        
        // Verificar propiedad del negocio
        var pedido = pedidoService.findEntityById(pedidoId);
        usuarioContextService.isOwnerOfNegocio(pedido.getNegocio().getIdNegocio());
        
        // Aplicar transición de estado
        String nuevoEstado = request.getNuevoEstado();
        switch (nuevoEstado) {
            case "CONFIRMADO":
                stateTransitionService.transitionToConfirmado(pedido);
                break;
            case "ENTREGADO":
                stateTransitionService.transitionToEntregado(pedido);
                break;
            case "CANCELADO":
                stateTransitionService.transitionToCancelado(pedido);
                break;
            default:
                throw new IllegalArgumentException("Estado no válido: " + nuevoEstado);
        }
        
        // Guardar el pedido con el nuevo estado
        pedidoRepository.save(pedido);
        return ResponseEntity.ok(pedidoService.toDtoConDetalles(pedido));
    }
}

