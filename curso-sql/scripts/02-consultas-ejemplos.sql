-- ========================================
-- CONSULTAS SQL - EJEMPLOS DEL CURSO
-- Módulo 3: SQL - Lenguaje Estructurado de Consulta
-- ========================================

USE empresa_db;

-- ========================================
-- 1. SELECT BÁSICO
-- ========================================

-- Seleccionar todas las columnas
SELECT * FROM empleados;

-- Seleccionar columnas específicas
SELECT nombre, cargo, salario FROM empleados;

-- Seleccionar con expresiones calculadas
SELECT 
    nombre, 
    salario,
    salario * 1.10 AS salario_nuevo
FROM empleados;

-- Ver resultado
-- +-----------------+------------------+--------------+
-- | nombre          | cargo            | salario_nuevo|
-- +-----------------+------------------+--------------+
-- | Juan García     | Gerente de TI    |     93500.00 |
-- | María López     | Analista Senior  |     82500.00 |
-- +-----------------+------------------+--------------+

-- Alias de columnas
SELECT 
    nombre AS "Nombre del Empleado",
    cargo AS "Puesto",
    salario AS "Salario Mensual"
FROM empleados;

-- ========================================
-- 2. SELECT DISTINCT
-- ========================================

-- Obtener cargos únicos
SELECT DISTINCT cargo FROM empleados;

-- Ver resultado
-- +------------------+
-- | cargo            |
-- +------------------+
-- | Gerente de TI    |
-- | Analista Senior  |
-- | Desarrollador    |
-- | Gerente de Ventas|
-- +------------------+

-- ========================================
-- 3. WHERE - FILTRADO DE FILAS
-- ========================================

-- Filtrar por igual
SELECT * FROM empleados WHERE id_emp = 1;

-- Filtrar por mayor que
SELECT * FROM empleados WHERE salario > 70000;

-- Filtrar por diferente
SELECT * FROM empleados WHERE cargo <> 'Gerente';

-- Filtrar por rango
SELECT * FROM empleados WHERE salario BETWEEN 50000 AND 70000;

-- Ver resultado de WHERE salario > 70000
-- +-----------------+------------------+----------+
-- | nombre          | cargo            | salario  |
-- +-----------------+------------------+----------+
-- | Juan García     | Gerente de TI    | 85000.00 |
-- | Ana Hernández   | Gerente de Ventas| 80000.00 |
-- | Miguel Torres   | Director de RH   | 90000.00 |
-- +-----------------+------------------+----------+

-- ========================================
-- 4. OPERADORES LÓGICOS: AND, OR, NOT
-- ========================================

-- AND: Ambas condiciones verdaderas
SELECT * FROM empleados 
WHERE cargo = 'Gerente' AND salario > 75000;

-- OR: Al menos una condición verdadera
SELECT * FROM empleados 
WHERE cargo = 'Gerente' OR cargo = 'Director';

-- NOT: Niega la condición
SELECT * FROM empleados 
WHERE NOT cargo = 'Gerente';

-- Combinación de operadores
SELECT * FROM empleados 
WHERE (cargo = 'Gerente' OR cargo = 'Analista') 
  AND salario >= 60000;

-- Ver resultado de AND
-- +-----------------+------------------+----------+
-- | nombre          | cargo            | salario  |
-- +-----------------+------------------+----------+
-- | Juan García     | Gerente de TI    | 85000.00 |
-- | Ana Hernández   | Gerente de Ventas| 80000.00 |
-- +-----------------+------------------+----------+

-- ========================================
-- 5. ORDER BY - ORDENAMIENTO
-- ========================================

-- Orden ascendente (por defecto)
SELECT * FROM empleados ORDER BY nombre;

-- Orden descendente
SELECT * FROM empleados ORDER BY salario DESC;

-- Múltiples columnas
SELECT * FROM empleados 
ORDER BY cargo ASC, salario DESC;

-- Ver resultado ORDER BY salario DESC
-- +------------------+------------------+----------+
-- | nombre           | cargo            | salario  |
-- +------------------+------------------+----------+
-- | Miguel Torres    | Director de RH   | 90000.00 |
-- | Juan García     | Gerente de TI    | 85000.00 |
-- | Ana Hernández   | Gerente de Ventas| 80000.00 |
-- +------------------+------------------+----------+

