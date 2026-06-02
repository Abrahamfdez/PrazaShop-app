# 📦 Manual de Instalación - PrazaShop

## 📋 Tabla de Contenidos
1. [Requisitos Previos](#requisitos-previos)
2. [Instalación Base de Datos](#instalación-base-de-datos)
3. [Instalación Backend](#instalación-backend)
4. [Instalación Frontend](#instalación-frontend)
5. [Configuración](#configuración)
6. [Ejecución](#ejecución)
7. [Verificación](#verificación)
8. [Solución de Problemas](#solución-de-problemas)

---

## 🔧 Requisitos Previos

### Software Obligatorio
- **Java**: JDK 17+ ([Descargar](https://www.oracle.com/java/technologies/downloads/))
- **MySQL**: 8.0+ ([Descargar](https://dev.mysql.com/downloads/mysql/))
- **Flutter**: 3.10+ ([Descargar](https://flutter.dev/docs/get-started/install))
- **Git**: 2.0+ ([Descargar](https://git-scm.com/))
- **Maven**: 3.8+ (incluido con algunas distribuciones de Java)

### Verificar Instalación
```bash
# Verificar Java
java -version

# Verificar Maven
mvn -version

# Verificar MySQL
mysql --version

# Verificar Flutter
flutter --version

# Verificar Git
git --version
```

---

## 💾 Instalación Base de Datos

### 1. Crear Base de Datos
```bash
# Conectarse a MySQL
mysql -u root -p

# En la consola MySQL, ejecutar:
CREATE DATABASE IF NOT EXISTS prazashop;
USE prazashop;
```

### 2. Importar Esquema
```bash
# Opción 1: Desde línea de comandos
mysql -u root -p prazashop < /ruta/a/CREACION_TABLAS_PRAZASHOP.sql

# Opción 2: Desde cliente MySQL
USE prazashop;
SOURCE /ruta/a/CREACION_TABLAS_PRAZASHOP.sql;
```

### 3. Verificar Tablas
```sql
USE prazashop;
SHOW TABLES;
```

Deberías ver:
- usuario
- cliente
- negocio
- producto
- pedido
- detalle_pedido
- compra_recorrente
- valoracion
- token
- stock_movimiento

---

## 🔙 Instalación Backend

### 1. Descargar/Clonar Proyecto
```bash
cd /ruta/a/tu/proyecto
cd BackEnd/Praza-Shop
```

### 2. Verificar Configuración
Editar archivo `src/main/resources/application.yml`:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/prazashop?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8
    username: root
    password: tu_contraseña_mysql
    driver-class-name: com.mysql.cj.jdbc.Driver
  
  jpa:
    hibernate:
      ddl-auto: validate  # validate, update, create, create-drop
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect
        format_sql: true
        jdbc:
          batch_size: 20
        order_inserts: true
        order_updates: true

  jackson:
    serialization:
      write-dates-as-timestamps: false

server:
  port: 8080
  servlet:
    context-path: /api
```

### 3. Compilar Proyecto
```bash
# Limpiar y compilar
mvn clean install -DskipTests

# Si falla, intentar:
mvn clean compile
mvn package -DskipTests
```

### 4. Resultado Esperado
Debería generar: `target/Praza-Shop-0.0.1-SNAPSHOT.jar`

---

## 📱 Instalación Frontend

### 1. Descargar/Clonar Proyecto
```bash
cd /ruta/a/tu/proyecto
cd FrontEnd/praza_shop
```

### 2. Instalar Dependencias Flutter
```bash
# Obtener dependencias
flutter pub get

# Verificar setup
flutter doctor
```

**Nota**: Resolver cualquier advertencia que muestre `flutter doctor`

### 3. Configuración Importante

Editar `lib/services/api_service.dart` y verificar:

```dart
class ApiService {
  // CAMBIAR ESTA URL según tu entorno
  static const String baseUrl = 'http://localhost:8080/api';
  
  // Para desarrollo remoto:
  // static const String baseUrl = 'http://tu_ip_publica:8080/api';
}
```

### 4. Compilar Frontend (Opcional)
```bash
# Para web
flutter build web

# Para Android
flutter build apk

# Para iOS (solo en Mac)
flutter build ios
```

---

## ⚙️ Configuración

### Variable de Entorno JAVA_HOME
```bash
# Windows (PowerShell)
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"

# macOS/Linux
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Verificar
echo $JAVA_HOME
```

### Puertos Disponibles
Asegurar que estos puertos están libres:
- **8080**: Backend Spring Boot
- **3306**: MySQL
- **8081**: (alternativa para backend si 8080 ocupado)
- **5037**: (Android Debug Bridge - si usas emulador)

---

## 🚀 Ejecución

### Opción 1: Ejecución Local Completa

**Terminal 1 - MySQL**
```bash
# Windows
net start MySQL80

# macOS
brew services start mysql

# Linux
sudo systemctl start mysql
```

**Terminal 2 - Backend**
```bash
cd BackEnd/Praza-Shop
mvn spring-boot:run
```

**Terminal 3 - Frontend (web)**
```bash
cd FrontEnd/praza_shop
flutter run -d chrome
```

**O Frontend (móvil con emulador)**
```bash
cd FrontEnd/praza_shop
flutter emulators --launch Pixel_6_API_30  # o tu emulador
flutter run
```

### Opción 2: Ejecutar JAR Compilado
```bash
# Asegurar MySQL esté corriendo
cd BackEnd/Praza-Shop/target
java -jar Praza-Shop-0.0.1-SNAPSHOT.jar
```

### Opción 3: Usar Docker (Recomendado)
```bash
# Desde raíz del proyecto
docker-compose up -d

# Verificar servicios
docker ps
```

---

## ✅ Verificación

### Verificar Backend
```bash
# Debería retornar JSON si está ok
curl http://localhost:8080/api/test/health

# O desde navegador
http://localhost:8080/api/test/health
```

**Respuesta esperada:**
```json
{
  "status": "UP",
  "database": "MySQL",
  "message": "Backend is running"
}
```

### Verificar Base de Datos
```bash
mysql -u root -p prazashop
SELECT COUNT(*) as total_tables FROM information_schema.tables WHERE table_schema = 'prazashop';
```

### Verificar Frontend
- Abrir `http://localhost:8081` en navegador (o puerto que muestre Flutter)
- Debería cargar la app sin errores
- Verificar consola del navegador (F12) sin errores críticos

### Verificar Conectividad
Desde Flutter, verificar logs:
```bash
flutter logs
```

Buscar líneas como:
```
DEBUG: Conectando a http://localhost:8080/api
DEBUG: Respuesta exitosa del servidor
```

---

## 🐛 Solución de Problemas

### Error: "Port 8080 already in use"
```bash
# Windows - encontrar proceso en puerto 8080
netstat -ano | findstr :8080

# Matar proceso (reemplazar PID)
taskkill /PID <PID> /F

# Alternativa: cambiar puerto en application.yml
server:
  port: 8081
```

### Error: "MySQL Connection refused"
```bash
# Verificar MySQL está corriendo
mysql -u root -p

# Si no funciona, reiniciar servicio
# Windows
net stop MySQL80
net start MySQL80

# macOS
brew services restart mysql

# Linux
sudo systemctl restart mysql
```

### Error: "Cannot find Flutter SDK"
```bash
# Reinstalar Flutter
flutter clean
flutter pub get

# Verificar setup
flutter doctor -v
```

### Error: "Character encoding issue - PanaderÃ­a"
Este es un problema conocido. Soluciones:

**Backend - Configurar MySQL:**
```sql
ALTER DATABASE prazashop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Para cada tabla
ALTER TABLE producto CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE negocio CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

**Backend - application.yml:**
```yaml
datasource:
  url: jdbc:mysql://localhost:3306/prazashop?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8&allowMultiQueries=true
```

**Backend - Pom.xml Maven:**
```xml
<properties>
  <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
</properties>
```

### Error: "InvalidJwtException"
```
Causa: Token JWT expirado o inválido
Solución:
1. Limpiar datos de la app (Flutter)
2. Hacer login nuevamente
3. Verificar reloj del sistema sincronizado
```




## 📊 Pruebas de Funcionamiento

### 1. Crear Usuario (Negocio)
```bash
POST http://localhost:8080/api/auth/register
{
  "nome": "Mi Negocio",
  "email": "negocio@test.com",
  "contrasinal": "password123",
  "tipoUsuario": "NEGOCIO"
}
```

### 2. Crear Usuario (Cliente)
```bash
POST http://localhost:8080/api/auth/register
{
  "nome": "Juan Cliente",
  "email": "cliente@test.com",
  "contrasinal": "password123",
  "tipoUsuario": "CLIENTE"
}
```

### 3. Login
```bash
POST http://localhost:8080/api/auth/login
{
  "email": "cliente@test.com",
  "contrasinal": "password123"
}
```

### 4. Obtener Productos
```bash
GET http://localhost:8080/api/producto/todos
Header: Authorization: Bearer <token_obtenido>
```

---

## 🎯 Próximos Pasos

Después de instalar:

1. **Crear datos de prueba**: Login y crear negocio + productos
2. **Probar flujos**: Cliente busca → compra → negocio confirma
3. **Revisar logs**: Buscar errores de conexión o validación
4. **Documentar**: Guardar tokens y URLs de prueba

---

## 📞 Soporte

Si tienes problemas:

1. Revisar los logs de la consola (Terminal)
2. Revisar `TESTING_GUIDE.md` para casos de uso
3. Verificar `ENDPOINTS_REFERENCE.md` para endpoints disponibles
4. Consultar el archivo de configuración `application.yml`

---

**Versión**: 1.0  
**Última actualización**: Mayo 2026  
**Estado**: Producción
