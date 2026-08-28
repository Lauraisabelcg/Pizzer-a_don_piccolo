CREATE VIEW vw_resumen_pedidos_cliente AS
SELECT 
    CONCAT(pe.nombre, ' ', pe.apellido) AS nombre_cliente,
    c.correo,
    COUNT(ped.id) AS total_pedidos_realizados, 
    COALESCE(SUM(ped.total), 0) AS total_dinero_gastado
FROM clientes c
JOIN personas pe ON c.id = pe.id
LEFT JOIN pedidos ped ON c.id = ped.cliente_fk
GROUP BY c.id;

CREATE VIEW vw_desempeno_repartidores AS
SELECT 
    CONCAT(pe.nombre, ' ', pe.apellido) AS nombre_repartidor, 
    r.zona_asignada,
    COUNT(d.id) AS numero_total_entregas, 
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)), 1) AS tiempo_promedio_minutos
FROM repartidores r
JOIN personas pe ON r.id = pe.id
JOIN domicilios d ON r.id = d.repartidor_fk
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.id;

CREATE VIEW vw_stock_critico AS
SELECT 
    nombre AS ingrediente, 
    stock_actual, 
    stock_minimo,
    (stock_minimo - stock_actual) AS unidades_faltantes
FROM ingredientes
WHERE stock_actual < stock_minimo;