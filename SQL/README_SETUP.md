# 🗄️ Script de Creación de Base de Datos - PrazaShop

## 📁 Archivo
`SQL/SETUP_PRAZASHOP_COMPLETE.sql`

Este script contiene:
- ✅ Creación de BD con charset UTF-8mb4
- ✅ 11 tablas con índices y constraints
- ✅ Datos de prueba (usuarios, productos, pedidos)
- ✅ Comentarios de conexión

---

## 🚀 Ejecución Rápida

### Opción 1: Desde Línea de Comandos (Recomendado)

**Windows (PowerShell)**
```powershell
# Conectarse a MySQL (sustituir "tu_contraseña" por tu contraseña)
mysql -u root -p tu_contraseña

# Ejecutar el script completo
SOURCE C:\Users\abraham.fernandezban\Desktop\TFG\PrazaShop-app\SQL\SETUP_PRAZASHOP_COMPLETE.sql;

# O en una sola línea (sin entrar a MySQL)
mysql -u root -p tu_contraseña < "C:\Users\abraham.fernandezban\Desktop\TFG\PrazaShop-app\SQL\SETUP_PRAZASHOP_COMPLETE.sql"
```

**macOS/Linux**
```bash
# Ejecutar el script
mysql -u root -p < /ruta/a/SETUP_PRAZASHOP_COMPLETE.sql

# O especificar contraseña
mysql -u root -p'tu_contraseña' < /ruta/a/SETUP_PRAZASHOP_COMPLETE.sql
```

---

### Opción 2: Desde Cliente MySQL Workbench

1. Abre **MySQL Workbench**
2. Conexión a tu servidor local
3. **File → Open SQL Script** → selecciona `SETUP_PRAZASHOP_COMPLETE.sql`
4. Click en ⚡ **Execute**

---

### Opción 3: Desde PhpMyAdmin

1. Abre **http://localhost/phpmyadmin**
2. Panel superior → **Import**
3. Selecciona el archivo `SETUP_PRAZASHOP_COMPLETE.sql`
4. Click **Go**

---

## ✅ Verificación de Éxito

Después de ejecutar, deberías ver:

```
=== PRAZASHOP DATABASE SETUP COMPLETO ===
Usuarios creados: 3
Clientes registrados: 2
Negocios activos: 1
Productos disponibles: 6
Pedidos totales: 2
Valoraciones: 2

=== USUARIOS ===
1 | Juan Cliente | cliente@test.com | CLIENTE
2 | María Negocio | negocio@test.com | NEGOCIO
3 | Admin Sistema | admin@test.com | ADMIN

=== PRODUCTOS ===
1 | Froitas de Temporada | Froitas | 2.50 | 50 | ACTIVO
2 | Verduras Verdes | Verduras | 1.80 | 75 | ACTIVO
3 | Carne de Ternera | Carne/Meats | 12.50 | 20 | ACTIVO
4 | Pan Integral | Panadería | 3.20 | 30 | ACTIVO
5 | Leche Fresca | Lácteos | 1.50 | 100 | ACTIVO
6 | Peixe do Día | Peixe | 8.99 | 15 | ACTIVO
```

---

## 🧪 Datos de Prueba Incluidos

### Usuarios
| Email | Contraseña | Tipo |
|-------|-----------|------|
| cliente@test.com | password123 | CLIENTE |
| negocio@test.com | password123 | NEGOCIO |
| admin@test.com | password123 | ADMIN |

### Negocio
- **Nombre**: Verduras Frescas del Campo
- **Dirección**: Rúa do Comercio 789, Santiago
- **Productos**: 6 disponibles

### Productos
1. Froitas de Temporada - €2.50
2. Verduras Verdes - €1.80
3. Carne de Ternera - €12.50
4. Pan Integral - €3.20
5. Leche Fresca - €1.50
6. Peixe do Día - €8.99

