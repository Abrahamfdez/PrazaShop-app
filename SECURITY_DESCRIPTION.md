# Descripción de Seguridade - Backend PrazaShop

## Resumo Executivo

O backend de PrazaShop implementa múltiples capas de seguridad para protexer os datos dos usuarios e a integridade da aplicación. A seguridade está baseada en autenticación JWT, autorización por roles e validación rigorosa de entradas.

---

## Medidas de Seguridade Implementadas

### 1. **Autenticación JWT (JSON Web Tokens)**
- **Access tokens**: Válidos durante 15 minutos
- **Refresh tokens**: Válidos durante 30 días
- **Almacenamento**: Tokens registrados en base de datos para rastrexo de revocación
- **Validación**: Comprobación de firma HMAC-SHA e expiración en cada requisición

### 2. **Autorización Baseada en Roles**
- Tres roles implementados: **CLIENTE**, **NEGOCIO** e **ADMIN**
- Control de acceso a nivel de método (`@EnableMethodSecurity`)
- Validación de propiedade de recursos: usuarios acceden só aos seus datos
- Sesións stateless (sen estado no servidor)

### 3. **Encriptación de Contrasinais**
- Algoritmo: **BCryptPasswordEncoder**
- Non se almacenan contrasinais en texto plano
- Contrasinais verificados contra hash almacenado na autenticación

### 4. **Validación de Entrada e Sanitización**
- Validacións con **Jakarta Bean Validation** en todos os DTOs
- Restricións implementadas: `@NotBlank`, `@Email`, `@NotNull`, `@Size`, `@Pattern`, etc.
- Normalización de datos (lowercase, trim en emails)
- Rexeitamento de solicitudes malformadas con códigos de erro 400

### 5. **Manexo Centralizado de Excepcións**
- `@RestControllerAdvice` para captura global de erros
- Respostas estruturadas con mensaxes apropriadas
- Oculta detalles internos de erro en respostas públicas
- Códigos HTTP apropriados: 400 (validación), 404 (non encontrado), 409 (conflicto), 500 (erro)

### 6. **Limitación de Requisicións (Rate Limiting)**
- Control de requisicións por minuto usando anotación `@RateLimit`
- Identificación por usuario autenticado ou dirección IP
- Límite por defecto: 100 requisicións por minuto
- Responde con HTTP 429 ao exceder límite

### 7. **Configuración CORS (Cross-Origin Resource Sharing)**
- Orixes permitidas configurables
- Métodos permitidos: GET, POST, PUT, DELETE, OPTIONS
- Headers customizados permitidos
- Previne ataques desde orixes non autorizadas

### 8. **Protección CSRF**
- Desactivada intencionalmente (apropiado para APIs stateless con JWT)
- Non se usa cookies de sesión, evitando vulnerabilidades CSRF

### 9. **Auditoría e Logging**
- Logging de intentos de autenticación con SLF4J
- Rexistro de tokens mal formados, expirados ou revocados
- Rastrexo de erros con nivel WARN/ERROR
- Información de usuario autenticado en logs

### 10. **Protección de Headers**
- X-Frame-Options configurado con `sameOrigin()` (protección contra clickjacking)
- H2 Console (base de datos) protexido con frame options

---

## Stack de Seguridad

| Componente | Tecnoloxía |
|-----------|-----------|
| **Autenticación** | Spring Security + JWT (JJWT v0.13.0) |
| **Encriptación** | BCryptPasswordEncoder |
| **Validación** | Jakarta Bean Validation |
| **Autorización** | Spring Security Method-Level (`@EnableMethodSecurity`) |
| **Logging** | SLF4J |
| **Rate Limiting** | Custom AOP + ConcurrentHashMap |

---

## Fluxo de Autenticación

1. Usuario envía credentials (email/contraseña) a `/auth/login`
2. Servidor valida contra contraseña encriptada en BD
3. Se é válido, xera access token + refresh token
4. Cliente inclúe access token en header `Authorization: Bearer <token>`
5. Filtro JWT (`JwtAuthenticationFilter`) valida token en cada requisición
6. Contexto de seguridade establécese con usuario autenticado
7. `@EnableMethodSecurity` comproba roles para métodos protexidos

---

## Recomendacións para Produción

### Críticas
- ⚠️ **CORS**: Cambiar orixes `*` por dominio específico en produción
- ⚠️ **JWT Secret**: Usar clave máis forte (atual parece ser placeholder)

### Melloras Recomendadas
- Engadir min/max length validación en contrasinais
- Ampliar auditoría de cambios en datos sensibles
- Diferenciar límites de rate limiting por rol
- Implementar token rotation automático
- Usar HTTPS en produción (protección en tránsito)

---

## Conclusión

PrazaShop implementa un sistema de seguridad robusto e multicapa que protexe contra as vulnerabilidades máis comúns (autenticación débil, SQL injection mediante validación, XSS, CSRF en APIs stateless). O sistema está preparado para un ambiente de produción con pequenos axustes nos parámetros de configuración.
