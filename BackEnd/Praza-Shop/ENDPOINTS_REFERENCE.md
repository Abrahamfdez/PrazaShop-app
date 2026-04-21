# 🎯 Resumen Completo de Endpoints - PrazaShop API

## 📊 Tabla de Contenidos

| Sección | Endpoints | Estado |
|---------|-----------|--------|
| 🔐 Autenticación | 3 | ✅ Funcionales |
| 📦 Productos | 5 | ✅ Funcionales |
| 👥 Clientes | 5 | ✅ Funcionales |
| 🏢 Negocios | 5 | ✅ Funcionales |
| 📋 Pedidos | 5 | ✅ Funcionales |
| 📦 Detalles Pedidos | 5 | ✅ Funcionales |
| 🔄 Compras Recurrentes | 5 | ✅ Funcionales |
| ⭐ Valoraciones | 5 | ✅ Funcionales |
| 👤 Usuarios | 5 | ✅ Funcionales |
| 🧪 Test | 1 | ✅ Funcional |

**Total: 44 Endpoints Funcionales**

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

