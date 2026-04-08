package org.example.prazashop.controller;

import org.example.prazashop.model.dto.DetallePedidoDto;
import org.example.prazashop.service.DetallePedidoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador para gestionar detalles de pedidos.
 */
@RestController
@RequestMapping("/api/detalles-pedidos")
@CrossOrigin(origins = "*", maxAge = 3600)
public class DetallePedidoController {

    private final DetallePedidoService detallePedidoService;

    public DetallePedidoController(DetallePedidoService detallePedidoService) {
        this.detallePedidoService = detallePedidoService;
    }

    /**
     * Obtiene todos los detalles de pedidos.
     *
     * @return lista de detalles de pedidos
     */
    @GetMapping
    public ResponseEntity<List<DetallePedidoDto>> getAllDetallesPedidos() {
        List<DetallePedidoDto> detalles = detallePedidoService.findAll();
        return ResponseEntity.ok(detalles);
    }

    /**
     * Obtiene un detalle de pedido por ID.
     *
     * @param id identificador del detalle
     * @return detalle encontrado
     */
    @GetMapping("/{id}")
    public ResponseEntity<DetallePedidoDto> getDetallePedidoById(@PathVariable Long id) {
        return detallePedidoService.findById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    /**
     * Crea un nuevo detalle de pedido.
     *
     * @param detallePedidoDto datos del detalle
     * @return detalle creado
     */
    @PostMapping
    public ResponseEntity<DetallePedidoDto> createDetallePedido(@RequestBody DetallePedidoDto detallePedidoDto) {
        DetallePedidoDto detalleCreado = detallePedidoService.create(detallePedidoDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(detalleCreado);
    }

    /**
     * Actualiza un detalle de pedido.
     *
     * @param id identificador del detalle
     * @param detallePedidoDto datos actualizados
     * @return detalle actualizado
     */
    @PutMapping("/{id}")
    public ResponseEntity<DetallePedidoDto> updateDetallePedido(
            @PathVariable Long id,
            @RequestBody DetallePedidoDto detallePedidoDto) {
        DetallePedidoDto detalleActualizado = detallePedidoService.update(id, detallePedidoDto);
        return ResponseEntity.ok(detalleActualizado);
    }

    /**
     * Elimina un detalle de pedido.
     *
     * @param id identificador del detalle
     * @return respuesta vacía
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDetallePedido(@PathVariable Long id) {
        detallePedidoService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}

