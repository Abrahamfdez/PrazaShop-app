package org.example.prazashop.service;

import org.example.prazashop.exception.NotFoundException;
import org.example.prazashop.model.entity.Cliente;
import org.example.prazashop.model.entity.Negocio;
import org.example.prazashop.model.entity.Producto;
import org.example.prazashop.model.entity.Usuario;
import org.example.prazashop.repository.ClienteRepository;
import org.example.prazashop.repository.NegocioRepository;
import org.example.prazashop.repository.ProductoRepository;
import org.example.prazashop.repository.UsuarioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

/**
 * Servicio para extraer información del usuario autenticado del contexto de seguridad.
 * Reduce boilerplate en controladores al centralizar la lógica de obtener usuarioId, negocio, cliente, etc.
 */
@Service
public class UsuarioContextService {

    private final UsuarioRepository usuarioRepository;
    private final NegocioRepository negocioRepository;
    private final ClienteRepository clienteRepository;
    private final ProductoRepository productoRepository;

    public UsuarioContextService(
            UsuarioRepository usuarioRepository,
            NegocioRepository negocioRepository,
            ClienteRepository clienteRepository,
            ProductoRepository productoRepository) {
        this.usuarioRepository = usuarioRepository;
        this.negocioRepository = negocioRepository;
        this.clienteRepository = clienteRepository;
        this.productoRepository = productoRepository;
    }

    /**
     * Obtiene el email del usuario autenticado desde el contexto de seguridad.
     *
     * @return email del usuario autenticado
     * @throws SecurityException si no hay usuario autenticado
     */
    public String getCurrentUserEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            throw new SecurityException("No hay usuario autenticado");
        }
        return auth.getName();
    }

    /**
     * Obtiene el ID del usuario autenticado.
     *
     * @return id del usuario
     * @throws NotFoundException si el usuario no existe
     */
    public Long getCurrentUserId() {
        String email = getCurrentUserEmail();
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("Usuario no encontrado: " + email));
        return usuario.getId();
    }

    /**
     * Obtiene la entidad Usuario del usuario autenticado.
     *
     * @return Usuario entity
     * @throws NotFoundException si el usuario no existe
     */
    public Usuario getCurrentUsuario() {
        String email = getCurrentUserEmail();
        return usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new NotFoundException("Usuario no encontrado: " + email));
    }

    /**
     * Obtiene el negocio asociado al usuario autenticado.
     *
     * @return Negocio entity
     * @throws NotFoundException si el usuario no tiene negocio asociado
     */
    public Negocio getNegocioOfCurrentUser() {
        Long usuarioId = getCurrentUserId();
        return negocioRepository.findByUsuario_Id(usuarioId)
                .orElseThrow(() -> new NotFoundException("El usuario no tiene un negocio asociado"));
    }

    /**
     * Obtiene el cliente asociado al usuario autenticado.
     *
     * @return Cliente entity
     * @throws NotFoundException si el usuario no tiene cliente asociado
     */
    public Cliente getClienteOfCurrentUser() {
        Long usuarioId = getCurrentUserId();
        return clienteRepository.findByUsuario_Id(usuarioId)
                .orElseThrow(() -> new NotFoundException("El usuario no tiene un cliente asociado"));
    }

    /**
     * Verifica si el usuario autenticado es dueño de un negocio específico.
     * Lanza ForbiddenException si no lo es.
     *
     * @param negocioId ID del negocio
     * @throws ResponseStatusException (403) si no es propietario
     */
    public void isOwnerOfNegocio(Long negocioId) {
        Negocio negocio = negocioRepository.findById(negocioId)
                .orElseThrow(() -> new NotFoundException("Negocio no encontrado"));
        Long currentUserId = getCurrentUserId();
        if (!negocio.getUsuario().getId().equals(currentUserId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, 
                "No tienes permisos para acceder a este negocio");
        }
    }

    /**
     * Verifica si el usuario autenticado es el cliente dueño de un pedido.
     * Lanza ForbiddenException si no lo es.
     *
     * @param clienteId ID del cliente
     * @throws ResponseStatusException (403) si no es propietario
     */
    public void isOwnerOfCliente(Long clienteId) {
        Cliente cliente = clienteRepository.findById(clienteId)
                .orElseThrow(() -> new NotFoundException("Cliente no encontrado"));
        Long currentUserId = getCurrentUserId();
        if (!cliente.getUsuario().getId().equals(currentUserId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, 
                "No tienes permisos para acceder a este cliente");
        }
    }

    /**
     * Verifica si el usuario autenticado es dueño de un producto específico.
     * Lanza ForbiddenException si no lo es.
     *
     * @param productoId ID del producto
     * @throws ResponseStatusException (403) si no es propietario
     */
    public void isOwnerOfProducto(Long productoId) {
        Producto producto = productoRepository.findById(productoId)
                .orElseThrow(() -> new NotFoundException("Producto no encontrado"));
        Long currentUserId = getCurrentUserId();
        if (!producto.getNegocio().getUsuario().getId().equals(currentUserId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, 
                "No tienes permisos para modificar este producto");
        }
    }
}
