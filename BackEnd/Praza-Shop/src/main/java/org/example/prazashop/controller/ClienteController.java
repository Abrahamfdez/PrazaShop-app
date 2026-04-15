package org.example.prazashop.controller;

import org.example.prazashop.model.dto.ClienteDto;
import org.example.prazashop.service.ClienteService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador para gestionar clientes.
 */
@RestController
@RequestMapping("/api/clientes")
@CrossOrigin(origins = "*", maxAge = 3600)
public class ClienteController {

    private final ClienteService clienteService;

    public ClienteController(ClienteService clienteService) {
        this.clienteService = clienteService;
    }

    /**
     * Obtiene todos los clientes.
     *
     * @return lista de clientes
     */
    @GetMapping
    public ResponseEntity<List<ClienteDto>> getAllClientes() {
        List<ClienteDto> clientes = clienteService.findAll();
        return ResponseEntity.ok(clientes);
    }

    /**
     * Obtiene un cliente por ID.
     *
     * @param id identificador del cliente
     * @return cliente encontrado
     */
    @GetMapping("/{id}")
    public ResponseEntity<ClienteDto> getClienteById(@PathVariable Long id) {
        return clienteService.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    /**
     * Crea un nuevo cliente.
     *
     * @param clienteDto datos del cliente
     * @return cliente creado
     */
    @PostMapping
    public ResponseEntity<ClienteDto> createCliente(@RequestBody ClienteDto clienteDto) {
        ClienteDto clienteCreado = clienteService.create(clienteDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(clienteCreado);
    }

    /**
     * Actualiza un cliente.
     *
     * @param id identificador del cliente
     * @param clienteDto datos actualizados
     * @return cliente actualizado
     */
    @PutMapping("/{id}")
    public ResponseEntity<ClienteDto> updateCliente(
            @PathVariable Long id,
            @RequestBody ClienteDto clienteDto) {
        ClienteDto clienteActualizado = clienteService.update(id, clienteDto);
        return ResponseEntity.ok(clienteActualizado);
    }

    /**
     * Elimina un cliente.
     *
     * @param id identificador del cliente
     * @return respuesta vacía
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCliente(@PathVariable Long id) {
        clienteService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Obtiene un cliente por el id de usuario asociado.
     *
     * @param usuarioId identificador del usuario
     * @return cliente encontrado
     */
    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<ClienteDto> getClienteByUsuarioId(@PathVariable Long usuarioId) {
        return clienteService.findByUsuarioId(usuarioId)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }
}
