# Documentación de Endpoints API - PrazaShop

## Base URL
```
http://localhost:8080/api
```

## Autenticación
```
POST /api/auth/register
POST /api/auth/login
POST /api/auth/refresh-token
```

---

## 1. PRODUCTOS
**Base Path:** `/api/productos`

| Método | Endpoint | Descripción | Parámetros |
|--------|----------|-------------|-----------|
| GET | `/` | Obtiene todos los productos | - |
| GET | `/{id}` | Obtiene un producto por ID | `id`: Long |
| POST | `/` | Crea un nuevo producto | Body: ProductoDto |
| PUT | `/{id}` | Actualiza un producto | `id`: Long, Body: ProductoDto |
| DELETE | `/{id}` | Elimina un producto | `id`: Long |

**Ejemplo ProductoDto:**
```json
{
  "id": 1,
  "negocioId": 1,
  "nome": "Producto 1",
  "descricion": "Descripción del producto",
  "prezo": 29.99,
  "stock": 100,
  "categoria": "Electrónica",
  "duracionOferta": "7 días",
  "imaxe": "url_imagen",
  "estado": "ACTIVO"
}
```

---

## 2. CLIENTES
**Base Path:** `/api/clientes`

| Método | Endpoint | Descripción | Parámetros |
|--------|----------|-------------|-----------|
| GET | `/` | Obtiene todos los clientes | - |
| GET | `/{id}` | Obtiene un cliente por ID | `id`: Long |
| POST | `/` | Crea un nuevo cliente | Body: ClienteDto |
| PUT | `/{id}` | Actualiza un cliente | `id`: Long, Body: ClienteDto |
| DELETE | `/{id}` | Elimina un cliente | `id`: Long |

---

## 3. NEGOCIOS
**Base Path:** `/api/negocios`

| Método | Endpoint | Descripción | Parámetros |
|--------|----------|-------------|-----------|
| GET | `/` | Obtiene todos los negocios | - |
| GET | `/{id}` | Obtiene un negocio por ID | `id`: Long |
| POST | `/` | Crea un nuevo negocio | Body: NegocioDto |
| PUT | `/{id}` | Actualiza un negocio | `id`: Long, Body: NegocioDto |
| DELETE | `/{id}` | Elimina un negocio | `id`: Long |

---

## 4. PEDIDOS
**Base Path:** `/api/pedidos`

| Método | Endpoint | Descripción | Parámetros |
|--------|----------|-------------|-----------|
| GET | `/` | Obtiene todos los pedidos | - |
| GET | `/{id}` | Obtiene un pedido por ID | `id`: Long |
| POST | `/` | Crea un nuevo pedido | Body: PedidoDto |
| PUT | `/{id}` | Actualiza un pedido | `id`: Long, Body: PedidoDto |
| DELETE | `/{id}` | Elimina un pedido | `id`: Long |

---

## 5. DETALLES DE PEDIDOS
**Base Path:** `/api/detalles-pedidos`

| Método | Endpoint | Descripción | Parámetros |
|--------|----------|-------------|-----------|
| GET | `/` | Obtiene todos los detalles | - |
| GET | `/{id}` | Obtiene un detalle por ID | `id`: Long |
| POST | `/` | Crea un nuevo detalle | Body: DetallePedidoDto |
| PUT | `/{id}` | Actualiza un detalle | `id`: Long, Body: DetallePedidoDto |
| DELETE | `/{id}` | Elimina un detalle | `id`: Long |

---

## 6. COMPRAS RECURRENTES
**Base Path:** `/api/compras-recurrentes`

| Método | Endpoint | Descripción | Parámetros |
|--------|----------|-------------|-----------|
| GET | `/` | Obtiene todas las compras recurrentes | - |
| GET | `/{id}` | Obtiene una compra recurrente por ID | `id`: Long |
| POST | `/` | Crea una nueva compra recurrente | Body: CompraRecorrenteDto |
| PUT | `/{id}` | Actualiza una compra recurrente | `id`: Long, Body: CompraRecorrenteDto |
| DELETE | `/{id}` | Elimina una compra recurrente | `id`: Long |

---

## 7. VALORACIONES
**Base Path:** `/api/valoraciones`

| Método | Endpoint | Descripción | Parámetros |
|--------|----------|-------------|-----------|
| GET | `/` | Obtiene todas las valoraciones | - |
| GET | `/{id}` | Obtiene una valoración por ID | `id`: Long |
| POST | `/` | Crea una nueva valoración | Body: ValoracionDto |
| PUT | `/{id}` | Actualiza una valoración | `id`: Long, Body: ValoracionDto |
| DELETE | `/{id}` | Elimina una valoración | `id`: Long |

---

## 8. USUARIOS
**Base Path:** `/api/usuarios`

| Método | Endpoint | Descripción | Parámetros |
|--------|----------|-------------|-----------|
| GET | `/` | Obtiene todos los usuarios | - |
| GET | `/{id}` | Obtiene un usuario por ID | `id`: Long |
| POST | `/` | Crea un nuevo usuario | Body: UsuarioDto |
| PUT | `/{id}` | Actualiza un usuario | `id`: Long, Body: UsuarioDto |
| DELETE | `/{id}` | Elimina un usuario | `id`: Long |

---

## Códigos de Estado HTTP

| Código | Significado |
|--------|------------|
| 200 | OK - Solicitud exitosa |
| 201 | Created - Recurso creado exitosamente |
| 204 | No Content - Elimación exitosa |
| 400 | Bad Request - Datos inválidos |
| 401 | Unauthorized - No autenticado |
| 403 | Forbidden - No autorizado |
| 404 | Not Found - Recurso no encontrado |
| 409 | Conflict - Violación de restricción única |
| 500 | Internal Server Error - Error del servidor |

---

## Ejemplo de Peticiones con cURL

### GET - Obtener todos los productos
```bash
curl -X GET "http://localhost:8080/api/productos" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### POST - Crear un nuevo producto
```bash
curl -X POST "http://localhost:8080/api/productos" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "negocioId": 1,
    "nome": "Nuevo Producto",
    "descricion": "Descripción",
    "prezo": 19.99,
    "stock": 50,
    "categoria": "Categoría",
    "duracionOferta": "7 días",
    "imaxe": "url",
    "estado": "ACTIVO"
  }'
```

### PUT - Actualizar un producto
```bash
curl -X PUT "http://localhost:8080/api/productos/1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "negocioId": 1,
    "nome": "Producto Actualizado",
    "prezo": 29.99,
    "stock": 75,
    "categoria": "Categoría",
    "estado": "ACTIVO"
  }'
```

### DELETE - Eliminar un producto
```bash
curl -X DELETE "http://localhost:8080/api/productos/1" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## Notas Importantes

- **Autenticación:** La mayoría de endpoints requieren un JWT token válido en el header `Authorization: Bearer <token>`
- **CORS:** Los controladores tienen CORS habilitado para todas las orígenes
- **Validación:** Los DTOs incluyen validación automática
- **Excepciones:** Se manejan automáticamente y retornan mensajes de error apropiados


