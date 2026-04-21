# 📚 Guía de Uso - Colección Postman PrazaShop API

## 📥 Instalación de la Colección

1. **Abre Postman**
2. **Importa la colección:**
   - Click en **"Import"** (arriba a la izquierda)
   - Selecciona el archivo: `PrazaShop-API-Complete.postman_collection.json`
   - Click en **"Import"**

## ⚙️ Configuración del Entorno

### Variables de Entorno

La colección utiliza dos variables de entorno que se configuran automáticamente:

- `{{access_token}}` - Token JWT de acceso (se obtiene al hacer login)
- `{{refresh_token}}` - Token para renovar el acceso

Estas se guardan automáticamente cuando ejecutas los endpoints de autenticación.

## 🚀 Flujo de Uso Recomendado

### 1️⃣ Autenticación (Primero - Obligatorio)

**Opción A: Login**
```
POST /api/auth/login
Body:
{
  "email": "a@admin.es",
  "contrasinal": "admin"
}
```

**Opción B: Registro**
```
POST /api/auth/register
Body:
{
  "nome": "Tu Nombre",
  "email": "tu.email@example.com",
  "contrasinal": "password123",
  "telefono": "+34 612 345 678",
  "tipoUsuario": "CLIENTE"
}
```

✅ Los tokens se guardan automáticamente en las variables de entorno.

---

### 2️⃣ Trabajar con Recursos

Una vez autenticado, puedes acceder a cualquier endpoint:

#### **Productos**
- `GET /api/productos` - Obtener todos
- `GET /api/productos/{id}` - Obtener por ID
- `POST /api/productos` - Crear
- `PUT /api/productos/{id}` - Actualizar
- `DELETE /api/productos/{id}` - Eliminar

#### **Clientes**
- `GET /api/clientes` - Obtener todos
- `GET /api/clientes/{id}` - Obtener por ID
- `POST /api/clientes` - Crear
- `PUT /api/clientes/{id}` - Actualizar
- `DELETE /api/clientes/{id}` - Eliminar

#### **Negocios**
- `GET /api/negocios` - Obtener todos
- `GET /api/negocios/{id}` - Obtener por ID
- `POST /api/negocios` - Crear
- `PUT /api/negocios/{id}` - Actualizar
- `DELETE /api/negocios/{id}` - Eliminar

#### **Pedidos**
- `GET /api/pedidos` - Obtener todos
- `GET /api/pedidos/{id}` - Obtener por ID
- `POST /api/pedidos` - Crear
- `PUT /api/pedidos/{id}` - Actualizar
- `DELETE /api/pedidos/{id}` - Eliminar

#### **Detalles de Pedidos**
- `GET /api/detalles-pedidos` - Obtener todos
- `GET /api/detalles-pedidos/{id}` - Obtener por ID
- `POST /api/detalles-pedidos` - Crear
- `PUT /api/detalles-pedidos/{id}` - Actualizar
- `DELETE /api/detalles-pedidos/{id}` - Eliminar

#### **Compras Recurrentes**
- `GET /api/compras-recurrentes` - Obtener todas
- `GET /api/compras-recurrentes/{id}` - Obtener por ID
- `POST /api/compras-recurrentes` - Crear
- `PUT /api/compras-recurrentes/{id}` - Actualizar
- `DELETE /api/compras-recurrentes/{id}` - Eliminar

#### **Valoraciones**
- `GET /api/valoraciones` - Obtener todas
- `GET /api/valoraciones/{id}` - Obtener por ID
- `POST /api/valoraciones` - Crear
- `PUT /api/valoraciones/{id}` - Actualizar
- `DELETE /api/valoraciones/{id}` - Eliminar

#### **Usuarios**
- `GET /api/usuarios` - Obtener todos
- `GET /api/usuarios/{id}` - Obtener por ID
- `POST /api/usuarios` - Crear
- `PUT /api/usuarios/{id}` - Actualizar
- `DELETE /api/usuarios/{id}` - Eliminar

---

## 🔑 Autenticación

### ¿Cómo funcionan los Tokens?

1. **Access Token:** Se utiliza para acceder a los endpoints protegidos
   - Válido por: 900,000 ms (15 minutos)
   - Se incluye en cada solicitud: `Authorization: Bearer {access_token}`

2. **Refresh Token:** Se utiliza para obtener un nuevo access token
   - Válido por: 2,592,000,000 ms (30 días)
   - Uso: `POST /api/auth/refresh`

### Refrescar Token Expirado

```
POST /api/auth/refresh
Body:
{
  "refreshToken": "{{refresh_token}}"
}
```

---

## 📝 Ejemplos de Solicitudes

### Crear un Producto

```json
POST /api/productos
Authorization: Bearer {{access_token}}
Content-Type: application/json

{
  "negocioId": 1,
  "nome": "Laptop Dell XPS",
  "descricion": "Laptop ultraportátil de última generación",
  "prezo": 1299.99,
  "stock": 10,
  "categoria": "Electrónica",
  "imaxe": "https://via.placeholder.com/300"
}
```

### Crear un Pedido

```json
POST /api/pedidos
Authorization: Bearer {{access_token}}
Content-Type: application/json

{
  "clienteId": 1,
  "estado": "PENDIENTE",
  "total": 99.99,
  "data": "2026-04-21"
}
```

### Crear un Detalle de Pedido

```json
POST /api/detalles-pedidos
Authorization: Bearer {{access_token}}
Content-Type: application/json

{
  "pedidoId": 1,
  "productoId": 1,
  "cantidade": 2,
  "prezoUnitario": 29.99
}
```

---

## 🐛 Solución de Problemas

### ❌ Error: "401 Unauthorized"
**Causa:** Token expirado o no configurado
**Solución:** Ejecuta primero el endpoint de Login para obtener un nuevo token

### ❌ Error: "403 Forbidden"
**Causa:** No tienes permisos para acceder a este recurso
**Solución:** Verifica tu rol de usuario (CLIENTE, VENDEDOR, ADMIN)

### ❌ Error: "404 Not Found"
**Causa:** El ID del recurso no existe
**Solución:** Verifica que el ID sea válido

### ❌ Error: "400 Bad Request"
**Causa:** Datos inválidos en el body
**Solución:** Revisa la estructura del JSON y los tipos de datos

---

## 📌 Notas Importantes

- ⚠️ **Todos los endpoints excepto Login y Register requieren autenticación**
- ⚠️ **El token se incluye automáticamente en todas las solicitudes**
- ⚠️ **Los IDs en los ejemplos (1, 2, 3...) son de ejemplo - reemplaza con IDs reales**
- ⚠️ **Algunas operaciones pueden tener restricciones de permisos según el rol del usuario**

---

## 🔗 Recursos Útiles

- **Documentación Swagger:** http://localhost:8080/swagger-ui.html
- **OpenAPI Spec:** http://localhost:8080/v3/api-docs

---

**Última actualización:** 21 de Abril de 2026
**Versión API:** 0.0.1-SNAPSHOT

