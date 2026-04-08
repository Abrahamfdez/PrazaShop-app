package org.example.prazashop.controller;

import org.example.prazashop.model.dto.CompraRecorrenteDto;
import org.example.prazashop.service.CompraRecorrenteService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador para gestionar compras recurrentes.
 */
@RestController
@RequestMapping("/api/compras-recurrentes")
@CrossOrigin(origins = "*", maxAge = 3600)
public class CompraRecorrenteController {

    private final CompraRecorrenteService compraRecorrenteService;

    public CompraRecorrenteController(CompraRecorrenteService compraRecorrenteService) {
        this.compraRecorrenteService = compraRecorrenteService;
    }

    /**
     * Obtiene todas las compras recurrentes.
     *
     * @return lista de compras recurrentes
     */
    @GetMapping
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
    @GetMapping("/{id}")
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
    @PostMapping
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
    @PutMapping("/{id}")
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
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCompraRecurrente(@PathVariable Long id) {
        compraRecorrenteService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}

