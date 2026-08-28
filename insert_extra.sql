-- 1. Cliente nuevo sin historial de compras
INSERT INTO personas (nombre, apellido, telefono) VALUES ('Lucía', 'Fernández', '3209876543');
INSERT INTO clientes (id, correo, direccion_fk) VALUES (LAST_INSERT_ID(), 'lucia.f@email.com', 1);

-- 2. Repartidor nuevo sin entregas asignadas
INSERT INTO personas (nombre, apellido, telefono) VALUES ('Mateo', 'Morales', '3014445566');
INSERT INTO repartidores (id, zona_asignada, estado) VALUES (LAST_INSERT_ID(), 'Provenza', 'disponible');

-- 3. Pedido con múltiples pizzas y del mes anterior (Julio 2026)
INSERT INTO pedidos (cliente_fk, fecha_hora, metodo_pago, estado) 
VALUES (2, '2026-07-28 20:00:00', 'efectivo', 'entregado');

INSERT INTO detalle_pedidos (pedido_fk, pizza_fk, cantidad, precio_unitario) VALUES
(11, 1, 1, 45000.00),
(11, 3, 2, 32000.00);

INSERT INTO domicilios (pedido_fk, repartidor_fk, hora_salida, hora_entrega, distancia_km, costo_envio)
VALUES (11, 7, '2026-07-28 20:20:00', '2026-07-28 20:48:00', 2.8, 6360.00);

-- 4. Prueba del trigger de auditoría de precios
UPDATE pizzas SET precio_base = 48000.00 WHERE id = 1;