package org.example.prazashop.controller;

import org.example.prazashop.model.dto.PedidoDto;
import org.example.prazashop.service.PedidoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
}
