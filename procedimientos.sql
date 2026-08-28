DELIMITER //

CREATE PROCEDURE sp_actualizar_direccion_cliente(
    IN p_cliente_id INT,
    IN p_calle_carrera VARCHAR(100),
    IN p_numero VARCHAR(50),
    IN p_barrio VARCHAR(100),
    IN p_ciudad VARCHAR(100),
    IN p_detalles VARCHAR(255)
)
BEGIN
    DECLARE v_direccion_id INT;

    SELECT direccion_fk INTO v_direccion_id 
    FROM clientes 
    WHERE id = p_cliente_id;

    IF v_direccion_id IS NOT NULL THEN
        UPDATE direcciones 
        SET calle_carrera = p_calle_carrera,
            numero = p_numero,
            barrio = p_barrio,
            ciudad = COALESCE(p_ciudad, 'Bucaramanga'),
            detalles_adicionales = p_detalles
        WHERE id = v_direccion_id;
    ELSE
        INSERT INTO direcciones (calle_carrera, numero, barrio, ciudad, detalles_adicionales)
        VALUES (p_calle_carrera, p_numero, p_barrio, COALESCE(p_ciudad, 'Bucaramanga'), p_detalles);
        
        UPDATE clientes 
        SET direccion_fk = LAST_INSERT_ID() 
        WHERE id = p_cliente_id;
    END IF;
END //

CREATE PROCEDURE sp_despachar_pedido(IN p_domicilio_id INT)
BEGIN
    DECLARE v_pedido_id INT;
    
    UPDATE domicilios 
    SET hora_salida = NOW() 
    WHERE id = p_domicilio_id;
    
    SELECT pedido_fk INTO v_pedido_id FROM domicilios WHERE id = p_domicilio_id;
    UPDATE pedidos SET estado = 'en camino' WHERE id = v_pedido_id;
END //

CREATE PROCEDURE sp_registrar_entrega(IN p_domicilio_id INT, IN p_hora_entrega DATETIME)
BEGIN
    DECLARE v_pedido_id INT;
    
    UPDATE domicilios 
    SET hora_entrega = p_hora_entrega 
    WHERE id = p_domicilio_id;
    
    SELECT pedido_fk INTO v_pedido_id 
    FROM domicilios 
    WHERE id = p_domicilio_id;
    
    UPDATE pedidos 
    SET estado = 'entregado' 
    WHERE id = v_pedido_id;
END //

CREATE PROCEDURE sp_cancelar_pedido(IN p_pedido_id INT)
BEGIN
    DECLARE v_estado_actual VARCHAR(20);
    
    SELECT estado INTO v_estado_actual FROM pedidos WHERE id = p_pedido_id;
    
    IF v_estado_actual = 'entregado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No se puede cancelar un pedido que ya ha sido entregado.';
    ELSE
        UPDATE pedidos SET estado = 'cancelado' WHERE id = p_pedido_id;
    END IF;
END //

DELIMITER ;