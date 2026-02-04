-- ========================================
-- JOINS - CONSULTAS CON MÚLTIPLES TABLAS
-- Ejemplos completos del Curso de SQL
-- ========================================

USE empresa_db;

-- ========================================
-- 1. INNER JOIN
-- ========================================

-- Combina filas que tienen coincidencia en ambas tablas
SELECT 
    e.nombre, 
    e.cargo, 
    d.nombre_dept,
    d.ubicacion
FROM empleados e
INNER JOIN departamentos d ON e.id_dept = d.id_dept;

-- Ver resultado INNER JOIN
-- +-----------------+------------------+-------------+-----------+
-- | nombre          | cargo            | nombre_dept | ubicacion |
-- +-----------------+------------------+-------------+-----------+
-- | Juan García     | Gerente de TI    | TI          | Edif A    |
-- | María López     | Analista Senior  | TI          | Edif A    |
-- | Pedro Martínez  | Desarrollador    | TI          | Edif A    |
-- | Ana Hernández   | Gerente de Ventas| Ventas      | Edif B    |
-- +-----------------+------------------+-------------+-----------+

-- INNER JOIN con filtrado
SELECT 
    e.nombre,
    e.salario,
    d.nombre_dept
FROM empleados e
INNER JOIN departamentos d ON e.id_dept = d.id_dept
WHERE d.nombre_dept = 'TI';

-- INNER JOIN múltiples tablas
SELECT 
    e.nombre AS empleado,
    d.nombre_dept AS departamento,
    p.nombre_proy AS proyecto,
    ap.rol
FROM empleados e
INNER JOIN departamentos d ON e.id_dept = d.id_dept
INNER JOIN asignaciones_proyecto ap ON e.id_emp = ap.id_emp
INNER JOIN proyectos p ON ap.id_proy = p.id_proy;

-- ========================================
-- 2. LEFT JOIN
-- ========================================

-- Devuelve todas las filas de la tabla izquierda
SELECT 
    e.nombre,
    e.cargo,
    d.nombre_dept
FROM empleados e
LEFT JOIN departamentos d ON e.id_dept = d.id_dept;

-- Ver resultado LEFT JOIN (empleado sin dept)
-- +----------------+------------------+-------------+
-- | nombre         | cargo            | nombre_dept |
-- +----------------+------------------+-------------+
-- | Juan García    | Gerente de TI    | TI          |
-- | María López   | Analista Senior  | TI          |
-- | Roberto Gómez  | Contador Senior  | NULL        | ← Sin dept
-- +----------------+------------------+-------------+

-- LEFT JOIN para encontrar empleados SIN departamento
SELECT 
    e.nombre,
    e.cargo
FROM empleados e
LEFT JOIN departamentos d ON e.id_dept = d.id_dept
WHERE d.id_dept IS NULL;

-- LEFT JOIN con agregación
SELECT 
    d.nombre_dept,
    COUNT(e.id_emp) AS num_empleados,
    AVG(e.salario) AS salario_promedio
FROM departamentos d
LEFT JOIN empleados e ON d.id_dept = e.id_dept
GROUP BY d.id_dept, d.nombre_dept;

-- ========================================
-- 3. RIGHT JOIN
-- ========================================

-- Devuelve todas las filas de la tabla derecha
SELECT 
    e.nombre,
    e.cargo,
    d.nombre_dept
FROM empleados e
RIGHT JOIN departamentos d ON e.id_dept = d.id_dept;

-- Ver resultado RIGHT JOIN (departamento sin empleados)
-- +-----------------+------------------+-------------+
-- | nombre         | cargo            | nombre_dept |
-- +-----------------+------------------+-------------+
-- | Juan García   | Gerente de TI    | TI          |
-- | Ana Hernández | Gerente de Ventas| Ventas      |
-- | NULL          | NULL             | Marketing   | ← Sin empleados
-- +-----------------+------------------+-------------+

-- RIGHT JOIN para encontrar departamentos sin empleados
SELECT 
    d.nombre_dept,
    d.presupuesto
FROM empleados e
RIGHT JOIN departamentos d ON e.id_dept = d.id_dept
WHERE e.id_emp IS NULL;

-- ========================================
-- 4. FULL OUTER JOIN (Simulado en MySQL)
-- ========================================

-- MySQL no soporta FULL JOIN, se simula con UNION
SELECT 
    e.nombre,
    e.cargo,
    d.nombre_dept
FROM empleados e
LEFT JOIN departamentos d ON e.id_dept = d.id_dept

UNION

SELECT 
    e.nombre,
    e.cargo,
    d.nombre_dept
FROM empleados e
RIGHT JOIN departamentos d ON e.id_dept = d.id_dept;

-- FULL JOIN con datos específicos
-- Muestra empleados Y departamentos, incluso sin coincidencia

