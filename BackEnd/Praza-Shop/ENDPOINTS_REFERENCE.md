# 🎯 Resumen Completo de Endpoints - PrazaShop API

## 📊 Tabla de Contenidos

| Sección | Endpoints | Estado |
|---------|-----------|--------|
| 🔐 Autenticación | 4 | ✅ Funcionales |
| 📦 Productos | 6 | ✅ Funcionales |
| 👥 Clientes | 5 | ✅ Funcionales |
| 🏢 Negocios | 6 | ✅ Funcionales |
| 📋 Pedidos | 7 | ✅ Funcionales |
| 📦 Detalles Pedidos | 5 | ✅ Funcionales |
| 🔄 Compras Recurrentes | 5 | ✅ Funcionales |
| ⭐ Valoraciones | 5 | ✅ Funcionales |
| 👤 Usuarios | 5 | ✅ Funcionales |
| 🧪 Test | 1 | ✅ Funcional |

**Total: 49 Endpoints Funcionales (5 nuevos endpoints de optimización agregados)**

---

## 🔐 AUTENTICACIÓN

### 1. Registro de Usuario
```
POST /api/auth/register
```
**Descripción:** Registra un nuevo usuario en el sistema
**Autenticación:** No requerida
**Request:**
```json
{
  "nome": "Juan García",
  "email": "juan@example.com",
  "contrasinal": "password123",
  "telefono": "+34 612 345 678",
  "tipoUsuario": "CLIENTE"
}
```
**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### 2. Login
```
POST /api/auth/login
```
**Descripción:** Inicia sesión y obtiene tokens JWT
**Autenticación:** No requerida
**Request:**
```json
{
  "email": "a@admin.es",
  "contrasinal": "admin"
}
```
**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### 3. Refrescar Token
```
POST /api/auth/refresh
```
**Descripción:** Obtiene un nuevo access token usando el refresh token
**Autenticación:** No requerida
**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```
**Response:**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### 4. Registro de Vendedor (Registro Atómico)
```
POST /api/auth/register-vendedor
```
**Descripción:** Crea un nuevo usuario con rol NEGOCIO y su negocio asociado en una sola transacción atómica. 
**Autenticación:** No requerida
**Request:**
```json
{
  "email": "vendedor@example.com",
  "contraseña": "password123",
  "nombreNegocio": "Mi Tienda Online",
  "descripcion": "Descripción de la tienda"
}
```
**Response:**
```json
{
  "usuario": {
    "id": 1,
    "nome": "vendedor@example.com",
    "email": "vendedor@example.com",
    "tipoUsuario": "NEGOCIO"
  },
  "negocio": {
    "id": 1,
    "nomeNegocio": "Mi Tienda Online",
    "descricion": "Descripción de la tienda",
    "usuarioId": 1
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```
**Errores:**
- `400 Bad Request`: Email ya existe
- `422 Unprocessable Entity`: Datos inválidos

---

## 📦 PRODUCTOS

### 1. Obtener todos los productos
```
GET /api/productos
```
**Autenticación:** Requerida ✔️

---

### 2. Obtener producto por ID
```
GET /api/productos/{id}
```
**Autenticación:** Requerida ✔️
**Parámetros:** `id` (Long)

---

### 3. Crear producto
```
POST /api/productos
```
**Autenticación:** Requerida ✔️
**Request:**
```json
{
  "negocioId": 1,
  "nome": "Producto",
  "descricion": "Descripción",
  "prezo": 29.99,
  "stock": 100,
  "categoria": "Electrónica",
  "imaxe": "https://example.com/image.jpg"
}
```

---

### 4. Actualizar producto
```
PUT /api/productos/{id}
```
**Autenticación:** Requerida ✔️

---

### 5. Eliminar producto
```
DELETE /api/productos/{id}
```
**Autenticación:** Requerida ✔️

---

### 6. Obtener detalles del producto con negocio y valoraciones
```
GET /api/productos/{id}/detalles
```
**Descripción:** Obtiene el producto con información completa del negocio propietario y estadísticas de valoraciones en una sola llamada.
**Autenticación:** No requerida
**Response:**
```json
{
  "producto": {
    "id": 1,
    "nome": "Laptop Gaming",
    "prezo": 999.99,
    "descricion": "Laptop potente para gaming",
    "stock": 10,
    "negocioId": 1
  },
  "negocio": {
    "id": 1,
    "nomeNegocio": "TechStore",
    "descricion": "Tienda de tecnología"
  },
  "stats": {
    "ratingPromedio": 4.5,
    "cantidadValoraciones": 24
  }
}
```

---

## 👥 CLIENTES

### 1. Obtener todos los clientes
```
GET /api/clientes
```
**Autenticación:** Requerida ✔️

---

### 2. Obtener cliente por ID
```
GET /api/clientes/{id}
```
**Autenticación:** Requerida ✔️

---

### 3. Crear cliente
```
POST /api/clientes
```
**Autenticación:** Requerida ✔️
**Request:**
```json
{
  "usuarioId": 1,
  "empresa": "Mi Empresa",
  "nif": "12345678A",
  "provincia": "Madrid",
  "direccion": "Calle Principal 123",
  "cp": "28001"
}
```

---

### 4. Actualizar cliente
```
PUT /api/clientes/{id}
```
**Autenticación:** Requerida ✔️

---

### 5. Eliminar cliente
```
DELETE /api/clientes/{id}
```
**Autenticación:** Requerida ✔️

---

## 🏢 NEGOCIOS

### 1. Obtener todos los negocios
```
GET /api/negocios
```
**Autenticación:** Requerida ✔️

---

### 2. Obtener negocio por ID
```
GET /api/negocios/{id}
```
**Autenticación:** Requerida ✔️

---

### 3. Crear negocio
```
POST /api/negocios
```
**Autenticación:** Requerida ✔️
**Request:**
```json
{
  "usuarioId": 1,
  "nome": "Mi Negocio",
  "descricion": "Descripción del negocio",
  "categoria": "Tienda",
  "provincia": "Madrid",
  "logo": "https://example.com/logo.jpg"
}
```

---

### 4. Actualizar negocio
```
PUT /api/negocios/{id}
```
**Autenticación:** Requerida ✔️

---

### 5. Eliminar negocio
```
DELETE /api/negocios/{id}
```
**Autenticación:** Requerida ✔️

---

### 6. Obtener Dashboard del Negocio (Consolidado)
```
GET /api/negocios/{id}/dashboard
```
**Descripción:** Obtiene el dashboard completo del negocio con información consolidada: datos del negocio, últimos 10 productos, últimos 10 pedidos y estadísticas (rating, total de ventas, ingresos totales, cantidad de valoraciones). Solo el propietario del negocio puede acceder a su dashboard.
**Autenticación:** Requerida ✔️ (Solo propietario)
**Response:**
```json
{
  "negocio": {
    "id": 1,
    "nomeNegocio": "TechStore",
    "descricion": "Tienda de tecnología online",
    "usuarioId": 1
  },
  "productos": [
    {
      "id": 1,
      "nome": "Laptop Gaming",
      "prezo": 999.99,
      "stock": 10
    }
  ],
  "pedidosRecientes": [
    {
      "id": 1,
      "clienteId": 2,
      "total": 999.99,
      "estado": "ENTREGADO",
      "dataPedido": "2024-01-15T10:30:00"
    }
  ],
  "stats": {
    "ratingPromedio": 4.7,
    "totalVentasCount": 45,
    "ingresosTotales": 44995.55,
    "cantidadValoraciones": 32
  }
}
```
**Errores:**
- `401 Unauthorized`: No autenticado
- `403 Forbidden`: No es propietario del negocio
- `404 Not Found`: Negocio no encontrado

---

## 📋 PEDIDOS

### 1. Obtener todos los pedidos
```
GET /api/pedidos
```
**Autenticación:** Requerida ✔️

---

### 2. Obtener pedido por ID
```
GET /api/pedidos/{id}
```
**Autenticación:** Requerida ✔️

---

### 3. Crear pedido
```
POST /api/pedidos
```
**Autenticación:** Requerida ✔️
**Request:**
```json
{
  "clienteId": 1,
  "estado": "PENDIENTE",
  "total": 99.99,
  "data": "2026-04-21"
}
```

---

### 4. Actualizar pedido
```
PUT /api/pedidos/{id}
```
**Autenticación:** Requerida ✔️

---

### 5. Eliminar pedido
```
DELETE /api/pedidos/{id}
```
**Autenticación:** Requerida ✔️

---

### 6. Crear Pedido Completo (Atómico)
```
POST /api/pedidos/crear-completo
```
**Descripción:** Crea un pedido con todos sus detalles en una sola transacción atómica. Valida automáticamente que el cliente y negocio existan, que hay stock suficiente, y calcula el total automáticamente.
**Autenticación:** Requerida ✔️
**Request:**
```json
{
  "clienteId": 2,
  "negocioId": 1,
  "detalles": [
    {
      "productoId": 1,
      "cantidad": 2
    },
    {
      "productoId": 3,
      "cantidad": 1
    }
  ]
}
```
**Response:**
```json
{
  "idPedido": 1,
  "clienteId": 2,
  "negocioId": 1,
  "total": 2029.97,
  "estado": "PENDIENTE",
  "detalles": [
    {
      "id": 1,
      "productoId": 1,
      "cantidade": 2,
      "prezoUnitario": 999.99
    }
  ]
}
```
**Errores:**
- `404 Not Found`: Cliente o negocio no encontrado
- `400 Bad Request`: Stock insuficiente o producto no encontrado
- `422 Unprocessable Entity`: Datos inválidos

---

### 7. Buscar Pedidos (Con Filtros y Paginación)
```
GET /api/pedidos/buscar?estado=PENDIENTE&fechaDesde=2024-01-01T00:00:00&fechaHasta=2024-12-31T23:59:59&precioDesde=0&precioHasta=1000&ordenar=fecha_desc&pagina=0&tamaño=10
```
**Descripción:** Busca pedidos con múltiples filtros opcionales, soporte a paginación y ordenamiento. Incluye rate limiting de 100 peticiones por minuto.
**Autenticación:** Requerida ✔️
**Query Parameters:**
- `estado` (opcional): PENDIENTE, CONFIRMADO, ENTREGADO, CANCELADO
- `fechaDesde` (opcional): Formato ISO-8601 (yyyy-MM-dd'T'HH:mm:ss)
- `fechaHasta` (opcional): Formato ISO-8601
- `precioDesde` (opcional): Precio mínimo
- `precioHasta` (opcional): Precio máximo
- `ordenar` (opcional): fecha_asc, fecha_desc, total_asc, total_desc (default: fecha_desc)
- `pagina` (optional, default: 0): Número de página
- `tamaño` (optional, default: 10): Elementos por página

**Response:**
```json
{
  "content": [
    {
      "id": 1,
      "clienteId": 2,
      "negocioId": 1,
      "total": 999.99,
      "estado": "ENTREGADO",
      "dataPedido": "2024-01-15T10:30:00"
    }
  ],
  "pageNumber": 0,
  "pageSize": 10,
  "totalElements": 45,
  "totalPages": 5,
  "last": false
}
```
**Errores:**
- `429 Too Many Requests`: Límite de rate limiting excedido (>100 peticiones/minuto)
- `400 Bad Request`: Filtros inválidos

---

## 📦 DETALLES DE PEDIDOS

### 1. Obtener todos los detalles
```
GET /api/detalles-pedidos
```
**Autenticación:** Requerida ✔️

---

### 2. Obtener detalle por ID
```
GET /api/detalles-pedidos/{id}
```
**Autenticación:** Requerida ✔️

---

### 3. Crear detalle de pedido
```
POST /api/detalles-pedidos
```
**Autenticación:** Requerida ✔️
**Request:**
```json
{
  "pedidoId": 1,
  "productoId": 1,
  "cantidade": 2,
  "prezoUnitario": 29.99
}
```

---

### 4. Actualizar detalle
```
PUT /api/detalles-pedidos/{id}
```
**Autenticación:** Requerida ✔️

---

### 5. Eliminar detalle
```
DELETE /api/detalles-pedidos/{id}
```
**Autenticación:** Requerida ✔️

---

## 🔄 COMPRAS RECURRENTES

### 1. Obtener todas las compras
```
GET /api/compras-recurrentes
```
**Autenticación:** Requerida ✔️

---

### 2. Obtener compra por ID
```
GET /api/compras-recurrentes/{id}
```
**Autenticación:** Requerida ✔️

---

### 3. Crear compra recurrente
```
POST /api/compras-recurrentes
```
**Autenticación:** Requerida ✔️
**Request:**
```json
{
  "clienteId": 1,
  "productoId": 1,
  "cantidade": 5,
  "frecuencia": "MENSUAL",
  "ativa": true
}
```

---

### 4. Actualizar compra recurrente
```
PUT /api/compras-recurrentes/{id}
```
**Autenticación:** Requerida ✔️

---

### 5. Eliminar compra recurrente
```
DELETE /api/compras-recurrentes/{id}
```
**Autenticación:** Requerida ✔️

---

## ⭐ VALORACIONES

### 1. Obtener todas las valoraciones
```
GET /api/valoraciones
```
**Autenticación:** Requerida ✔️

---

### 2. Obtener valoración por ID
```
GET /api/valoraciones/{id}
```
**Autenticación:** Requerida ✔️

---

### 3. Crear valoración
```
POST /api/valoraciones
```
**Autenticación:** Requerida ✔️
**Request:**
```json
{
  "usuarioId": 1,
  "productoId": 1,
  "puntuacion": 5,
  "comentario": "Excelente producto!",
  "data": "2026-04-21"
}
```

---

### 4. Actualizar valoración
```
PUT /api/valoraciones/{id}
```
**Autenticación:** Requerida ✔️

---

### 5. Eliminar valoración
```
DELETE /api/valoraciones/{id}
```
**Autenticación:** Requerida ✔️

---

## 👤 USUARIOS

### 1. Obtener todos los usuarios
```
GET /api/usuarios
```
**Autenticación:** Requerida ✔️

---

### 2. Obtener usuario por ID
```
GET /api/usuarios/{id}
```
**Autenticación:** Requerida ✔️

---

### 3. Crear usuario
```
POST /api/usuarios
```
**Autenticación:** Requerida ✔️
**Request:**
```json
{
  "nome": "Nuevo Usuario",
  "email": "nuevo@example.com",
  "contrasinal": "password123",
  "telefono": "+34 612 345 678",
  "tipoUsuario": "CLIENTE"
}
```

---

### 4. Actualizar usuario
```
PUT /api/usuarios/{id}
```
**Autenticación:** Requerida ✔️

---

### 5. Eliminar usuario
```
DELETE /api/usuarios/{id}
```
**Autenticación:** Requerida ✔️

---

## 🧪 TEST

### 1. Test Hola
```
GET /api/test/hola
```
**Descripción:** Endpoint de prueba que devuelve "Hola"
**Autenticación:** No requerida
**Response:**
```
"Hola"
```

---

## 📍 Headers Requeridos

### Para endpoints protegidos:
```
Authorization: Bearer {access_token}
Content-Type: application/json
```

---

## 🔄 Códigos de Respuesta

| Código | Significado |
|--------|-------------|
| 200 | OK - Solicitud exitosa |
| 201 | Created - Recurso creado exitosamente |
| 204 | No Content - Solicitud exitosa sin contenido |
| 400 | Bad Request - Error en los datos enviados |
| 401 | Unauthorized - Token inválido o expirado |
| 403 | Forbidden - No tienes permisos |
| 404 | Not Found - Recurso no encontrado |
| 409 | Conflict - Recurso duplicado |
| 500 | Internal Server Error - Error del servidor |

---

## 🚀 Flujo Recomendado

1. **POST /api/auth/login** - Obtener tokens
2. **GET /api/productos** - Listar productos
3. **POST /api/pedidos** - Crear nuevo pedido
4. **POST /api/detalles-pedidos** - Agregar productos al pedido
5. **GET /api/pedidos/{id}** - Verificar pedido

---

**Última actualización:** 21 de Abril de 2026  
**Versión:** 0.0.1-SNAPSHOT  
**Estado:** ✅ Todos los endpoints funcionales

