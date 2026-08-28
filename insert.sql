USE pizzeria_don_piccolo_lau;

INSERT INTO direcciones (calle_carrera, numero, barrio, ciudad, detalles_adicionales) VALUES
('Calle 35', '# 12-45', 'San Francisco', 'Bucaramanga', 'Apto 201'),
('Carrera 27', '# 45-10', 'Cabecera', 'Bucaramanga', 'Torre B'),
('Calle 56', '# 33-21', 'Antonia Santos', 'Bucaramanga', 'Casa'),
('Carrera 15', '# 22-08', 'Centro', 'Bucaramanga', 'Oficina 402'),
('Calle 105', '# 24-30', 'Provenza', 'Bucaramanga', 'Apto 503');

INSERT INTO personas (nombre, apellido, telefono) VALUES
('Romeo', 'Santos', '3151234567'),
('Selena', 'Gómez', '3162345678'),
('Aurora', 'Autista', '3173456789'),
('Laura', 'Calvache', '3184567890'),
('David', 'Pérez', '3195678901'),
('Juan', 'Martínez', '3001112233'),
('Pedro', 'Alarcón', '3002223344'),
('Santiago', 'Vega', '3003334455');

INSERT INTO clientes (id, correo, direccion_fk) VALUES
(1, 'elchicodelaspoesias@email.com', 1),
(2, 'jelena@email.com', 2),
(3, 'aurora@email.com', 3),
(4, 'lalita@email.com', 4),
(5, 'david.perez@email.com', 5);

INSERT INTO repartidores (id, zona_asignada, estado) VALUES
(6, 'Zona Norte', 'disponible'),
(7, 'Cabecera', 'disponible'),
(8, 'Centro', 'disponible');

INSERT INTO pizzas (nombre, tamano, precio_base, tipo) VALUES
('Pizza Especial Don Piccolo', 'familiar', 45000.00, 'especial'),
('Pizza Margarita Clásica', 'mediana', 30000.00, 'clásica'),
('Pizza Vegetariana Suprema', 'mediana', 32000.00, 'vegetariana'),
('Pizza Pollo y Champiñones Especial', 'familiar', 42000.00, 'especial'),
('Pizza Pepperoni Clásica', 'pequeña', 22000.00, 'clásica');

INSERT INTO ingredientes (nombre, stock_actual, stock_minimo, costo) VALUES
('Masa de Pizza', 100, 20, 3000.00),
('Queso Mozzarella', 150, 25, 4500.00),
('Salsa de Tomate', 120, 20, 2000.00),
('Pepperoni', 80, 15, 5000.00),
('Champiñones', 8, 10, 3500.00),
('Pollo Desmechado', 60, 15, 4000.00),
('Pimentón y Cebolla', 5, 12, 1500.00);

INSERT INTO pizza_ingredientes (pizza_fk, ingrediente_fk, cantidad_necesaria) VALUES
(1, 1, 1), (1, 2, 2), (1, 3, 1), (1, 4, 1), (1, 6, 1),
(2, 1, 1), (2, 2, 1), (2, 3, 1),
(3, 1, 1), (3, 2, 1), (3, 3, 1), (3, 5, 1), (3, 7, 1),
(4, 1, 1), (4, 2, 1), (4, 3, 1), (4, 5, 1), (4, 6, 1),
(5, 1, 1), (5, 2, 1), (5, 3, 1), (5, 4, 1);

INSERT INTO pedidos (cliente_fk, fecha_hora, metodo_pago, estado) VALUES
(1, '2026-08-01 12:30:00', 'efectivo', 'entregado'),
(1, '2026-08-05 19:15:00', 'tarjeta', 'entregado'),
(1, '2026-08-10 20:00:00', 'app', 'entregado'),
(1, '2026-08-15 13:45:00', 'efectivo', 'entregado'),
(1, '2026-08-20 21:10:00', 'tarjeta', 'entregado'),
(1, '2026-08-25 19:30:00', 'app', 'entregado'),
(2, '2026-08-12 18:00:00', 'tarjeta', 'entregado'),
(2, '2026-08-18 19:40:00', 'tarjeta', 'entregado'),
(3, '2026-08-22 20:15:00', 'efectivo', 'en preparación'),
(4, '2026-08-26 14:00:00', 'app', 'cancelado');

INSERT INTO detalle_pedidos (pedido_fk, pizza_fk, cantidad, precio_unitario) VALUES
(1, 1, 1, 45000.00),
(2, 4, 1, 42000.00),
(3, 2, 2, 30000.00),
(4, 5, 1, 22000.00),
(5, 1, 1, 45000.00),
(6, 4, 2, 42000.00),
(7, 1, 2, 45000.00),
(8, 3, 1, 32000.00),
(9, 2, 1, 30000.00),
(10, 5, 1, 22000.00);

INSERT INTO domicilios (pedido_fk, repartidor_fk, hora_salida, hora_entrega, distancia_km, costo_envio) VALUES
(1, 6, '2026-08-01 12:45:00', '2026-08-01 13:10:00', 3.5, 7200.00),
(2, 7, '2026-08-05 19:30:00', '2026-08-05 19:55:00', 2.0, 5400.00),
(3, 8, '2026-08-10 20:15:00', '2026-08-10 20:42:00', 4.0, 7800.00),
(4, 6, '2026-08-15 14:00:00', '2026-08-15 14:20:00', 1.8, 5160.00),
(5, 7, '2026-08-20 21:25:00', '2026-08-20 21:48:00', 2.5, 6000.00),
(6, 6, '2026-08-25 19:45:00', '2026-08-25 20:12:00', 3.2, 6840.00),
(7, 7, '2026-08-12 18:20:00', '2026-08-12 18:40:00', 1.5, 4800.00),
(8, 8, '2026-08-18 20:00:00', '2026-08-18 20:35:00', 5.0, 9000.00);