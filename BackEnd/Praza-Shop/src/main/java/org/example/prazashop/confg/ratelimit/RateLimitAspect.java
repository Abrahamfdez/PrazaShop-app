package org.example.prazashop.confg.ratelimit;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.server.ResponseStatusException;

import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Aspecto para aplicar rate limiting a métodos anotados con @RateLimit.
 * Mantiene un registro de peticiones por usuario (por IP/email) durante cada minuto.
 */
@Aspect
@Component
public class RateLimitAspect {
    
    // Estructura para almacenar contador de peticiones por usuario
    // Clave: "usuario:timestamp" (timestamp es el inicio del minuto actual)
    private final Map<String, AtomicInteger> requestCounters = new ConcurrentHashMap<>();
    private final Map<String, Long> requestTimestamps = new ConcurrentHashMap<>();
    
    /**
     * Intercepta métodos anotados con @RateLimit y valida el límite de peticiones.
     * 
     * @param joinPoint punto de ejecución
     * @param rateLimit anotación con configuración de rate limiting
     * @throws ResponseStatusException si se excede el límite
     */
    @Before("@annotation(rateLimit)")
    public void enforceRateLimit(JoinPoint joinPoint, RateLimit rateLimit) {
        String userIdentifier = getUserIdentifier();
        int requestLimit = rateLimit.requestsPerMinute();
        
        long currentMinute = System.currentTimeMillis() / 60000; // Minuto actual
        String key = userIdentifier + ":" + currentMinute;
        
        // Limpiar contadores antiguos (opcional, para evitar memory leak)
        requestTimestamps.entrySet().removeIf(entry -> 
            (System.currentTimeMillis() / 60000) - entry.getValue() > 2
        );
        
        // Obtener o crear contador para este usuario en este minuto
        AtomicInteger counter = requestCounters.computeIfAbsent(key, k -> {
            requestTimestamps.put(key, currentMinute);
            return new AtomicInteger(0);
        });
        
        // Incrementar contador
        int currentCount = counter.incrementAndGet();
        
        // Validar límite
        if (currentCount > requestLimit) {
            throw new ResponseStatusException(
                HttpStatus.TOO_MANY_REQUESTS,
                "Has excedido el límite de " + requestLimit + " peticiones por minuto"
            );
        }
    }
    
    /**
     * Obtiene el identificador único del usuario.
     * Intenta obtener el email del usuario autenticado o usa la IP como fallback.
     * 
     * @return identificador único del usuario
     */
    private String getUserIdentifier() {
        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                HttpServletRequest request = attributes.getRequest();
                
                // Intentar obtener email del usuario autenticado
                String principal = request.getUserPrincipal() != null ? 
                    request.getUserPrincipal().getName() : null;
                
                if (principal != null && !principal.isEmpty()) {
                    return principal;
                }
                
                // Fallback: usar IP del cliente
                String ip = request.getHeader("X-Forwarded-For");
                if (ip == null || ip.isEmpty()) {
                    ip = request.getRemoteAddr();
                }
                return ip;
            }
        } catch (Exception e) {
            // Fallback silencioso
        }
        
        return "unknown";
    }
}
