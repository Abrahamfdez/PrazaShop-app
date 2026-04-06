package org.example.prazashop.exception;

import org.springframework.http.HttpStatus;

/**
 * Base unchecked exception that stores the HTTP status expected in the response layer.
 */
public abstract class ApiException extends RuntimeException {

    private final HttpStatus status;

    /**
     * Instantiates a new Api exception.
     *
     * @param status  the status
     * @param message the message
     */
    protected ApiException(HttpStatus status, String message) {
        super(message);
        this.status = status;
    }

    /**
     * Gets status.
     *
     * @return the status
     */
    public HttpStatus getStatus() {
        return status;
    }
}

