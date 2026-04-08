package org.example.prazashop.controller;

import org.example.prazashop.model.dto.ValoracionDto;
import org.example.prazashop.service.ValoracionService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador para gestionar valoraciones.
 */
@RestController
@RequestMapping("/api/valoraciones")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ValoracionController {

    private final ValoracionService valoracionService;

    public ValoracionController(ValoracionService valoracionService) {
        this.valoracionService = valoracionService;
    }

    /**
     * Obtiene todas las valoraciones.
     *
     * @return lista de valoraciones
     */
    @GetMapping
    public ResponseEntity<List<ValoracionDto>> getAllValoraciones() {
        List<ValoracionDto> valoraciones = valoracionService.findAll();
        return ResponseEntity.ok(valoraciones);
    }

    /**
     * Obtiene una valoración por ID.
     *
     * @param id identificador de la valoración
     * @return valoración encontrada
     */
    @GetMapping("/{id}")
    public ResponseEntity<ValoracionDto> getValoracionById(@PathVariable Long id) {
        return valoracionService.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    /**
     * Crea una nueva valoración.
     *
     * @param valoracionDto datos de la valoración
     * @return valoración creada
     */
    @PostMapping
    public ResponseEntity<ValoracionDto> createValoracion(@RequestBody ValoracionDto valoracionDto) {
        ValoracionDto valoracionCreada = valoracionService.create(valoracionDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(valoracionCreada);
    }

    /**
     * Actualiza una valoración.
     *
     * @param id identificador de la valoración
     * @param valoracionDto datos actualizados
     * @return valoración actualizada
     */
    @PutMapping("/{id}")
    public ResponseEntity<ValoracionDto> updateValoracion(
            @PathVariable Long id,
            @RequestBody ValoracionDto valoracionDto) {
        ValoracionDto valoracionActualizada = valoracionService.update(id, valoracionDto);
        return ResponseEntity.ok(valoracionActualizada);
    }

    /**
     * Elimina una valoración.
     *
     * @param id identificador de la valoración
     * @return respuesta vacía
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteValoracion(@PathVariable Long id) {
        valoracionService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}

