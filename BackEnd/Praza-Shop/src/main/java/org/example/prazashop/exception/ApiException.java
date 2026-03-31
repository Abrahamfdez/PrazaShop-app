package org.example.prazashop.exception;

import org.springframework.http.HttpStatus;

/**
 * Base unchecked exception that stores the HTTP status expected in the response layer.
 */
public abstract class ApiException extends RuntimeException {

    private final HttpStatus status;

    protected ApiException(HttpStatus status, String message) {
        super(message);
        this.status = status;
    }

    public HttpStatus getStatus() {
        return status;
    }
}