-- ========================================
-- 6. LIMIT - LIMITAR RESULTADOS
-- ========================================

-- Obtener los primeros 3 empleados
SELECT * FROM empleados ORDER BY salario DESC LIMIT 3;

-- Obtener 3 empleados, saltando los primeros 2
SELECT * FROM empleados ORDER BY salario DESC LIMIT 2, 3;

-- Ver resultado LIMIT 3
-- +------------------+------------------+----------+
-- | nombre           | cargo            | salario  |
-- +------------------+------------------+----------+
-- | Miguel Torres    | Director de RH   | 90000.00 |
-- | Juan García     | Gerente de TI    | 85000.00 |
-- | Ana Hernández   | Gerente de Ventas| 80000.00 |
-- +------------------+------------------+----------+

-- ========================================
-- 7. LIKE - PATRONES DE TEXTO
-- ========================================

-- Nombres que empiezan con 'J'
SELECT nombre FROM empleados WHERE nombre LIKE 'J%';

-- Nombres que terminan con 'z'
SELECT nombre FROM empleados WHERE nombre LIKE '%ez';

-- Nombres que contienen 'ar'
SELECT nombre FROM empleados WHERE nombre LIKE '%ar%';

-- Comodín _: exactamente un carácter
SELECT nombre FROM empleados WHERE nombre LIKE 'J_an';  -- Juan

-- Ver resultado LIKE 'J%'
-- +--------------+
-- | nombre       |
-- +--------------+
-- | Juan García  |
-- +--------------+

-- ========================================
-- 8. IN - LISTA DE VALORES
-- ========================================

-- Empleados de departamentos específicos
SELECT nombre, id_dept
FROM empleados
WHERE id_dept IN (1, 2, 3);

-- Con NOT IN
SELECT nombre, id_dept
FROM empleados
WHERE id_dept NOT IN (4, 5);

-- ========================================
-- 9. BETWEEN - RANGOS
-- ========================================

-- Salario entre 50000 y 70000
SELECT nombre, salario
FROM empleados
WHERE salario BETWEEN 50000 AND 70000;

-- Fechas en rango
SELECT *
FROM pedidos
WHERE fecha_pedido BETWEEN '2024-01-01' AND '2024-02-28';

-- Ver resultado BETWEEN
-- +----------------+----------+
-- | nombre         | salario  |
-- +----------------+----------+
-- | Carlos Ruiz    | 55000.00 |
-- | Laura Díaz     | 52000.00 |
-- | Elena Vargas   | 55000.00 |
-- +----------------+----------+

-- ========================================
-- 10. FUNCIONES DE AGREGACIÓN
-- ========================================

-- Contar empleados
SELECT COUNT(*) FROM empleados;
SELECT COUNT(id_emp) FROM empleados;
SELECT COUNT(DISTINCT cargo) FROM empleados;

-- Sumar salarios
SELECT SUM(salario) FROM empleados;

-- Promedio
SELECT AVG(salario) FROM empleados;

-- Mínimo y máximo
SELECT MIN(salario), MAX(salario) FROM empleados;

-- Ver resultado funciones
-- +-------------+-------------+
-- | MIN(salario)| MAX(salario)|
-- +-------------+-------------+
-- |     52000.00|     90000.00|
-- +-------------+-------------+

-- ========================================
-- 11. GROUP BY - AGRUPACIÓN
-- ========================================

-- Agrupar por departamento
SELECT 
    id_dept,
    COUNT(*) AS num_empleados,
    AVG(salario) AS salario_promedio,
    SUM(salario) AS total_salarios
FROM empleados
GROUP BY id_dept;

-- Ver resultado GROUP BY
-- +-----------+---------------+------------------+--------------+
-- | id_dept   | num_empleados | salario_promedio | total_salarios|
-- +-----------+---------------+------------------+--------------+
-- |         1 |              3 |       71666.67   |    215000.00 |
-- |         2 |              3 |       62333.33   |    187000.00 |
-- +-----------+---------------+------------------+--------------+

-- ========================================
-- 12. HAVING - FILTRO DESPUÉS DE GROUP BY
-- ========================================

