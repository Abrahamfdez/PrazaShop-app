package org.example.prazashop.exception;

import java.time.Instant;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonInclude;

import org.springframework.http.HttpStatus;

/**
 * The type Api error response.
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiErrorResponse {

    private final Instant timestamp;
    private final int status;
    private final String error;
    private final String message;
    private final String path;
    private final List<FieldError> errors;

    private ApiErrorResponse(HttpStatus status, String message, String path, List<FieldError> errors) {
        this.timestamp = Instant.now();
        this.status = status.value();
        this.error = status.getReasonPhrase();
        this.message = message;
        this.path = path;
        this.errors = errors;
    }

    /**
     * Of api error response (sin errores de campo).
     *
     * @param status  the status
     * @param message the message
     * @param path    the path
     * @return the api error response
     */
    public static ApiErrorResponse of(HttpStatus status, String message, String path) {
        return new ApiErrorResponse(status, message, path, null);
    }

    /**
     * Of api error response (con errores de validación).
     *
     * @param status  the status
     * @param message the message
     * @param path    the path
     * @param errors  list of field errors
     * @return the api error response
     */
    public static ApiErrorResponse of(HttpStatus status, String message, String path, List<FieldError> errors) {
        return new ApiErrorResponse(status, message, path, errors);
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

    /**
     * Gets field errors.
     *
     * @return the errors
     */
    public List<FieldError> getErrors() {
        return errors;
    }
}

