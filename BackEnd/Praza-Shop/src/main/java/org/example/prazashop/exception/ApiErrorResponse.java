package org.example.prazashop.exception;

import java.time.Instant;

import org.springframework.http.HttpStatus;

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

    public static ApiErrorResponse of(HttpStatus status, String message, String path) {
        return new ApiErrorResponse(status, message, path);
    }

    public Instant getTimestamp() {
        return timestamp;
    }

    public int getStatus() {
        return status;
    }

    public String getError() {
        return error;
    }

    public String getMessage() {
        return message;
    }

    public String getPath() {
        return path;
    }
}

