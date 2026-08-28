DELIMITER //

CREATE FUNCTION calcular_total_pedido(p_pedido_id INT) RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_subtotal DECIMAL(10,2) DEFAULT 0;
    DECLARE v_costo_envio DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(SUM(cantidad * precio_unitario), 0) INTO v_subtotal
    FROM detalle_pedidos
    WHERE pedido_fk = p_pedido_id;
    
    SELECT COALESCE(costo_envio, 0) INTO v_costo_envio
    FROM domicilios
    WHERE pedido_fk = p_pedido_id;
    
    RETURN (v_subtotal + v_costo_envio) * 1.19;
END //

CREATE FUNCTION ganancia_neta_diaria(p_fecha DATE) RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_ventas DECIMAL(10,2) DEFAULT 0;
    DECLARE v_costos DECIMAL(10,2) DEFAULT 0;
    
    SELECT COALESCE(SUM(total), 0) INTO v_ventas
    FROM pedidos
    WHERE DATE(fecha_hora) = p_fecha AND estado = 'entregado';
    
    SELECT COALESCE(SUM(dp.cantidad * pi.cantidad_necesaria * i.costo), 0) INTO v_costos
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.id = dp.pedido_fk
    JOIN pizza_ingredientes pi ON dp.pizza_fk = pi.pizza_fk
    JOIN ingredientes i ON pi.ingrediente_fk = i.id
    WHERE DATE(p.fecha_hora) = p_fecha AND p.estado = 'entregado';
    
    RETURN (v_ventas - v_costos);
END //

DELIMITER ;