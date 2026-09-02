USE pizzeria_don_piccolo_lau;

-- consulta 1 nombre cliente, id_pedido, total y estado_pedido

SELECT 
    p.id AS pedido_id,
    CONCAT(pe.nombre, ' ', pe.apellido) AS cliente,
    p.fecha_hora,
    p.estado,
    p.total
FROM pedidos p JOIN clientes c ON p.cliente_fk = c.id
JOIN personas pe ON c.id = pe.id 
WHERE p.id=2;
-- El total se calcula con los triggers, así que se deben ingresar los insert de pedidos/detalle_pedido despues del trigger

-- consulta pedidos con estado entregado y en un rango de fechas.

SELECT 
    p.id AS pedido_id,
    CONCAT(pe.nombre, ' ', pe.apellido) AS cliente,
    p.fecha_hora,
    p.estado
FROM pedidos p JOIN clientes c ON p.cliente_fk = c.id
JOIN personas pe ON c.id = pe.id WHERE p.estado = 'entregado'

HAVING p.fecha_hora BETWEEN '2026-08-01 00:00:00' AND '2026-08-30 23:59:59';

-- consulta cuantos pedidos se hicieron por cada metodo de pago y total acumulado


-- consulta clientes con más de 5 pedidos

SELECT 
    c.id,
    CONCAT(per.nombre, ' ', per.apellido) AS cliente_frecuente,
    sub.pedidos_mes
FROM clientes c
JOIN personas per ON c.id = per.id
JOIN (
    SELECT 
        cliente_fk, 
        COUNT(id) AS pedidos_mes
    FROM pedidos
    GROUP BY cliente_fk
    HAVING COUNT(id) > 5
) sub ON c.id = sub.cliente_fk;



