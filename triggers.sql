DELIMITER //

CREATE TRIGGER trg_set_precio_unitario
BEFORE INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    IF NEW.precio_unitario IS NULL OR NEW.precio_unitario = 0 THEN
        SET NEW.precio_unitario = (SELECT precio_base FROM pizzas WHERE id = NEW.pizza_fk);
    END IF;
END //

CREATE TRIGGER trg_validar_stock
BEFORE INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    DECLARE v_insuficientes INT DEFAULT 0;

    SELECT COUNT(*) INTO v_insuficientes
    FROM pizza_ingredientes pi
    JOIN ingredientes i ON pi.ingrediente_fk = i.id
    WHERE pi.pizza_fk = NEW.pizza_fk 
      AND (i.stock_actual - (pi.cantidad_necesaria * NEW.cantidad)) < 0;

    IF v_insuficientes > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Stock insuficiente de ingredientes para preparar la pizza solicitada.';
    END IF;
END //

CREATE TRIGGER trg_actualizar_stock
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    UPDATE ingredientes i
    JOIN pizza_ingredientes pi ON i.id = pi.ingrediente_fk
    SET i.stock_actual = i.stock_actual - (pi.cantidad_necesaria * NEW.cantidad)
    WHERE pi.pizza_fk = NEW.pizza_fk;
END //

CREATE TRIGGER trg_actualizar_total_insert_detalle
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    UPDATE pedidos 
    SET total = calcular_total_pedido(NEW.pedido_fk) 
    WHERE id = NEW.pedido_fk;
END //

CREATE TRIGGER trg_actualizar_total_update_detalle
AFTER UPDATE ON detalle_pedidos
FOR EACH ROW
BEGIN
    UPDATE pedidos 
    SET total = calcular_total_pedido(NEW.pedido_fk) 
    WHERE id = NEW.pedido_fk;
END //

CREATE TRIGGER trg_actualizar_total_delete_detalle
AFTER DELETE ON detalle_pedidos
FOR EACH ROW
BEGIN
    UPDATE pedidos 
    SET total = calcular_total_pedido(OLD.pedido_fk) 
    WHERE id = OLD.pedido_fk;
END //

CREATE TRIGGER trg_before_insert_domicilio
BEFORE INSERT ON domicilios
FOR EACH ROW
BEGIN
    DECLARE v_estado_repartidor ENUM('disponible', 'no disponible');

    SELECT estado INTO v_estado_repartidor 
    FROM repartidores 
    WHERE id = NEW.repartidor_fk;

    IF v_estado_repartidor = 'no disponible' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El repartidor seleccionado se encuentra ocupado en otra entrega.';
    END IF;

    IF NEW.costo_envio IS NULL OR NEW.costo_envio = 0.00 THEN
        IF NEW.distancia_km IS NOT NULL AND NEW.distancia_km > 0 THEN
            SET NEW.costo_envio = 3000.00 + (NEW.distancia_km * 1200.00);
        ELSE
            SET NEW.costo_envio = 3000.00;
        END IF;
    END IF;
END //

CREATE TRIGGER trg_after_insert_domicilio
AFTER INSERT ON domicilios
FOR EACH ROW
BEGIN
    UPDATE repartidores 
    SET estado = 'no disponible' 
    WHERE id = NEW.repartidor_fk;

    UPDATE pedidos 
    SET total = calcular_total_pedido(NEW.pedido_fk) 
    WHERE id = NEW.pedido_fk;
END //

CREATE TRIGGER trg_liberar_repartidor
AFTER UPDATE ON domicilios
FOR EACH ROW
BEGIN
    IF NEW.hora_entrega IS NOT NULL AND OLD.hora_entrega IS NULL THEN
        UPDATE repartidores 
        SET estado = 'disponible' 
        WHERE id = NEW.repartidor_fk;
    END IF;
END //

CREATE TRIGGER trg_auditoria_precios
AFTER UPDATE ON pizzas
FOR EACH ROW
BEGIN
    IF OLD.precio_base <> NEW.precio_base THEN
        INSERT INTO historial_precios (pizza_fk, precio_anterior, precio_nuevo)
        VALUES (NEW.id, OLD.precio_base, NEW.precio_base);
    END IF;
END //

CREATE TRIGGER trg_manejar_cancelacion_pedido
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'cancelado' AND OLD.estado <> 'cancelado' THEN
        
        UPDATE ingredientes i
        JOIN pizza_ingredientes pi ON i.id = pi.ingrediente_fk
        JOIN detalle_pedidos dp ON pi.pizza_fk = dp.pizza_fk
        SET i.stock_actual = i.stock_actual + (pi.cantidad_necesaria * dp.cantidad)
        WHERE dp.pedido_fk = NEW.id;
        
        UPDATE repartidores r
        JOIN domicilios d ON r.id = d.repartidor_fk
        SET r.estado = 'disponible'
        WHERE d.pedido_fk = NEW.id;
        
    END IF;
END //

DELIMITER ;