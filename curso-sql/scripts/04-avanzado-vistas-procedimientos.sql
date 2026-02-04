-- ========================================
-- VISTAS, STORED PROCEDURES Y TRIGGERS
-- Ejemplos avanzados del Curso de SQL
-- ========================================

USE empresa_db;

-- ========================================
-- VISTAS (VIEWS)
-- ========================================

-- Vista de empleados con departamento
CREATE VIEW vista_empleados_dept AS
SELECT 
    e.id_emp,
    e.nombre,
    e.email,
    e.cargo,
    e.salario,
    e.comision,
    d.id_dept,
    d.nombre_dept,
    d.ubicacion
FROM empleados e
LEFT JOIN departamentos d ON e.id_dept = d.id_dept;

-- Usar la vista
SELECT * FROM vista_empleados_dept WHERE nombre_dept = 'TI';

-- Vista de pedidos con cliente
CREATE VIEW vista_pedidos_cliente AS
SELECT 
    p.id_pedido,
    p.fecha_pedido,
    p.fecha_envio,
    p.estado,
    p.total,
    c.id_cliente,
    c.nombre AS cliente,
    c.ciudad,
    c.pais,
    c.limite_credito
FROM pedidos p
LEFT JOIN clientes c ON p.id_cliente = c.id_cliente;

-- Vista de proyectos con horas asignadas
CREATE VIEW vista_proyectos_horas AS
SELECT 
    p.id_proy,
    p.nombre_proy,
    p.estado,
    p.presupuesto,
    COUNT(DISTINCT ap.id_emp) AS num_empleados,
    SUM(ap.horas_asignadas) AS total_horas
FROM proyectos p
LEFT JOIN asignaciones_proyecto ap ON p.id_proy = ap.id_proy
GROUP BY p.id_proy;

-- Vista de resumen de ventas
CREATE VIEW vista_resumen_ventas AS
SELECT 
    c.nombre AS cliente,
    c.ciudad,
    COUNT(p.id_pedido) AS num_pedidos,
    SUM(p.total) AS total_compras,
    AVG(p.total) AS promedio_pedido
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.estado = 'Entregado'
GROUP BY c.id_cliente;

-- Vista de empleados por nivel salarial
CREATE VIEW vista_empleados_nivel AS
SELECT 
    nombre,
    cargo,
    salario,
    CASE 
        WHEN salario > 80000 THEN 'Nivel 1 - Ejecutivo'
        WHEN salario > 60000 THEN 'Nivel 2 - Senior'
        WHEN salario > 40000 THEN 'Nivel 3 - Medio'
        ELSE 'Nivel 4 - Junior'
    END AS nivel_salarial
FROM empleados;

-- ========================================
-- STORED PROCEDURES
-- ========================================

DELIMITER //

-- Procedimiento: Obtener empleados por departamento
CREATE PROCEDURE sp_empleados_por_dept(IN dept_id INT)
BEGIN
    SELECT 
        id_emp,
        nombre,
        cargo,
        salario
    FROM empleados
    WHERE id_dept = dept_id
    ORDER BY salario DESC;
END //

-- Procedimiento: Insertar nuevo empleado
CREATE PROCEDURE sp_insertar_empleado(
    IN p_nombre VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_cargo VARCHAR(50),
    IN p_salario DECIMAL(10,2),
    IN p_id_dept INT
)
BEGIN
    INSERT INTO empleados (nombre, email, cargo, salario, id_dept)
    VALUES (p_nombre, p_email, p_cargo, p_salario, p_id_dept);
    
    SELECT LAST_INSERT_ID() AS nuevo_id;
END //

-- Procedimiento: Actualizar salario con incremento
CREATE PROCEDURE sp_actualizar_salario(
    IN p_id_emp INT,
    IN p_porcentaje DECIMAL(5,2)
)
BEGIN
    DECLARE nuevo_salario DECIMAL(10,2);
    
    SELECT salario * (1 + p_porcentaje/100)
    INTO nuevo_salario
    FROM empleados
    WHERE id_emp = p_id_emp;
    
    UPDATE empleados
    SET salario = nuevo_salario
    WHERE id_emp = p_id_emp;
    
    SELECT * FROM empleados WHERE id_emp = p_id_emp;
END //

