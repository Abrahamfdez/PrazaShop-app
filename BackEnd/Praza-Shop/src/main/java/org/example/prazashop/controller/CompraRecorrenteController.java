package org.example.prazashop.controller;

import org.example.prazashop.model.dto.CompraRecorrenteDto;
import org.example.prazashop.service.CompraRecorrenteService;
import org.example.prazashop.service.UsuarioContextService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador para gestionar compras recurrentes.
 */
@RestController
@CrossOrigin(origins = "*", maxAge = 3600)
public class CompraRecorrenteController {

    private final CompraRecorrenteService compraRecorrenteService;
    private final UsuarioContextService usuarioContextService;

    public CompraRecorrenteController(
            CompraRecorrenteService compraRecorrenteService,
            UsuarioContextService usuarioContextService) {
        this.compraRecorrenteService = compraRecorrenteService;
        this.usuarioContextService = usuarioContextService;
    }

    // ===== ENDPOINTS ORIGINALES (deprecated) =====

    /**
     * Obtiene todas las compras recurrentes.
     *
     * @return lista de compras recurrentes
     */
    @GetMapping("/api/compras-recurrentes")
    public ResponseEntity<List<CompraRecorrenteDto>> getAllComprasRecurrentes() {
        List<CompraRecorrenteDto> compras = compraRecorrenteService.findAll();
        return ResponseEntity.ok(compras);
    }

    /**
     * Obtiene una compra recurrente por ID.
     *
     * @param id identificador de la compra
     * @return compra encontrada
     */
    @GetMapping("/api/compras-recurrentes/{id}")
    public ResponseEntity<CompraRecorrenteDto> getCompraRecorrenteById(@PathVariable Long id) {
        return compraRecorrenteService.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    /**
     * Crea una nueva compra recurrente.
     *
     * @param compraRecorrenteDto datos de la compra
     * @return compra creada
     */
    @PostMapping("/api/compras-recurrentes")
    public ResponseEntity<CompraRecorrenteDto> createCompraRecurrente(@RequestBody CompraRecorrenteDto compraRecorrenteDto) {
        CompraRecorrenteDto compraCreada = compraRecorrenteService.create(compraRecorrenteDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(compraCreada);
    }

    /**
     * Actualiza una compra recurrente.
     *
     * @param id identificador de la compra
     * @param compraRecorrenteDto datos actualizados
     * @return compra actualizada
     */
    @PutMapping("/api/compras-recurrentes/{id}")
    public ResponseEntity<CompraRecorrenteDto> updateCompraRecurrente(
            @PathVariable Long id,
            @RequestBody CompraRecorrenteDto compraRecorrenteDto) {
        CompraRecorrenteDto compraActualizada = compraRecorrenteService.update(id, compraRecorrenteDto);
        return ResponseEntity.ok(compraActualizada);
    }

    /**
     * Elimina una compra recurrente.
     *
     * @param id identificador de la compra
     * @return respuesta vacía
     */
    @DeleteMapping("/api/compras-recurrentes/{id}")
    public ResponseEntity<Void> deleteCompraRecurrente(@PathVariable Long id) {
        compraRecorrenteService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    // ===== NUEVOS ENDPOINTS USER-SCOPED (Fase 3) =====

    /**
     * Obtiene las compras recurrentes del cliente autenticado.
     * Auto-resuelve el clienteId desde el contexto del usuario.
     *
     * @return lista de compras recurrentes del cliente
     */
    @GetMapping("/api/mis-compras-recurrentes")
    public ResponseEntity<List<CompraRecorrenteDto>> getMisComprasRecurrentes() {
        var cliente = usuarioContextService.getClienteOfCurrentUser();
        List<CompraRecorrenteDto> compras = compraRecorrenteService.findByClienteId(cliente.getIdCliente());
        return ResponseEntity.ok(compras);
    }

    /**
     * Crea una nueva compra recurrente para el cliente autenticado.
     * Auto-resuelve el clienteId desde el contexto del usuario.
     *
     * @param compraRecorrenteDto datos de la compra recurrente (sin clienteId)
     * @return compra recurrente creada
     */
    @PostMapping("/api/mis-compras-recurrentes")
    public ResponseEntity<CompraRecorrenteDto> crearMiCompraRecurrente(
            @RequestBody CompraRecorrenteDto compraRecorrenteDto) {
        var cliente = usuarioContextService.getClienteOfCurrentUser();
        CompraRecorrenteDto compraCreada = compraRecorrenteService.createForCliente(
                compraRecorrenteDto,
                cliente.getIdCliente()
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(compraCreada);
    }
}

