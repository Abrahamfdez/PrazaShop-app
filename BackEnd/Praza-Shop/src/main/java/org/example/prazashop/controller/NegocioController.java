package org.example.prazashop.controller;

import org.example.prazashop.model.dto.NegocioDto;
import org.example.prazashop.model.dto.NegocioDashboardDto;
import org.example.prazashop.service.NegocioService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
        NegocioDto dto = negocioService.findById(id);
        return ResponseEntity.ok(dto);
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

    /**
     * Obtiene un negocio por el id de usuario asociado.
     *
     * @param usuarioId identificador del usuario
     * @return negocio encontrado
     */
    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<NegocioDto> getNegocioByUsuarioId(@PathVariable Long usuarioId) {
        NegocioDto dto = negocioService.findByUsuarioId(usuarioId);
        return ResponseEntity.ok(dto);
    }

    /**
     * Obtiene el dashboard completo de un negocio con estadísticas.
     * Solo el propietario del negocio puede acceder a su dashboard.
     *
     * @param id identificador del negocio
     * @return dashboard con info completa del negocio
     */
    @GetMapping("/{id}/dashboard")
    public ResponseEntity<NegocioDashboardDto> getDashboard(@PathVariable Long id) {
        // Obtener usuario autenticado del contexto de seguridad
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String authenticatedEmail = authentication != null ? authentication.getName() : null;
        
        if (authenticatedEmail == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        // Validar que el usuario autenticado es dueño del negocio
        NegocioDto negocioDto = negocioService.findById(id);
        // Aquí extraemos el email del usuario propietario del negocio
        if (!negocioService.isOwnerOfNegocio(id, authenticatedEmail)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        
        NegocioDashboardDto dashboard = negocioService.getDashboard(id);
        return ResponseEntity.ok(dashboard);
    }
}
