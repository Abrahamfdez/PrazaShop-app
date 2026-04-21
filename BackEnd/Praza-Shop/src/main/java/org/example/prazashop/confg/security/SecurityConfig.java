package org.example.prazashop.confg.security;

import lombok.RequiredArgsConstructor;
import org.example.prazashop.model.entity.Usuario;
import org.example.prazashop.repository.UsuarioRepository;
import org.springframework.context.annotation.Bean;
import static org.springframework.security.config.Customizer.withDefaults;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Configuración de seguridad para la aplicación.
 * Define la autenticación, autorización y filtros de seguridad.
 */
@Configuration
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    // Repositorio para acceder a los usuarios en la base de datos
    private final UsuarioRepository usuarioRepository;
    // Codificador de contraseñas (PasswordEncoder)
    private final PasswordEncoder passwordEncoder;

    /**
     * Servicio que carga los detalles del usuario a partir del email.
     * @return UserDetailsService personalizado
     */
    @Bean
    public UserDetailsService userDetailsService() {
        // Busca el usuario por email y lo mapea a UserDetails
        return username -> usuarioRepository.findByEmail(username)
                .map(this::mapToUserDetails)
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado: " + username));
    }

    /**
     * Convierte un objeto Usuario a UserDetails de Spring Security.
     * @param usuario el usuario de la base de datos
     * @return UserDetails con roles y credenciales
     */
    private UserDetails mapToUserDetails(Usuario usuario) {
        // Asigna el rol según el tipo de usuario
        var authority = "ROLE_" + usuario.getTipoUsuario().name();
        return org.springframework.security.core.userdetails.User
                .withUsername(usuario.getEmail())
                .password(usuario.getContrasinal())
                .authorities(authority)
                .build();
    }

    /**
     * Proveedor de autenticación que utiliza el UserDetailsService y el PasswordEncoder.
     * @param uds UserDetailsService
     * @return DaoAuthenticationProvider configurado
     */
    @Bean
    public DaoAuthenticationProvider authenticationProvider(UserDetailsService uds) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider(uds);
        provider.setPasswordEncoder(passwordEncoder);
        return provider;
    }

    /**
     * Configura el AuthenticationManager con el proveedor de autenticación.
     * @param http HttpSecurity
     * @param authProvider DaoAuthenticationProvider
     * @return AuthenticationManager
     * @throws Exception en caso de error
     */
    @Bean
    public AuthenticationManager authenticationManager(
            HttpSecurity http,
            DaoAuthenticationProvider authProvider
    ) throws Exception {
        // Construye el AuthenticationManager usando el proveedor personalizado
        AuthenticationManagerBuilder builder = http.getSharedObject(AuthenticationManagerBuilder.class);
        builder.authenticationProvider(authProvider);
        return builder.build();
    }

    /**
     * Cadena de filtros de seguridad para definir las reglas de acceso y filtros personalizados.
     * @param http HttpSecurity
     * @param authProvider DaoAuthenticationProvider
     * @param jwtAuthenticationFilter Filtro JWT personalizado
     * @return SecurityFilterChain
     * @throws Exception en caso de error
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http,
                                                   DaoAuthenticationProvider authProvider,
                                                   JwtAuthenticationFilter jwtAuthenticationFilter) throws Exception {
        http
            // Configura CORS con valores por defecto
            .cors(withDefaults())
            // Desactiva CSRF porque usamos JWT (stateless)
            .csrf(AbstractHttpConfigurer::disable)
            // Configura la sesión como STATELESS (sin sesión en servidor)
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            // Define las reglas de autorización para los endpoints
            .authorizeHttpRequests(auth -> auth
                    // Permite acceso sin autenticación a /api/auth/** y consola H2
                    .requestMatchers("/api/auth/**", "/h2-console/**").permitAll()
                    // Permite acceso sin autenticación al endpoint de prueba
                    .requestMatchers(HttpMethod.GET, "/api/test/hola").permitAll()
                    // Permite acceso a Swagger UI y OpenAPI
                    .requestMatchers("/swagger-ui/**", "/v3/api-docs/**", "/swagger-ui.html", "/webjars/**").permitAll()
                    // El resto de endpoints requieren autenticación
                    .anyRequest().authenticated()
            )
            // Usa el proveedor de autenticación personalizado
            .authenticationProvider(authProvider)
            // Añade el filtro JWT antes del filtro de autenticación por usuario/contraseña
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
            // Permite que la consola H2 funcione correctamente en el navegador
            .headers(headers -> headers.frameOptions(frame -> frame.sameOrigin()));

        // Devuelve la cadena de filtros configurada
        return http.build();
    }
}
