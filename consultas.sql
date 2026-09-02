USE pizzeria_don_piccolo_lau;

SELECT 
    p.id AS pedido_id,
    CONCAT(pe.nombre, ' ', pe.apellido) AS cliente,
    p.fecha_hora,
    p.total
FROM pedidos p
JOIN clientes c ON p.cliente_fk = c.id
JOIN personas pe ON c.id = pe.id
WHERE p.fecha_hora BETWEEN '2026-08-01 00:00:00' AND '2026-08-31 23:59:59';

SELECT 
    piz.nombre AS pizza,
    SUM(dp.cantidad) AS total_unidades_vendidas,
    COUNT(dp.id) AS veces_pedida
FROM detalle_pedidos dp
JOIN pizzas piz ON dp.pizza_fk = piz.id
GROUP BY piz.id, piz.nombre
ORDER BY total_unidades_vendidas DESC;

SELECT 
    d.id AS domicilio_id,
    p.id AS pedido_id,
    CONCAT(per.nombre, ' ', per.apellido) AS repartidor,
    p.estado AS estado_pedido,
    d.hora_salida,
    d.hora_entrega
FROM domicilios d
JOIN repartidores r ON d.repartidor_fk = r.id
JOIN personas per ON r.id = per.id
JOIN pedidos p ON d.pedido_fk = p.id;

SELECT 
    r.zona_asignada AS zona,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)), 1) AS promedio_minutos_entrega
FROM domicilios d
JOIN repartidores r ON d.repartidor_fk = r.id
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.zona_asignada;

SELECT 
    CONCAT(per.nombre, ' ', per.apellido) AS cliente,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total) AS gasto_acumulado
FROM clientes c
JOIN personas per ON c.id = per.id
JOIN pedidos p ON c.id = p.cliente_fk
WHERE p.estado = 'entregado'
GROUP BY c.id, per.nombre, per.apellido
HAVING SUM(p.total) > 100000;

SELECT 
    id, 
    nombre, 
    tamano, 
    precio_base, 
    tipo
FROM pizzas
WHERE nombre LIKE '%especial%' OR nombre LIKE '%pollo%';

SELECT 
    c.id,
    CONCAT(per.nombre, ' ', per.apellido) AS cliente_frecuente,
    c.correo,
    sub.pedidos_mes
FROM clientes c
JOIN personas per ON c.id = per.id
JOIN (
    SELECT 
        cliente_fk, 
        COUNT(id) AS pedidos_mes
    FROM pedidos
    WHERE MONTH(fecha_hora) = MONTH(CURRENT_DATE()) 
      AND YEAR(fecha_hora) = YEAR(CURRENT_DATE())
      AND estado = 'entregado'
    GROUP BY cliente_fk
    HAVING COUNT(id) > 5
) sub ON c.id = sub.cliente_fk;

-- Hola