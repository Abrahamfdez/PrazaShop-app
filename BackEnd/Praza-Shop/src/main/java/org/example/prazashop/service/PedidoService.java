package org.example.prazashop.service;

import org.example.prazashop.model.dto.PedidoDto;
import org.example.prazashop.model.dto.PedidoConDetallesDto;

import java.util.List;

/**
 * Servicios de negocio relacionados con pedidos.
 */
public interface PedidoService {
    /**
     * Find all list.
     *
     * @return the list
     */
    List<PedidoDto> findAll();

    /**
     * Busca un pedido por su id. Lanza NoContentException si no se encuentra.
     *
     * @param id the id
     * @return pedido encontrado
     * @throws NoContentException si no se encuentra el pedido
     */
    PedidoDto findById(Long id);

    /**
     * Create pedido dto.
     *
     * @param pedido the pedido
     * @return the pedido dto
     */
    PedidoDto create(PedidoDto pedido);

    /**
     * Update pedido dto.
     *
     * @param id     the id
     * @param pedido the pedido
     * @return the pedido dto
     */
    PedidoDto update(Long id, PedidoDto pedido);

    /**
     * Delete by id.
     *
     * @param id the id
     */
    void deleteById(Long id);

    /**
     * Busca pedidos por id de cliente.
     *
     * @param clienteId id del cliente
     * @return lista de pedidos
     */
    List<PedidoDto> findByClienteId(Long clienteId);

    /**
     * Busca pedidos con detalles por id de cliente.
     *
     * @param clienteId id del cliente
     * @return lista de pedidos con sus detalles
     */
    List<PedidoConDetallesDto> findByClienteIdConDetalles(Long clienteId);

    /**
     * Busca pedidos con detalles por id de negocio.
     *
     * @param negocioId id del negocio
     * @return lista de pedidos con sus detalles
     */
    List<PedidoConDetallesDto> findByNegocioIdConDetalles(Long negocioId);

    /**
     * Busca pedidos por id de negocio.
     *
     * @param negocioId id del negocio
     * @return lista de pedidos
     */
    List<PedidoDto> findByNegocioId(Long negocioId);

    /**
     * Crea un pedido completo con detalles en una transacción atómica.
     *
     * @param request request con clienteId, negocioId y detalles
     * @return el pedido creado con detalles
     */
    PedidoConDetallesDto crearPedidoCompleto(org.example.prazashop.model.dto.PedidoCreacionRequest request);

    /**
     * Busca pedidos con filtros y paginación.
     *
     * @param estado estado del pedido (opcional)
     * @param fechaDesde fecha mínima (opcional)
     * @param fechaHasta fecha máxima (opcional)
     * @param precioDesde precio mínimo (opcional)
     * @param precioHasta precio máximo (opcional)
     * @param ordenar criterio de ordenamiento: fecha_asc, fecha_desc, total_asc, total_desc
     * @param pagina número de página (0-indexed)
     * @param tamaño cantidad de resultados por página
     * @return response con paginación
     */
    org.example.prazashop.model.dto.PedidoSearchResponse buscarPedidos(
            String estado,
            java.time.LocalDateTime fechaDesde,
            java.time.LocalDateTime fechaHasta,
            Double precioDesde,
            Double precioHasta,
            String ordenar,
            Integer pagina,
            Integer tamaño
    );

    /**
     * Obtiene la entidad Pedido por ID (sin convertir a DTO).
     *
     * @param id id del pedido
     * @return entidad Pedido
     */
    org.example.prazashop.model.entity.Pedido findEntityById(Long id);

    /**
     * Convierte una entidad Pedido a PedidoConDetallesDto.
     *
     * @param pedido entidad a convertir
     * @return PedidoConDetallesDto
     */
    org.example.prazashop.model.dto.PedidoConDetallesDto toDtoConDetalles(org.example.prazashop.model.entity.Pedido pedido);
}