### Pedidos de Prueba
- **Pedido #1**: PENDIENTE - €15.30 (2x Froitas + 3x Verduras + 2x Leche)
- **Pedido #2**: CONFIRMADO - €24.99 (2x Carne + 1x Pan)

---

## 🔧 Opciones Avanzadas

### Crear BD sin Datos de Prueba

Si solo quieres la estructura:

```sql
-- Abre SETUP_PRAZASHOP_COMPLETE.sql
-- Comenta/borra las secciones:
-- - INSERTAR DATOS DE PRUEBA
-- - MOSTRAR ESTADÍSTICAS
-- Ejecuta solo hasta la línea de definición de tablas
```

O usa el archivo original:
```bash
mysql -u root -p < CREACION_TABLAS_PRAZASHOP.sql
```

---

### Limpiar y Recrear

```sql
-- Si necesitas empezar de cero
DROP DATABASE IF EXISTS prazashop;

-- Luego ejecuta el script nuevamente
SOURCE SETUP_PRAZASHOP_COMPLETE.sql;
```

---

### Respaldar Base de Datos

```bash
# Backup completo
mysqldump -u root -p prazashop > backup_prazashop.sql

# Restaurar desde backup
mysql -u root -p prazashop < backup_prazashop.sql
```

---

## 📊 Estructura de Tablas

```
usuario (id_usuario)
├── cliente (id_usuario FK)
├── negocio (id_usuario FK)
└── token (id_usuario FK)

negocio (id_negocio)
├── producto (id_negocio FK)
└── valoracion (id_negocio FK)

producto (id_producto)
├── detalle_pedido (id_producto FK)
├── compra_recorrente (id_producto FK)
└── stock_movimiento (id_producto FK)

cliente (id_cliente)
├── pedido (id_cliente FK)
├── compra_recorrente (id_cliente FK)
└── valoracion (id_cliente FK)

pedido (id_pedido)
├── detalle_pedido (id_pedido FK)
└── stock_movimiento (id_pedido FK)
```

---

## ⚠️ Solución de Problemas

### Error: "Access denied for user 'root'"

```bash
# Ejecutar sin contraseña
mysql -u root < SETUP_PRAZASHOP_COMPLETE.sql

# O especificar usuario diferente
mysql -u prazashop_user -p < SETUP_PRAZASHOP_COMPLETE.sql
```

### Error: "MySQL command not found"

```bash
# Agregar MySQL al PATH (Windows)
$env:Path += ";C:\Program Files\MySQL\MySQL Server 8.0\bin"

# O ejecutar desde carpeta de MySQL
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p < script.sql
```

### Error: "File not found"

```bash
# Verificar ruta correcta
cd "C:\Users\abraham.fernandezban\Desktop\TFG\PrazaShop-app\SQL"
ls  # Para ver archivos disponibles

# Ejecutar desde esa carpeta
mysql -u root -p < SETUP_PRAZASHOP_COMPLETE.sql
```

### Caracteres extraños en datos

Si ves `PanaderÃ­a` en lugar de `Panadería`:

```sql
-- Reiniciar MySQL con charset correcto
-- En application.yml del backend:
datasource:
  url: jdbc:mysql://localhost:3306/prazashop?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8

-- O ejecutar en MySQL:
ALTER DATABASE prazashop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE producto CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

---

## 📝 Notas Importantes

✅ **Charset**: UTF-8mb4 - soporta todos los caracteres y acentos gallegos  
✅ **Índices**: Agregados en columnas clave para mejor performance  
✅ **Foreign Keys**: Con CASCADE para integridad referencial  
✅ **Timestamps**: Campos `created_at` y `updated_at` automáticos  
✅ **Validaciones**: CHECK constraints en campos como puntuación  
✅ **Datos de Prueba**: Incluidos para testing inmediato  

---

**Versión**: 1.0  
**Última actualización**: Mayo 2026  
**Estado**: Listo para producción