-- Procedimiento: Reporte de ventas por período
CREATE PROCEDURE sp_reporte_ventas(
    IN fecha_inicio DATE,
    IN fecha_fin DATE
)
BEGIN
    SELECT 
        c.nombre AS cliente,
        COUNT(p.id_pedido) AS num_pedidos,
        SUM(p.total) AS total_ventas,
        SUM(p.total) / COUNT(p.id_pedido) AS promedio
    FROM clientes c
    INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
    WHERE p.fecha_pedido BETWEEN fecha_inicio AND fecha_fin
      AND p.estado = 'Entregado'
    GROUP BY c.id_cliente
    ORDER BY total_ventas DESC;
END //

-- Procedimiento: Listar productos con bajo stock
CREATE PROCEDURE sp_productos_bajo_stock(IN limite INT)
BEGIN
    SELECT 
        id_producto,
        nombre_producto,
        stock,
        categoria
    FROM productos
    WHERE stock < limite
    ORDER BY stock ASC;
END //

DELIMITER ;

-- Llamar a los procedimientos
CALL sp_empleados_por_dept(1);
CALL sp_insertar_empleado('Test User', 'test@test.com', 'Tester', 50000, 1);
CALL sp_actualizar_salario(1, 10.00);
CALL sp_productos_bajo_stock(50);

-- ========================================
-- TRIGGERS
-- ========================================

DELIMITER //

-- Trigger: Registrar cambios en empleado
CREATE TRIGGER trg_empleado_audit
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO audit_empleados (
        id_empleado,
        campo_modificado,
        valor_anterior,
        valor_nuevo,
        fecha_cambio
    )
    VALUES (
        NEW.id_emp,
        'salario',
        OLD.salario,
        NEW.salario,
        NOW()
    );
END //

-- Trigger: Actualizar stock después de pedido
CREATE TRigger trg_actualizar_stock
AFTER INSERT ON detalles_pedido
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END //

-- Trigger: Validar límite de crédito
CREATE TRIGGER trg_validar_credito
BEFORE INSERT ON pedidos
FOR EACH ROW
BEGIN
    DECLARE credito_actual DECIMAL(10,2);
    DECLARE total_actual DECIMAL(10,2);
    
    SELECT limite_credito 
    INTO credito_actual
    FROM clientes 
    WHERE id_cliente = NEW.id_cliente;
    
    SELECT IFNULL(SUM(total), 0)
    INTO total_actual
    FROM pedidos 
    WHERE id_cliente = NEW.id_cliente;
    
    IF (total_actual + NEW.total) > credito_actual THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El pedido excede el límite de crédito del cliente';
    END IF;
END //

-- Trigger: Registrar eliminación de empleado
CREATE TRIGGER trg_empleado_log
BEFORE DELETE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO empleados_eliminados (
        id_empleado,
        nombre,
        cargo,
        salario,
        fecha_eliminacion
    )
    VALUES (
        OLD.id_emp,
        OLD.nombre,
        OLD.cargo,
        OLD.salario,
        NOW()
    );
END //

-- Trigger: Actualizar fecha de modificación
CREATE TRIGGER trg_update_empleado
BEFORE UPDATE ON empleados
FOR EACH ROW
BEGIN
    SET NEW.fecha_contratacion = OLD.fecha_contratacion;
END //

DELIMITER ;

-- ========================================
-- TABLAS DE AUDITORÍA
-- ========================================

-- Tabla para auditoría
CREATE TABLE audit_empleados (
    id_audit INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT,
    campo_modificado VARCHAR(50),
    valor_anterior DECIMAL(10,2),
    valor_nuevo DECIMAL(10,2),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para empleados eliminados
CREATE TABLE empleados_eliminados (
    id_eliminacion INT PRIMARY KEY AUTO_INCREMENT,
    id_empleado INT,
    nombre VARCHAR(100),
    cargo VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_eliminacion DATETIME
);

-- ========================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ========================================

-- Índice simple
CREATE INDEX idx_empleados_salario ON empleados(salario);

-- Índice compuesto
CREATE INDEX idx_pedidos_fecha_estado ON pedidos(fecha_pedido, estado);

-- Índice único
CREATE UNIQUE INDEX idx_clientes_email ON clientes(email);

-- Índice de texto completo (MySQL)
ALTER TABLE productos 
ADD FULLTEXT INDEX idx_productos_nombre (nombre_producto);

-- ========================================
-- EJEMPLOS DE USO DE VISTAS
-- ========================================

-- Consultar vista
SELECT * FROM vista_empleados_dept WHERE nombre_dept = 'Ventas';

-- Ver estructura de vista
DESCRIBE vista_empleados_dept;

-- Ver definición de vista
SHOW CREATE VIEW vista_empleados_dept;

-- Eliminar vista
DROP VIEW IF EXISTS vista_empleados_dept;
