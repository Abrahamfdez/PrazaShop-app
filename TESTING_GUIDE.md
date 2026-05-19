# 🧪 Quick Testing Guide - PrazaShop Integration

## 📱 Testing Flutter en Local

### Paso 1: Preparar el Entorno

```bash
# Ir al directorio Flutter
cd FrontEnd/praza_shop

# Limpiar cache
flutter clean

# Obtener dependencias
flutter pub get

# Analizar código (buscar errores)
flutter analyze
```

**Resultado esperado:** 0 errores de análisis

---

### Paso 2: Ejecutar en Emulador

```bash
# Iniciar emulador (o conectar dispositivo)
flutter emulators --launch emulator-5554

# O en iOS
open -a Simulator

# Ejecutar app
flutter run
```

**Verificar:** La app inicia sin crashes

---

## 🎯 Testing Manual de Pantallas

### 1️⃣ Dashboard (negocio_panel_page.dart)

**Ubicación en app:** Menu → Panel de Negocio

**Test Cases:**
```
1. Abrir dashboard como vendedor
   ✓ Debe cargar en ~200ms (no 800ms)
   ✓ Debe mostrar: negocio, productos, pedidos recientes, stats
   ✓ No debe hacer 4 llamadas separadas (solo 1)

2. Verificar datos correctos
   ✓ Nombre del negocio visible
   ✓ Últimos 10 productos listados
   ✓ Últimos pedidos recientes
   ✓ Rating promedio visible
   ✓ Total de ventas correcto

3. Monitorear red (DevTools)
   - Abrir DevTools → Network tab
   - Solo debe ver 1 petición GET a /api/negocios/{id}/dashboard
   - No debe ver peticiones a getByUsuarioId, getByNegocioId, etc.
```

**Debug Command:**
```dart
// En terminal Flutter:
dart run integration_test/app_test.dart --target=test/integration_test/dashboard_test.dart
```

---

### 2️⃣ Detalle de Producto (producto_detail_page.dart)

**Ubicación en app:** Buscar producto → Tap en producto

**Test Cases:**
```
1. Abrir detalle de producto
   ✓ Debe mostrar foto, nombre, precio
   ✓ Debe mostrar info del negocio (nombre, descripción)
   ✓ Debe mostrar rating y cantidad de valoraciones
   ✓ Debe cargar en ~200ms

2. Verificar estructura de datos
   ✓ detalles['producto'] tiene info del producto
   ✓ detalles['negocio'] tiene info del vendedor
   ✓ detalles['stats'] tiene rating y count

3. Probar fallback
   - Desactivar endpoint nuevo en backend
   - La app debe seguir funcionando (usando método antiguo)
```

**Check Logs:**
```
flutter logs | grep "producto_detail"
// Debe mostrar "Detalles cargados" pero NO errores
```

---

### 3️⃣ Checkout (comprar_page.dart)

**Ubicación en app:** Producto → Comprar → Confirmar Compra

**Test Cases:**
```
1. Flujo de compra exitoso
   ✓ Seleccionar cantidad
   ✓ Tap en "Confirmar"
   ✓ Esperar ~250ms
   ✓ Mostrar mensaje de éxito
   ✓ Navegar a pantalla de valoración

2. Verificar transacción atómica
   - En backend, monitorear base de datos
   - Debe haber 1 Pedido + N DetallesPedido creados
   - Nunca debe quedar Pedido sin Detalles

3. Probar error por stock insuficiente
   ✓ Modificar cantidad > stock
   ✓ Debe mostrar error 400
   ✓ No debe crear pedido

4. Verificar total
   ✓ Total mostrado = cantidad * precio (calculado backend)
   ✓ No debe permitir manipulación del total
```

**Monitor en DevTools:**
```
flutter run --profile  // Para mejor rendimiento
```

---

### 4️⃣ Historial de Pedidos (cliente_pedidos_page.dart)

**Ubicación en app:** Menu → Mis Pedidos

