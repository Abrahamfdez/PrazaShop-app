package org.example.prazashop.exception;

import org.springframework.http.HttpStatus;

public class NoContentException extends ApiException {

    /**
     * Instantiates a new Bad request exception.
     *
     * @param message the message
     */
    public NoContentException(String message) {
        super(HttpStatus.NO_CONTENT, message);
    }
}