package org.example.prazashop.controller;

import org.example.prazashop.model.dto.NegocioDto;
import org.example.prazashop.service.NegocioService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador para gestionar negocios.
 */
@RestController
@RequestMapping("/api/negocios")
@CrossOrigin(origins = "*", maxAge = 3600)
public class NegocioController {

    private final NegocioService negocioService;

    public NegocioController(NegocioService negocioService) {
        this.negocioService = negocioService;
    }

    /**
     * Obtiene todos los negocios.
     *
     * @return lista de negocios
     */
    @GetMapping
    public ResponseEntity<List<NegocioDto>> getAllNegocios() {
        List<NegocioDto> negocios = negocioService.findAll();
        return ResponseEntity.ok(negocios);
    }

    /**
     * Obtiene un negocio por ID.
     *
     * @param id identificador del negocio
     * @return negocio encontrado
     */
    @GetMapping("/{id}")
    public ResponseEntity<NegocioDto> getNegocioById(@PathVariable Long id) {
        return negocioService.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    /**
     * Crea un nuevo negocio.
     *
     * @param negocioDto datos del negocio
     * @return negocio creado
     */
    @PostMapping
    public ResponseEntity<NegocioDto> createNegocio(@RequestBody NegocioDto negocioDto) {
        NegocioDto negocioCreado = negocioService.create(negocioDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(negocioCreado);
    }

    /**
     * Actualiza un negocio.
     *
     * @param id identificador del negocio
     * @param negocioDto datos actualizados
     * @return negocio actualizado
     */
    @PutMapping("/{id}")
    public ResponseEntity<NegocioDto> updateNegocio(
            @PathVariable Long id,
            @RequestBody NegocioDto negocioDto) {
        NegocioDto negocioActualizado = negocioService.update(id, negocioDto);
        return ResponseEntity.ok(negocioActualizado);
    }

    /**
     * Elimina un negocio.
     *
     * @param id identificador del negocio
     * @return respuesta vacía
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNegocio(@PathVariable Long id) {
        negocioService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}