-- Departamentos con más de 2 empleados Y salario promedio > 60000
SELECT id_dept, COUNT(*) AS num_emp, AVG(salario) AS prom
FROM empleados
GROUP BY id_dept
HAVING COUNT(*) > 2 AND AVG(salario) > 60000;

-- ========================================
-- 13. INSERT - INSERTAR DATOS
-- ========================================

-- Insertar valores en todas las columnas
INSERT INTO empleados VALUES 
(13, 'Nuevo Empleado', 'nuevo@email.com', '555-9999', 
 'Analista', 60000.00, 0.00, 1, 1, '1995-01-01', '2024-01-01', TRUE);

-- Insertar valores en columnas específicas
INSERT INTO empleados (nombre, cargo, salario) 
VALUES ('Otro Nuevo', 'Becario', 30000.00);

-- Insertar múltiples filas
INSERT INTO empleados (nombre, email, cargo, salario, id_dept) VALUES
('Empleado A', 'a@email.com', 'Asistente', 40000.00, 3),
('Empleado B', 'b@email.com', 'Asistente', 42000.00, 3),
('Empleado C', 'c@email.com', 'Asistente', 45000.00, 3);

-- ========================================
-- 14. UPDATE - ACTUALIZAR DATOS
-- ========================================

-- Actualizar un empleado específico
UPDATE empleados 
SET salario = 90000.00 
WHERE id_emp = 1;

-- Actualizar múltiples columnas
UPDATE empleados 
SET salario = salario * 1.10,
    comision = comision + 500
WHERE cargo = 'Gerente';

-- Actualizar con CASE
UPDATE empleados 
SET salario = CASE
    WHEN cargo = 'Gerente' THEN salario * 1.15
    WHEN cargo = 'Analista' THEN salario * 1.10
    ELSE salario * 1.05
END;

-- Ver resultado UPDATE
-- Query OK, 1 row affected
-- Rows matched: 1  Changed: 1

-- ========================================
-- 15. DELETE - ELIMINAR DATOS
-- ========================================

-- Eliminar un empleado específico
DELETE FROM empleados WHERE id_emp = 13;

-- Eliminar con subconsulta
DELETE FROM empleados 
WHERE id_dept IN (
    SELECT id_dept FROM departamentos WHERE activo = 0
);

-- ========================================
-- 16. SUBCONSULTAS
-- ========================================

-- Empleados con salario mayor al promedio
SELECT nombre, salario
FROM empleados
WHERE salario > (SELECT AVG(salario) FROM empleados);

-- Ver resultado
-- +----------------+----------+
-- | nombre         | salario  |
-- +----------------+----------+
-- | Juan García    | 93500.00 |
-- | Ana Hernández  | 88000.00 |
-- | Miguel Torres  | 94500.00 |
-- +----------------+----------+

-- Subconsulta correlacionada
SELECT e1.nombre, e1.salario
FROM empleados e1
WHERE e1.salario > (
    SELECT AVG(e2.salario)
    FROM empleados e2
    WHERE e2.id_dept = e1.id_dept
);

-- ========================================
-- 17. CASE Y IF
-- ========================================

-- CASE simple
SELECT 
    nombre,
    cargo,
    CASE cargo
        WHEN 'Gerente' THEN 'Nivel 1'
        WHEN 'Director' THEN 'Nivel 2'
        WHEN 'Analista' THEN 'Nivel 3'
        ELSE 'Otro'
    END AS nivel_jerarquico
FROM empleados;

-- CASE con condiciones
SELECT 
    nombre,
    salario,
    CASE 
        WHEN salario > 80000 THEN 'Alto'
        WHEN salario > 60000 THEN 'Medio'
        ELSE 'Bajo'
    END AS categoria_salario
FROM empleados;

-- IF()
SELECT 
    nombre,
    IF(salario > 70000, 'Premium', 'Regular') AS categoria
FROM empleados;

-- IFNULL()
SELECT 
    nombre,
    IFNULL(telefono, 'Sin teléfono') AS telefono
FROM empleados;

-- Ver resultado CASE
-- +----------------+----------+------------------+
-- | nombre         | salario  | categoria_salario|
-- +----------------+----------+------------------+
-- | Juan García    | 93500.00 | Alto             |
-- | María López    | 82500.00 | Alto             |
-- | Pedro Martínez | 71500.00 | Medio            |
-- +----------------+----------+------------------+
