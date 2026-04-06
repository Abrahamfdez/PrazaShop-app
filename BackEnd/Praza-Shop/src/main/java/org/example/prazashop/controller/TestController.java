package org.example.prazashop.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * The type Test controller.
 */
@RestController
@RequestMapping("/api/test")
public class TestController {

    /**
     * Hola string.
     *
     * @return the string
     */
    @GetMapping("/hola")
    public String hola() {
        return "hola, esto es un test";
    }
}

