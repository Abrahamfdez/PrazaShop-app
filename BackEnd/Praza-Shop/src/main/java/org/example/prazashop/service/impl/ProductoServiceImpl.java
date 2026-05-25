package org.example.prazashop.service.impl;

import org.example.prazashop.exception.BadRequestException;
import org.example.prazashop.exception.NoContentException;
import org.example.prazashop.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.dto.ProductoDto;
import org.example.prazashop.model.dto.ProductoDetallesDto;
import org.example.prazashop.model.entity.Negocio;
import org.example.prazashop.model.entity.Producto;
import org.example.prazashop.repository.NegocioRepository;
import org.example.prazashop.repository.ProductoRepository;
import org.example.prazashop.service.ProductoService;
import org.example.prazashop.service.ValoracionService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;


/**
 * The type Producto service.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class ProductoServiceImpl implements ProductoService {

    private final ProductoRepository productoRepository;
    private final NegocioRepository negocioRepository;
    private final ValoracionService valoracionService;

    @Override
    @Transactional(readOnly = true)
    public List<ProductoDto> findAll() {
        return productoRepository.findAll().stream()
                .map(this::toDto)
                .toList();
    }

    @Override
    @Transactional(readOnly = true)
    public ProductoDto findById(Long id) {
        return productoRepository.findById(id)
                .map(this::toDto)
                .orElseThrow(() -> new NoContentException("Producto no encontrado"));
    }

    @Override
    public ProductoDto create(ProductoDto producto) {
        validateDto(producto);
        Producto entity = new Producto();
        applyDto(entity, producto);
        return toDto(productoRepository.save(entity));
    }

    @Override
    public ProductoDto update(Long id, ProductoDto producto) {
        Producto existing = productoRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Producto no encontrado con id " + id));
        validateDto(producto);
        applyDto(existing, producto);
        return toDto(productoRepository.save(existing));
    }

    @Override
    public void deleteById(Long id) {
        if (!productoRepository.existsById(id)) {
            throw new NotFoundException("Producto no encontrado con id " + id);
        }
        productoRepository.deleteById(id);
    }

    /**
     * Devuelve todos los productos de un negocio por su ID.
     *
     * @param negocioId identificador del negocio
     * @return lista de productos del negocio
     */
    @Override
    @Transactional(readOnly = true)
    public List<ProductoDto> findByNegocioId(Long negocioId) {
        return productoRepository.findAll().stream()
                .filter(p -> p.getNegocio() != null && negocioId.equals(p.getNegocio().getIdNegocio()))
                .map(this::toDto)
                .toList();
    }

    private ProductoDto toDto(Producto producto) {
        return ProductoDto.builder()
                .id(producto.getIdProducto())
                .negocioId(producto.getNegocio() != null ? producto.getNegocio().getIdNegocio() : null)
                .nome(producto.getNome())
                .descricion(producto.getDescricion())
                .prezo(producto.getPrezo())
                .stock(producto.getStock())
                .categoria(producto.getCategoria())
                .duracionOferta(producto.getDuracionOferta())
                .imaxe(producto.getImaxe())
                .estado(producto.getEstado())
                .build();
    }

    private void applyDto(Producto producto, ProductoDto dto) {
        if (dto.getNegocioId() != null) {
            Negocio negocio = negocioRepository.findById(dto.getNegocioId())
                    .orElseThrow(() -> new NotFoundException("Negocio no encontrado con id " + dto.getNegocioId()));
            producto.setNegocio(negocio);
        } else if (producto.getNegocio() == null) {
            throw new BadRequestException("negocioId es obligatorio");
        }
        producto.setNome(dto.getNome());
        producto.setDescricion(dto.getDescricion());
        producto.setPrezo(dto.getPrezo());
        producto.setStock(dto.getStock());
        producto.setCategoria(dto.getCategoria());
        producto.setDuracionOferta(dto.getDuracionOferta());
        producto.setImaxe(dto.getImaxe());
        producto.setEstado(dto.getEstado());
    }

    private void validateDto(ProductoDto dto) {
        if (dto == null) {
            throw new BadRequestException("El cuerpo de producto es obligatorio");
        }
        if (!StringUtils.hasText(dto.getNome())) {
            throw new BadRequestException("nome es obligatorio");
        }
        if (dto.getPrezo() == null || dto.getPrezo() < 0) {
            throw new BadRequestException("prezo debe ser mayor o igual a 0");
        }
        if (dto.getStock() == null || dto.getStock() < 0) {
            throw new BadRequestException("stock debe ser mayor o igual a 0");
        }
    }

    @Override
    @Transactional(readOnly = true)
    public ProductoDetallesDto getProductoDetalles(Long productoId) {
        // Obtener producto
        Producto producto = productoRepository.findById(productoId)
                .orElseThrow(() -> new NotFoundException("Producto no encontrado con id " + productoId));

        // Obtener negocio asociado
        Negocio negocio = producto.getNegocio();
        if (negocio == null) {
            throw new NotFoundException("El producto no tiene negocio asociado");
        }

        // Calcular estadísticas del negocio
        Double ratingPromedio = valoracionService.getAveragePuntuacionByNegocioId(negocio.getIdNegocio());
        Long cantidadValoraciones = valoracionService.getCountValoracionesByNegocioId(negocio.getIdNegocio());

        // Construir respuesta
        return ProductoDetallesDto.builder()
                .producto(toDto(producto))
                .negocio(ProductoDetallesDto.NegocioInfoDto.builder()
                        .id(negocio.getIdNegocio())
                        .nomeNegocio(negocio.getNomeNegocio())
                        .descricion(negocio.getDescricion())
                        .build())
                .stats(ProductoDetallesDto.ProductoStats.builder()
                        .ratingPromedio(ratingPromedio != null ? ratingPromedio : 0.0)
                        .cantidadValoraciones(cantidadValoraciones != null ? cantidadValoraciones.intValue() : 0)
                        .build())
                .build();
    }
}
