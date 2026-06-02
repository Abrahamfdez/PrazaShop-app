-- ============================================
-- SCRIPT COMPLETO DE SETUP PRAZASHOP
-- Crea BD, tablas, índices y datos de prueba
-- ============================================

-- 1. CREAR BASE DE DATOS CON CHARSET CORRECTO
-- ============================================
DROP DATABASE IF EXISTS prazashop;
CREATE DATABASE IF NOT EXISTS prazashop 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE prazashop;

-- Configurar propiedades de BD
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- 2. TABLA USUARIO
-- ============================================
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    contrasinal VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    tipo_usuario ENUM('CLIENTE', 'NEGOCIO', 'ADMIN') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_tipo_usuario (tipo_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. TABLA CLIENTE
-- ============================================
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    direccion_envio VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_cliente_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    INDEX idx_usuario (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. TABLA NEGOCIO
-- ============================================
CREATE TABLE negocio (
    id_negocio INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    nome_negocio VARCHAR(150) NOT NULL,
    direccion VARCHAR(255),
    descricion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_negocio_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    INDEX idx_usuario (id_usuario),
    INDEX idx_nome (nome_negocio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. TABLA PRODUCTO
-- ============================================
CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_negocio INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    descricion TEXT,
    prezo DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    categoria VARCHAR(100),
    duracion_oferta VARCHAR(100),
    imaxe VARCHAR(255),
    estado ENUM('ACTIVO', 'DISPONIBLE', 'NO_DISPONIBLE', 'ELIMINADO') NOT NULL DEFAULT 'DISPONIBLE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_producto_negocio
        FOREIGN KEY (id_negocio) REFERENCES negocio(id_negocio)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    INDEX idx_negocio (id_negocio),
    INDEX idx_categoria (categoria),
    INDEX idx_estado (estado),
    INDEX idx_nome (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. TABLA PEDIDO
-- ============================================
CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_negocio INT NOT NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_confirmacion DATETIME NULL,
    data_entrega DATETIME NULL,
    data_cancelacion DATETIME NULL,
    estado ENUM('PENDIENTE', 'CONFIRMADO', 'CANCELADO', 'ENTREGADO') NOT NULL DEFAULT 'PENDIENTE',
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_negocio
        FOREIGN KEY (id_negocio) REFERENCES negocio(id_negocio)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    INDEX idx_cliente (id_cliente),
    INDEX idx_negocio (id_negocio),
    INDEX idx_estado (estado),
    INDEX idx_data_pedido (data_pedido)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. TABLA DETALLE_PEDIDO
-- ============================================
CREATE TABLE detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidade INT NOT NULL,
    prezo_unitario DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    INDEX idx_pedido (id_pedido),
    INDEX idx_producto (id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. TABLA COMPRA_RECORRENTE
-- ============================================
CREATE TABLE compra_recorrente (
    id_recorrente INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidade INT NOT NULL,
    frecuencia ENUM('DIARIA', 'SEMANAL', 'MENSUAL') NOT NULL,
    data_inicio DATE NOT NULL,
    estado ENUM('ACTIVA', 'PAUSADA', 'CANCELADA') NOT NULL DEFAULT 'ACTIVA',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_recorrente_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_recorrente_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    INDEX idx_cliente (id_cliente),
    INDEX idx_producto (id_producto),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. TABLA VALORACION
-- ============================================
CREATE TABLE valoracion (
    id_valoracion INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_negocio INT NOT NULL,
    puntuacion INT NOT NULL CHECK (puntuacion >= 1 AND puntuacion <= 5),
    comentario TEXT,
    data_valoracion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_valoracion_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_valoracion_negocio
        FOREIGN KEY (id_negocio) REFERENCES negocio(id_negocio)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    INDEX idx_cliente (id_cliente),
    INDEX idx_negocio (id_negocio),
    INDEX idx_puntuacion (puntuacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. TABLA TOKEN (para autenticación JWT)
-- ============================================
CREATE TABLE token (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(500) NOT NULL UNIQUE,
    tipo_token ENUM('ACCESS', 'REFRESH') NOT NULL DEFAULT 'ACCESS',
    revocado BOOLEAN NOT NULL DEFAULT FALSE,
    expirado BOOLEAN NOT NULL DEFAULT FALSE,
    id_usuario INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_token_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    INDEX idx_usuario (id_usuario),
    INDEX idx_token (token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. TABLA STOCK_MOVIMIENTO (auditoría de stock)
-- ============================================
CREATE TABLE stock_movimiento (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_pedido INT,
    tipo ENUM('RESERVA', 'CONFIRMACION', 'LIBERACION', 'AJUSTE_MANUAL') NOT NULL,
    cantidad INT NOT NULL,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notas VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_stock_mov_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_stock_mov_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    INDEX idx_producto (id_producto),
    INDEX idx_pedido (id_pedido),
    INDEX idx_tipo (tipo),
    INDEX idx_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- INSERTAR DATOS DE PRUEBA (OPCIONAL)
-- ============================================

-- Usuarios de prueba
INSERT INTO usuario (nome, email, contrasinal, telefono, tipo_usuario) VALUES
('Juan Cliente', 'cliente@test.com', 'password123', '666123456', 'CLIENTE'),
('María Negocio', 'negocio@test.com', 'password123', '666654321', 'NEGOCIO'),
('Admin Sistema', 'admin@test.com', 'password123', '666999999', 'ADMIN');

-- Clientes
INSERT INTO cliente (id_usuario, direccion_envio) VALUES
(1, 'Rúa Principal 123, Santiago de Compostela'),
(2, 'Avenida Central 456, Vigo');

-- Negocios
INSERT INTO negocio (id_usuario, nome_negocio, direccion, descricion) VALUES
(2, 'Verduras Frescas del Campo', 'Rúa do Comercio 789, Santiago', 'Productos frescos directos del productor');

-- Productos
INSERT INTO producto (id_negocio, nome, descricion, prezo, stock, categoria, estado) VALUES
(1, 'Froitas de Temporada', 'Maçã, pera, melocotón', 2.50, 50, 'Froitas', 'ACTIVO'),
(1, 'Verduras Verdes', 'Lechuga, espinaca, brócoli', 1.80, 75, 'Verduras', 'ACTIVO'),
(1, 'Carne de Ternera', 'Carne fresca de ternera gallega', 12.50, 20, 'Carne/Meats', 'ACTIVO'),
(1, 'Pan Integral', 'Pan hecho diariamente', 3.20, 30, 'Panadería', 'ACTIVO'),
(1, 'Leche Fresca', 'Leite integral fresca', 1.50, 100, 'Lácteos', 'ACTIVO'),
(1, 'Peixe do Día', 'Peixe fresco da costa', 8.99, 15, 'Peixe', 'ACTIVO');

-- Pedidos de prueba
INSERT INTO pedido (id_cliente, id_negocio, estado, total) VALUES
(1, 1, 'PENDIENTE', 15.30),
(1, 1, 'CONFIRMADO', 24.99);

-- Detalles de pedidos
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidade, prezo_unitario) VALUES
(1, 1, 2, 2.50),
(1, 2, 3, 1.80),
(1, 5, 2, 1.50),
(2, 3, 2, 12.50),
(2, 4, 1, 3.20);

-- Valoraciones de prueba
INSERT INTO valoracion (id_cliente, id_negocio, puntuacion, comentario) VALUES
(1, 1, 5, 'Excelentes productos, muy frescos'),
(2, 1, 4, 'Buena calidad, entrega rápida');

-- ============================================
-- MOSTRAR ESTADÍSTICAS
-- ============================================
SELECT '=== PRAZASHOP DATABASE SETUP COMPLETO ===' AS info;
SELECT CONCAT('Usuarios creados: ', COUNT(*)) FROM usuario;
SELECT CONCAT('Clientes registrados: ', COUNT(*)) FROM cliente;
SELECT CONCAT('Negocios activos: ', COUNT(*)) FROM negocio;
SELECT CONCAT('Productos disponibles: ', COUNT(*)) FROM producto WHERE estado = 'ACTIVO';
SELECT CONCAT('Pedidos totales: ', COUNT(*)) FROM pedido;
SELECT CONCAT('Valoraciones: ', COUNT(*)) FROM valoracion;

-- Mostrar tabla de usuarios
SELECT '=== USUARIOS ===' AS info;
SELECT id_usuario, nome, email, tipo_usuario FROM usuario;

-- Mostrar tabla de productos
SELECT '=== PRODUCTOS ===' AS info;
SELECT id_producto, nome, categoria, prezo, stock, estado FROM producto;

-- Mostrar tabla de pedidos
SELECT '=== PEDIDOS ===' AS info;
SELECT p.id_pedido, u.nome as cliente, n.nome_negocio, p.total, p.estado, p.data_pedido 
FROM pedido p 
JOIN cliente c ON p.id_cliente = c.id_cliente 
JOIN usuario u ON c.id_usuario = u.id_usuario 
JOIN negocio n ON p.id_negocio = n.id_negocio;

-- ============================================
-- INFORMACIÓN DE CONEXIÓN
-- ============================================
/*
BASE DE DATOS: prazashop
CHARSET: utf8mb4 (soporta acentos y caracteres especiales)
COLLATION: utf8mb4_unicode_ci

USUARIO DE PRUEBA (CLIENTE):
  Email: cliente@test.com
  Contraseña: password123

USUARIO DE PRUEBA (NEGOCIO):
  Email: negocio@test.com
  Contraseña: password123

USUARIO DE PRUEBA (ADMIN):
  Email: admin@test.com
  Contraseña: password123

Tablas creadas: 11
- usuario
- cliente
- negocio
- producto (6 productos de prueba)
- pedido (2 pedidos de prueba)
- detalle_pedido
- compra_recorrente
- valoracion (2 valoraciones de prueba)
- token
- stock_movimiento

*/
