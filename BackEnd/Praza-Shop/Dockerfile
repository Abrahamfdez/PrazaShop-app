# ===============================
# STAGE 1 → BUILD
# ===============================
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /build

# Cache de dependencias (más rápido)
COPY pom.xml .
RUN mvn -q -B dependency:go-offline

# Código fuente
COPY src ./src

# Build
RUN mvn -q -B clean package -DskipTests


# ===============================
# STAGE 2 → RUNTIME LIGERO
# ===============================
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copiar solo el jar final
COPY --from=builder /build/target/*.jar app.jar

# Puerto dinámico para Render
ENV PORT=8080

EXPOSE ${PORT}

# Arranque limpio + logs visibles
CMD ["java", "-jar", "app.jar", "--server.port=${PORT}"]