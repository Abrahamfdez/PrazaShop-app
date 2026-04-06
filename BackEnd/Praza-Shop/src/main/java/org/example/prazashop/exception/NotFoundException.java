package org.example.prazashop.exception;

import org.springframework.http.HttpStatus;

/**
 * The type Not found exception.
 */
public class NotFoundException extends ApiException {

    /**
     * Instantiates a new Not found exception.
     *
     * @param message the message
     */
    public NotFoundException(String message) {
        super(HttpStatus.NOT_FOUND, message);
    }
}

