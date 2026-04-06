package org.example.prazashop.exception;

import org.springframework.http.HttpStatus;

/**
 * The type Conflict exception.
 */
public class ConflictException extends ApiException {
    /**
     * Instantiates a new Conflict exception.
     *
     * @param message the message
     */
    public ConflictException(String message) {
        super(HttpStatus.CONFLICT, message);
    }
}
