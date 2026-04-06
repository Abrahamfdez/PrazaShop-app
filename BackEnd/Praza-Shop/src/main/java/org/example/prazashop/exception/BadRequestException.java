package org.example.prazashop.exception;

import org.springframework.http.HttpStatus;

/**
 * The type Bad request exception.
 */
public class BadRequestException extends ApiException {

    /**
     * Instantiates a new Bad request exception.
     *
     * @param message the message
     */
    public BadRequestException(String message) {
        super(HttpStatus.BAD_REQUEST, message);
    }
}

