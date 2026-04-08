package org.example.prazashop.controller;

import org.example.prazashop.model.dto.UsuarioDto;
import org.example.prazashop.service.UsuarioService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador para gestionar usuarios.
 */
@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = "*", maxAge = 3600)
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    /**
     * Obtiene todos los usuarios.
     *
     * @return lista de usuarios
     */
    @GetMapping
    public ResponseEntity<List<UsuarioDto>> getAllUsuarios() {
        List<UsuarioDto> usuarios = usuarioService.findAll();
        return ResponseEntity.ok(usuarios);
    }

    /**
     * Obtiene un usuario por ID.
     *
     * @param id identificador del usuario
     * @return usuario encontrado
     */
    @GetMapping("/{id}")
    public ResponseEntity<UsuarioDto> getUsuarioById(@PathVariable Long id) {
        return usuarioService.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    /**
     * Crea un nuevo usuario.
     *
     * @param usuarioDto datos del usuario
     * @return usuario creado
     */
    @PostMapping
    public ResponseEntity<UsuarioDto> createUsuario(@RequestBody UsuarioDto usuarioDto) {
        UsuarioDto usuarioCreado = usuarioService.create(usuarioDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(usuarioCreado);
    }

    /**
     * Actualiza un usuario.
     *
     * @param id identificador del usuario
     * @param usuarioDto datos actualizados
     * @return usuario actualizado
     */
    @PutMapping("/{id}")
    public ResponseEntity<UsuarioDto> updateUsuario(
            @PathVariable Long id,
            @RequestBody UsuarioDto usuarioDto) {
        UsuarioDto usuarioActualizado = usuarioService.update(id, usuarioDto);
        return ResponseEntity.ok(usuarioActualizado);
    }

    /**
     * Elimina un usuario.
     *
     * @param id identificador del usuario
     * @return respuesta vacía
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUsuario(@PathVariable Long id) {
        usuarioService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}

