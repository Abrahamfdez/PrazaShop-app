package org.example.prazashop.exception;

import java.time.Instant;

import org.springframework.http.HttpStatus;

/**
 * The type Api error response.
 */
public class ApiErrorResponse {

    private final Instant timestamp;
    private final int status;
    private final String error;
    private final String message;
    private final String path;

    private ApiErrorResponse(HttpStatus status, String message, String path) {
        this.timestamp = Instant.now();
        this.status = status.value();
        this.error = status.getReasonPhrase();
        this.message = message;
        this.path = path;
    }

    /**
     * Of api error response.
     *
     * @param status  the status
     * @param message the message
     * @param path    the path
     * @return the api error response
     */
    public static ApiErrorResponse of(HttpStatus status, String message, String path) {
        return new ApiErrorResponse(status, message, path);
    }

    /**
     * Gets timestamp.
     *
     * @return the timestamp
     */
    public Instant getTimestamp() {
        return timestamp;
    }

    /**
     * Gets status.
     *
     * @return the status
     */
    public int getStatus() {
        return status;
    }

    /**
     * Gets error.
     *
     * @return the error
     */
    public String getError() {
        return error;
    }

    /**
     * Gets message.
     *
     * @return the message
     */
    public String getMessage() {
        return message;
    }

    /**
     * Gets path.
     *
     * @return the path
     */
    public String getPath() {
        return path;
    }
}