**Test Cases:**
```
1. Cargar pedidos iniciales
   ✓ Pagina 0, tamaño 100
   ✓ Ordenado por fecha DESC (más recientes primero)
   ✓ Debe mostrar lista de pedidos

2. Verificar estructura paginada
   {
     "content": [...pedidos...],
     "pageNumber": 0,
     "pageSize": 100,
     "totalElements": 45,
     "totalPages": 1,
     "last": true
   }

3. Probar rate limiting
   - Abrir pantalla 101 veces en 60 segundos
   - Petición 101 debe recibir 429 Too Many Requests
   - Esperar 60 segundos y reintentar (debe funcionar)

4. Edge cases
   ✓ Cliente sin pedidos → mostrar "Sin pedidos"
   ✓ Pedidos con detalles múltiples → mostrar correcto
```

**Monitor Rate Limit:**
```bash
# En backend logs, buscar:
"Has excedido el límite de 100 peticiones por minuto"
```

---

## 🐛 Debugging Tools

### 1. Flutter DevTools

```bash
# Terminal 1: Ejecutar app
flutter run

# Terminal 2: Abrir DevTools
flutter pub global run devtools

# Acceder a http://localhost:9100
# Ver Network tab para monitorear peticiones
```

### 2. Network Monitoring

```bash
# Ver peticiones en tiempo real
flutter run --verbosity=debug 2>&1 | grep "GET\|POST"
```

### 3. Database Inspector

```dart
// En main.dart, agregar:
import 'package:flutter/services.dart';

// Para inspeccionar datos locales
print(await DatabaseHelper.instance.allPedidos());
```

---

## ✅ Checklist de Verificación

### Antes de Cada Test

- [ ] Backend running (`java -jar target/Praza-Shop-0.0.1-SNAPSHOT.jar`)
- [ ] API URL correcta en `ApiService.baseUrl`
- [ ] Token JWT válido
- [ ] Base de datos con datos de prueba

### Durante Testing

- [ ] Monitor network latency (~200ms esperado)
- [ ] Check console logs (sin errores)
- [ ] Verificar estado de carga (loading spinners)
- [ ] Comprobar manejo de errores

### Después de Testing

- [ ] Documentar resultados
- [ ] Comparar con tiempos anteriores
- [ ] Verificar reduce de latencia 75%
- [ ] Confirmar menos llamadas API

---

## 📊 Métricas Esperadas

| Métrica | Antes | Después | Status |
|---------|-------|---------|--------|
| Dashboard latency | 800ms | 200ms | ⏱️ |
| Detalle latency | 400ms | 200ms | ⏱️ |
| Checkout latency | 300ms | 250ms | ⏱️ |
| API calls (Dashboard) | 4 | 1 | 📡 |
| API calls (Detalle) | 2 | 1 | 📡 |

**Comandos para medir:**
```dart
// En cada pantalla, agregar:
final stopwatch = Stopwatch()..start();
// ... cargar datos ...
print('Tiempo de carga: ${stopwatch.elapsedMilliseconds}ms');
```

---

## 🔍 Errores Comunes

### Error 1: "getProductoDetalles not found"
```
Solución: Verificar que ProductoService tiene el método importado
- Check: lib/services/producto_service.dart línea 50+
```

### Error 2: "JWT Token inválido"
```
Solución: Token expirado
- Hacer login nuevamente
- O ejecutar refresh token
```

### Error 3: "429 Too Many Requests"
```
Solución: Rate limiting activado
- Esperar 60 segundos
- O verificar que sea test legítimo (no spam)
```

### Error 4: "Pedido sin detalles"
```
Solución: Transacción no atómica
- Verificar backend logs
- Que endpoint sea /api/pedidos/crear-completo (no separado)
```

---

## 📞 Quick Links

- **Backend Logs:** `BackEnd/Praza-Shop/target/logs/`
- **Flutter Logs:** Terminal output desde `flutter run`
- **API Status:** `GET http://localhost:8080/test` (si existe)
- **Rate Limit Status:** Backend logs buscar "RateLimit"

---

## 🚀 Go/No-Go Decision

**Go si:**
- ✅ 4 pantallas funciona sin crashes
- ✅ Latencia reducida (75% en dashboard)
- ✅ Menos llamadas API (4→1 en dashboard)
- ✅ Datos correctos en todas las pantallas

**No-Go si:**
- ❌ Crashes en alguna pantalla
- ❌ Latencia NO mejoró
- ✗ Sigue haciendo múltiples llamadas
- ❌ Datos incompletos o incorrectos

---

**Status:** 🟡 Ready for Testing  
**Fecha:** May 19, 2026  
**Versión:** 0.0.1-SNAPSHOT
