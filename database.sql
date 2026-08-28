CREATE DATABASE IF NOT EXISTS pizzeria_don_piccolo_lau
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE pizzeria_don_piccolo_lau;

CREATE TABLE direcciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    calle_carrera VARCHAR(100) NOT NULL,
    numero VARCHAR(50) NOT NULL,
    barrio VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) DEFAULT 'Bucaramanga',
    detalles_adicionales VARCHAR(255)
);

CREATE TABLE personas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20)
);

CREATE TABLE clientes (
    id INT PRIMARY KEY,
    correo VARCHAR(100) UNIQUE,
    direccion_fk INT,
    FOREIGN KEY (id) REFERENCES personas(id) ON DELETE CASCADE,
    FOREIGN KEY (direccion_fk) REFERENCES direcciones(id) ON DELETE SET NULL
);

CREATE TABLE repartidores (
    id INT PRIMARY KEY,
    zona_asignada VARCHAR(100) NOT NULL,
    estado ENUM('disponible', 'no disponible') DEFAULT 'disponible',
    FOREIGN KEY (id) REFERENCES personas(id) ON DELETE CASCADE
);

CREATE TABLE pizzas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tamano ENUM('pequeña', 'mediana', 'familiar') NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    tipo ENUM('vegetariana', 'especial', 'clásica') NOT NULL
);

CREATE TABLE ingredientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 10,
    costo DECIMAL(10,2) NOT NULL
);

CREATE TABLE pizza_ingredientes (
    pizza_fk INT,
    ingrediente_fk INT,
    cantidad_necesaria INT DEFAULT 1,
    PRIMARY KEY (pizza_fk, ingrediente_fk),
    FOREIGN KEY (pizza_fk) REFERENCES pizzas(id) ON DELETE CASCADE,
    FOREIGN KEY (ingrediente_fk) REFERENCES ingredientes(id) ON DELETE CASCADE
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_fk INT NOT NULL,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('efectivo', 'tarjeta', 'app') NOT NULL,
    estado ENUM('pendiente', 'en preparación', 'en camino', 'entregado', 'cancelado') DEFAULT 'pendiente',
    total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (cliente_fk) REFERENCES clientes(id)
);

CREATE TABLE detalle_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_fk INT NOT NULL,
    pizza_fk INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_fk) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (pizza_fk) REFERENCES pizzas(id)
);

CREATE TABLE domicilios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_fk INT UNIQUE NOT NULL,
    repartidor_fk INT NOT NULL,
    hora_salida DATETIME,
    hora_entrega DATETIME,
    distancia_km DECIMAL(5,2),
    costo_envio DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (pedido_fk) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (repartidor_fk) REFERENCES repartidores(id)
);

CREATE TABLE historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pizza_fk INT NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pizza_fk) REFERENCES pizzas(id) ON DELETE CASCADE
);