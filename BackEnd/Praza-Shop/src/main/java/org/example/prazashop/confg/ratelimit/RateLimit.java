package org.example.prazashop.confg.ratelimit;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Anotación para aplicar rate limiting a endpoints específicos.
 * Limita el número de peticiones por minuto por usuario.
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RateLimit {
    
    /**
     * Número máximo de peticiones permitidas por intervalo de tiempo.
     * @return límite de peticiones
     */
    int requestsPerMinute() default 100;
}
