CREATE DATABASE IF NOT EXISTS prazashop;
USE prazashop;

-- =========================
-- TABLA USUARIO
-- =========================
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    contrasinal VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    tipo_usuario ENUM('CLIENTE', 'NEGOCIO', 'ADMIN') NOT NULL
);

-- =========================
-- TABLA CLIENTE
-- =========================
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    direccion_envio VARCHAR(255),
    CONSTRAINT fk_cliente_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- TABLA NEGOCIO
-- =========================
CREATE TABLE negocio (
    id_negocio INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    nome_negocio VARCHAR(150) NOT NULL,
    direccion VARCHAR(255),
    descricion TEXT,
    CONSTRAINT fk_negocio_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- TABLA PRODUCTO
-- =========================
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
    estado ENUM('DISPONIBLE', 'NO_DISPONIBLE', 'ELIMINADO') NOT NULL DEFAULT 'DISPONIBLE',
    CONSTRAINT fk_producto_negocio
        FOREIGN KEY (id_negocio) REFERENCES negocio(id_negocio)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- TABLA PEDIDO
-- Cada pedido pertence a un cliente e a un negocio
-- =========================
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
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_negocio
        FOREIGN KEY (id_negocio) REFERENCES negocio(id_negocio)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- TABLA DETALLE_PEDIDO
-- =========================
CREATE TABLE detalle_pedido (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidade INT NOT NULL,
    prezo_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- TABLA COMPRA_RECORRENTE
-- =========================
CREATE TABLE compra_recorrente (
    id_recorrente INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidade INT NOT NULL,
    frecuencia ENUM('DIARIA', 'SEMANAL', 'MENSUAL') NOT NULL,
    data_inicio DATE NOT NULL,
    estado ENUM('ACTIVA', 'PAUSADA', 'CANCELADA') NOT NULL DEFAULT 'ACTIVA',
    CONSTRAINT fk_recorrente_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_recorrente_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =========================
-- TABLA VALORACION
-- =========================
CREATE TABLE valoracion (
    id_valoracion INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_negocio INT NOT NULL,
    puntuacion INT NOT NULL,
    comentario TEXT,
    data_valoracion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_valoracion_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_valoracion_negocio
        FOREIGN KEY (id_negocio) REFERENCES negocio(id_negocio)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);