-- ========================================
-- 5. CROSS JOIN
-- ========================================

-- Producto cartesiano de ambas tablas
SELECT 
    e.nombre,
    d.nombre_dept
FROM empleados e
CROSS JOIN departamentos d;

-- Ver resultado (todos los combinaciones)
-- +----------------+-------------+
-- | nombre         | nombre_dept |
-- +----------------+-------------+
-- | Juan García   | TI          | ← Combinación 1
-- | Juan García   | Ventas      | ← Combinación 2
-- | Juan García   | RH          | ← Combinación 3
-- | ...           | ...         |
-- +----------------+-------------+

-- Útil para generar combinaciones
SELECT 
    c.nombre AS cliente,
    p.nombre_producto AS producto
FROM clientes c
CROSS JOIN productos p
WHERE p.categoria = 'Hardware';

-- ========================================
-- 6. SELF JOIN
-- ========================================

-- Une una tabla consigo misma
SELECT 
    e.nombre AS empleado,
    g.nombre AS gerente
FROM empleados e
LEFT JOIN empleados g ON e.id_gerente = g.id_emp;

-- Ver resultado SELF JOIN
-- +------------------+------------------+
-- | empleado         | gerente          |
-- +------------------+------------------+
-- | Juan García      | NULL             | ← Es el gerente
-- | María López      | Juan García     |
-- | Pedro Martínez   | Juan García     |
-- | Ana Hernández    | NULL             | ← Es la gerente
-- | Carlos Ruiz      | Ana Hernández   |
-- +------------------+------------------+

-- SELF JOIN para encontrar pares de empleados del mismo departamento
SELECT 
    e1.nombre AS empleado_1,
    e2.nombre AS empleado_2,
    e1.id_dept AS departamento
FROM empleados e1
INNER JOIN empleados e2 ON e1.id_dept = e2.id_dept
WHERE e1.id_emp < e2.id_emp  -- Evitar duplicados
ORDER BY e1.id_dept;

-- SELF JOIN con múltiples niveles
SELECT 
    e.nombre AS empleado,
    g.nombre AS gerente,
    dg.nombre AS gerente_del_gerente
FROM empleados e
LEFT JOIN empleados g ON e.id_gerente = g.id_emp
LEFT JOIN empleados dg ON g.id_gerente = dg.id_emp;

-- ========================================
-- 7. JOIN CON CONDICIONES COMPUESTAS
-- ========================================

-- JOIN con múltiples condiciones
SELECT 
    e.nombre,
    e.cargo,
    e.salario,
    d.nombre_dept,
    d.presupuesto
FROM empleados e
INNER JOIN departamentos d ON e.id_dept = d.id_dept
WHERE e.salario > 60000
  AND d.presupuesto > 200000;

-- JOIN con operadores
SELECT 
    e.nombre,
    e.salario,
    d.nombre_dept,
    d.presupuesto,
    (d.presupuesto - SUM(e.salario)) AS disponible
FROM empleados e
INNER JOIN departamentos d ON e.id_dept = d.id_dept
GROUP BY e.id_dept;

-- ========================================
-- 8. EJERCICIOS PRÁCTICOS
-- ========================================

-- Ejercicio 1: Lista de empleados con sus proyectos
SELECT 
    e.nombre,
    e.cargo,
    p.nombre_proy,
    ap.horas_asignadas
FROM empleados e
INNER JOIN asignaciones_proyecto ap ON e.id_emp = ap.id_emp
INNER JOIN proyectos p ON ap.id_proy = p.id_proy
WHERE p.estado = 'En Progreso';

-- Ejercicio 2: Total de pedidos por cliente
SELECT 
    c.nombre AS cliente,
    COUNT(p.id_pedido) AS num_pedidos,
    SUM(p.total) AS total_compras
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente;

-- Ejercicio 3: Productos más vendidos
SELECT 
    pr.nombre_producto,
    SUM(dp.cantidad) AS total_vendido,
    SUM(dp.cantidad * dp.precio_unitario) AS ingresos
FROM productos pr
INNER JOIN detalles_pedido dp ON pr.id_producto = dp.id_producto
GROUP BY pr.id_producto
ORDER BY total_vendido DESC;

-- Ejercicio 4: Empleados que no tienen proyectos asignados
SELECT 
    e.nombre,
    e.cargo
FROM empleados e
LEFT JOIN asignaciones_proyecto ap ON e.id_emp = ap.id_emp
WHERE ap.id_proy IS NULL;

-- Ejercicio 5: Departamentos con mayor gasto en salarios
SELECT 
    d.nombre_dept,
    SUM(e.salario) AS total_salarios,
    COUNT(e.id_emp) AS num_empleados
FROM departamentos d
LEFT JOIN empleados e ON d.id_dept = e.id_dept
GROUP BY d.id_dept
ORDER BY total_salarios DESC
LIMIT 3;
