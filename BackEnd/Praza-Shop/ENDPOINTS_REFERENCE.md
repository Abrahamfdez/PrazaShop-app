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
| 🛒 Endpoints User-Scoped | 12 | ✅ Funcionales |
| 🧪 Test | 1 | ✅ Funcional |

**Total: 61 Endpoints Funcionales **

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

## 🛒 ENDPOINTS USER-SCOPED (FASE 3) - Autodetección de Contexto de Usuario

**Descripción:** Estos endpoints utilizan el SecurityContext para autodetectar automáticamente el usuarioId, clienteId y negocioId del usuario autenticado. Eliminan la necesidad de pasar estos IDs en la request, centralizando la lógica de autorización en el backend.

---

### 1. Crear Pedido como Cliente
```
POST /api/mi-compra/pedidos
```
**Descripción:** Crea un nuevo pedido con detalles en una transacción atómica. El clienteId se detecta automáticamente del token del usuario autenticado.
**Autenticación:** Requerida ✔️ (Usuario tipo CLIENTE)
**Request:**
```json
{
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
  "idPedido": 15,
  "clienteId": 2,
  "negocioId": 1,
  "total": 2029.97,
  "estado": "PENDIENTE",
  "dataPedido": "2026-05-20T14:30:00",
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
- `401 Unauthorized`: Token inválido o expirado
- `403 Forbidden`: Usuario no tiene rol CLIENTE
- `404 Not Found`: Negocio o producto no encontrado
- `400 Bad Request`: Stock insuficiente

---

### 2. Obtener Mis Pedidos (Cliente)
```
GET /api/mi-compra/pedidos?pagina=0&tamano=10
```
**Descripción:** Obtiene todos los pedidos del cliente autenticado con paginación. El clienteId se detecta automáticamente.
**Autenticación:** Requerida ✔️ (Usuario tipo CLIENTE)
**Query Parameters:**
- `pagina` (optional, default: 0): Número de página
- `tamano` (optional, default: 10): Elementos por página

**Response:**
```json
{
  "content": [
    {
      "id": 15,
      "clienteId": 2,
      "negocioId": 1,
      "total": 2029.97,
      "estado": "PENDIENTE",
      "dataPedido": "2026-05-20T14:30:00"
    },
    {
      "id": 14,
      "clienteId": 2,
      "negocioId": 1,
      "total": 999.99,
      "estado": "ENTREGADO",
      "dataPedido": "2026-05-18T10:15:00"
    }
  ],
  "pageNumber": 0,
  "pageSize": 10,
  "totalElements": 12,
  "totalPages": 2,
  "last": false
}
```

---

### 3. Obtener Mis Productos (Negocio)
```
GET /api/mi-negocio/productos?pagina=0&tamano=10
```
**Descripción:** Obtiene todos los productos del negocio del usuario autenticado con paginación. El negocioId se detecta automáticamente.
**Autenticación:** Requerida ✔️ (Usuario tipo NEGOCIO)
**Query Parameters:**
- `pagina` (optional, default: 0): Número de página
- `tamano` (optional, default: 10): Elementos por página

**Response:**
```json
{
  "content": [
    {
      "id": 1,
      "nome": "Laptop Gaming",
      "descricion": "Laptop potente para gaming",
      "prezo": 999.99,
      "stock": 10,
      "categoria": "Electrónica",
      "negocioId": 1
    },
    {
      "id": 3,
      "nome": "Mouse Inalámbrico",
      "descricion": "Mouse gamer con RGB",
      "prezo": 29.99,
      "stock": 50,
      "categoria": "Accesorios",
      "negocioId": 1
    }
  ],
  "pageNumber": 0,
  "pageSize": 10,
  "totalElements": 8,
  "totalPages": 1,
  "last": true
}
```

---

### 4. Crear Producto en Mi Negocio
```
POST /api/mi-negocio/productos
```
**Descripción:** Crea un nuevo producto en el negocio del usuario autenticado. El negocioId se detecta automáticamente.
**Autenticación:** Requerida ✔️ (Usuario tipo NEGOCIO)
**Request:**
```json
{
  "nome": "Teclado Mecánico",
  "descricion": "Teclado mecánico RGB profesional",
  "prezo": 149.99,
  "stock": 25,
  "categoria": "Accesorios",
  "imaxe": "https://example.com/teclado.jpg"
}
```
**Response:**
```json
{
  "id": 10,
  "nome": "Teclado Mecánico",
  "descricion": "Teclado mecánico RGB profesional",
  "prezo": 149.99,
  "stock": 25,
  "categoria": "Accesorios",
  "negocioId": 1,
  "imaxe": "https://example.com/teclado.jpg"
}
```

---

### 5. Actualizar Producto en Mi Negocio
```
PUT /api/mi-negocio/productos/{id}
```
**Descripción:** Actualiza un producto del negocio autenticado. Verifica automáticamente que el producto pertenece al negocio del usuario.
**Autenticación:** Requerida ✔️ (Usuario tipo NEGOCIO)
**Parámetros:** `id` (Long - ID del producto)
**Request:**
```json
{
  "nome": "Teclado Mecánico RGB",
  "descricion": "Teclado mecánico RGB con interruptores Cherry MX",
  "prezo": 159.99,
  "stock": 20,
  "categoria": "Accesorios",
  "imaxe": "https://example.com/teclado-rgb.jpg"
}
```
**Errores:**
- `403 Forbidden`: El producto no pertenece a tu negocio
- `404 Not Found`: Producto no encontrado

---

### 6. Eliminar Producto de Mi Negocio
```
DELETE /api/mi-negocio/productos/{id}
```
**Descripción:** Elimina un producto del negocio autenticado. Verifica automáticamente que el producto pertenece al negocio del usuario.
**Autenticación:** Requerida ✔️ (Usuario tipo NEGOCIO)
**Parámetros:** `id` (Long - ID del producto)
**Errores:**
- `403 Forbidden`: El producto no pertenece a tu negocio
- `404 Not Found`: Producto no encontrado

---

### 7. Obtener Mis Ventas (Negocio)
```
GET /api/mi-negocio/ventas?pagina=0&tamano=10
```
**Descripción:** Obtiene todos los pedidos (ventas) del negocio del usuario autenticado con paginación. El negocioId se detecta automáticamente.
**Autenticación:** Requerida ✔️ (Usuario tipo NEGOCIO)
**Query Parameters:**
- `pagina` (optional, default: 0): Número de página
- `tamano` (optional, default: 10): Elementos por página

**Response:**
```json
{
  "content": [
    {
      "id": 15,
      "clienteId": 2,
      "negocioId": 1,
      "total": 2029.97,
      "estado": "CONFIRMADO",
      "dataPedido": "2026-05-20T14:30:00"
    },
    {
      "id": 12,
      "clienteId": 5,
      "negocioId": 1,
      "total": 299.97,
      "estado": "ENTREGADO",
      "dataPedido": "2026-05-19T09:45:00"
    }
  ],
  "pageNumber": 0,
  "pageSize": 10,
  "totalElements": 24,
  "totalPages": 3,
  "last": false
}
```

---

### 8. Actualizar Estado de Venta (Pedido)
```
PUT /api/mi-negocio/ventas/{id}/estado
```
**Descripción:** Actualiza el estado de un pedido (venta) del negocio autenticado. Valida y ejecuta la transición de estado con manejo de stock. Verifica automáticamente que el pedido pertenece al negocio del usuario.
**Autenticación:** Requerida ✔️ (Usuario tipo NEGOCIO)
**Parámetros:** `id` (Long - ID del pedido)
**Request:**
```json
{
  "nuevoEstado": "CONFIRMADO"
}
```
**Estados válidos:**
- `PENDIENTE` → `CONFIRMADO` (Decrementa stock)
- `CONFIRMADO` → `ENTREGADO` (No afecta stock)
- `CONFIRMADO` → `CANCELADO` (Restaura stock)
- `PENDIENTE` → `CANCELADO` (No afecta stock, solo reserva)

**Response:**
```json
{
  "id": 15,
  "clienteId": 2,
  "negocioId": 1,
  "total": 2029.97,
  "estado": "CONFIRMADO",
  "dataPedido": "2026-05-20T14:30:00"
}
```
**Errores:**
- `403 Forbidden`: El pedido no pertenece a tu negocio
- `404 Not Found`: Pedido no encontrado
- `400 Bad Request`: Transición de estado no válida

---

### 9. Actualizar Múltiples Pedidos en Lote (Masa)
```
PUT /api/mi-negocio/ventas/actualizar-estado-lote
```
**Descripción:** Actualiza el estado de múltiples pedidos simultáneamente. Útil para cambiar varios pedidos a ENTREGADO o CANCELADO en una sola operación. Solo afecta pedidos que pertenecen al negocio autenticado.
**Autenticación:** Requerida ✔️ (Usuario tipo NEGOCIO)
**Request:**
```json
{
  "pedidoIds": [15, 12, 10],
  "nuevoEstado": "ENTREGADO"
}
```
**Response:**
```json
{
  "exitosos": [
    {
      "id": 15,
      "estado": "ENTREGADO"
    },
    {
      "id": 12,
      "estado": "ENTREGADO"
    }
  ],
  "errores": [
    {
      "id": 10,
      "razon": "No pertenece a tu negocio"
    }
  ]
}
```

---

### 10. Obtener Mis Compras Recurrentes (Cliente)
```
GET /api/mis-compras-recurrentes
```
**Descripción:** Obtiene todas las compras recurrentes del cliente autenticado. El clienteId se detecta automáticamente del token del usuario.
**Autenticación:** Requerida ✔️ (Usuario tipo CLIENTE)

**Response:**
```json
[
  {
    "id": 1,
    "clienteId": 2,
    "productoId": 5,
    "cantidade": 3,
    "frecuencia": "MENSUAL",
    "dataInicio": "2026-05-21",
    "estado": "ACTIVO"
  },
  {
    "id": 2,
    "clienteId": 2,
    "productoId": 8,
    "cantidade": 2,
    "frecuencia": "SEMANAL",
    "dataInicio": "2026-05-21",
    "estado": "ACTIVO"
  }
]
```
**Errores:**
- `401 Unauthorized`: Token inválido o expirado
- `403 Forbidden`: Usuario no tiene rol CLIENTE

---

### 11. Crear Nueva Compra Recurrente (Cliente)
```
POST /api/mis-compras-recurrentes
```
**Descripción:** Crea una nueva compra recurrente para el cliente autenticado. El clienteId se detecta automáticamente del token del usuario.
**Autenticación:** Requerida ✔️ (Usuario tipo CLIENTE)
**Request:**
```json
{
  "productoId": 5,
  "cantidade": 3,
  "frecuencia": "MENSUAL",
  "dataInicio": "2026-05-21"
}
```
**Response:**
```json
{
  "id": 3,
  "clienteId": 2,
  "productoId": 5,
  "cantidade": 3,
  "frecuencia": "MENSUAL",
  "dataInicio": "2026-05-21",
  "estado": "ACTIVO"
}
```
**Errores:**
- `400 Bad Request`: Datos inválidos (cantidad <= 0, frecuencia no válida, fecha pasada)
- `401 Unauthorized`: Token inválido o expirado
- `403 Forbidden`: Usuario no tiene rol CLIENTE
- `404 Not Found`: Producto no encontrado
- `409 Conflict`: Ya existe una compra recurrente activa para este producto

---

### 12. Obtener Compras Recurrentes del Negocio (Vendedor)
```
GET /api/mi-negocio/compras-recurrentes
```
**Descripción:** Obtiene todas las compras recurrentes de los productos del negocio autenticado. El negocioId se detecta automáticamente del token del usuario. Muestra las suscripciones activas que tienen los clientes a los productos del negocio.
**Autenticación:** Requerida ✔️ (Usuario tipo NEGOCIO)

**Response:**
```json
[
  {
    "id": 1,
    "clienteId": 2,
    "productoId": 5,
    "cantidade": 3,
    "frecuencia": "MENSUAL",
    "dataInicio": "2026-05-21",
    "estado": "ACTIVO"
  },
  {
    "id": 2,
    "clienteId": 3,
    "productoId": 8,
    "cantidade": 2,
    "frecuencia": "SEMANAL",
    "dataInicio": "2026-05-20",
    "estado": "ACTIVO"
  }
]
```
**Errores:**
- `401 Unauthorized`: Token inválido o expirado
- `403 Forbidden`: Usuario no tiene rol NEGOCIO

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

**Última actualización:** 25 de Mayo de 2026 (Fase 3++: Panel de compras recurrentes para negocio)  
**Versión:** 0.0.2-SNAPSHOT (Fase 3++)  
**Estado:** ✅ 61 endpoints totales funcionales (incl. 12 user-scoped: 2 nuevos para panel de compras recurrentes)

