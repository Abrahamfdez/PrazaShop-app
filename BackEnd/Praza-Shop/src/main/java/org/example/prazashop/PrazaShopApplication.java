package org.example.prazashop;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

/**
 * The type Praza shop application.
 */
@SpringBootApplication
@EnableAspectJAutoProxy
public class PrazaShopApplication {

    /**
     * The entry point of application.
     *
     * @param args the input arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(PrazaShopApplication.class, args);
    }

}
