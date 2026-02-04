# SQL: Consultas Avanzadas

## 📋 Contenido

1. [Subconsultas](#1-subconsultas)
2. [Funciones de Agregación](#2-funciones-de-agregación)
3. [GROUP BY y HAVING](#3-group-by-y-having)
4. [LIKE y Patrones](#4-like-y-patrones)
5. [BETWEEN e IN](#5-between-e-in)
6. [CASE y IF](#6-case-y-if)

---

## 1. Subconsultas

Una **subconsulta** es una consulta dentro de otra consulta.

### Subconsulta en WHERE

```sql
-- Encontrar empleados con salario mayor al promedio
SELECT nombre, salario
FROM empleados
WHERE salario > (SELECT AVG(salario) FROM empleados);
```

### Resultado

```
+-------------+----------+
| nombre      | salario  |
+-------------+----------+
| Juan García | 80000.00 |
| Pedro Martínez| 85000.00|
+-------------+----------+
```

### Subconsulta en FROM

```sql
-- Usar resultado de subconsulta como tabla
SELECT dept, AVG(salario) as promedio
FROM (
    SELECT d.nombre_dept AS dept, e.salario
    FROM empleados e
    JOIN departamentos d ON e.id_dept = d.id
) AS subconsulta
GROUP BY dept;
```

### Subconsulta en SELECT

```sql
SELECT 
    nombre,
    salario,
    (SELECT AVG(salario) FROM empleados) AS promedio_empresa
FROM empleados;
```

### Subconsultas correlacionadas

```sql
-- Subconsulta que depende de la consulta externa
SELECT e1.nombre, e1.salario
FROM empleados e1
WHERE e1.salario > (
    SELECT AVG(e2.salario)
    FROM empleados e2
    WHERE e2.id_dept = e1.id_dept
);
```

---

## 2. Funciones de Agregación

| Función | Descripción |
|---------|-------------|
| COUNT() | Cuenta filas |
| SUM() | Suma valores |
| AVG() | Calcula promedio |
| MIN() | Valor mínimo |
| MAX() | Valor máximo |

### Ejemplos

```sql
-- Contar empleados
SELECT COUNT(*) FROM empleados;              -- Todas las filas
SELECT COUNT(id) FROM empleados;              -- Solo no-NULL
SELECT COUNT(DISTINCT cargo) FROM empleados; -- Valores únicos

-- Sumar salarios
SELECT SUM(salario) FROM empleados;

-- Promedio
SELECT AVG(salario) FROM empleados;

-- Mínimo y máximo
SELECT MIN(salario), MAX(salario) FROM empleados;
```

---

## 3. GROUP BY y HAVING

### GROUP BY

```sql
-- Agrupar por departamento
SELECT 
    id_dept,
    COUNT(*) AS num_empleados,
    AVG(salario) AS salario_promedio,
    SUM(salario) AS total_salarios
FROM empleados
GROUP BY id_dept;
```

### Resultado

```
+-----------+---------------+------------------+---------------+
| id_dept   | num_empleados | salario_promedio | total_salarios|
+-----------+---------------+------------------+---------------+
|         1 |             2 |        77500.00  |     155000.00 |
|         2 |             2 |        60000.00  |     120000.00 |
+-----------+---------------+------------------+---------------+
```

### HAVING (filtro después de GROUP)

```sql
-- Departamentos con más de 1 empleado Y salario promedio > 65000
SELECT id_dept, COUNT(*) AS num_emp, AVG(salario) AS prom
FROM empleados
GROUP BY id_dept
HAVING COUNT(*) > 1 AND AVG(salario) > 65000;
```

### WHERE vs HAVING

| WHERE | HAVING |
|-------|---------|
| Filtra ANTES de agrupar | Filtra DESPUÉS de agrupar |
| Opera en filas individuales | Opera en grupos |
| No puede usar funciones de agregación | Sí puede usar funciones de agregación |

---

## 4. LIKE y Patrones

### Operador LIKE

```sql
-- Buscar nombres que empiecen con 'J'
SELECT nombre FROM empleados WHERE nombre LIKE 'J%';

-- Buscar nombres que terminen con 'z'
SELECT nombre FROM empleados WHERE nombre LIKE '%z';

-- Buscar que contenga 'ar'
SELECT nombre FROM empleados WHERE nombre LIKE '%ar%';

-- Comodín _: exactamente un carácter
SELECT nombre FROM empleados WHERE nombre LIKE 'J_u_n';  -- 'Juan'
```

### Caracteres comodín

| Comodín | Descripción | Ejemplo |
|---------|-------------|---------|
| `%` | Cero o más caracteres | 'J%' → Juan, Jorge, Javier |
| `_` | Un solo carácter | 'J_an' → Juan, Jorge |

### Busqueda con expresiones regulares (REGEXP)

```sql
-- Nombres que empiezan con vocal
SELECT nombre FROM empleados WHERE nombre REGEXP '^[aeiou]';

-- Nombres que terminan con consonante
SELECT nombre FROM empleados WHERE nombre REGEXP '[^aeiou]$';

-- Nombres con 'an' o 'en' o 'in'
SELECT nombre FROM empleados WHERE nombre REGEXP 'a|e|i]n';
```

---

## 5. BETWEEN e IN

### BETWEEN (rango)

```sql
-- Salario entre 50000 y 70000 (inclusive)
SELECT nombre, salario
FROM empleados
WHERE salario BETWEEN 50000 AND 70000;

-- Fechas en rango
SELECT *
FROM pedidos
WHERE fecha BETWEEN '2024-01-01' AND '2024-12-31';
```

### IN (lista de valores)

```sql
-- Empleados de departamentos específicos
SELECT nombre, id_dept
FROM empleados
WHERE id_dept IN (1, 2, 3);

-- Múltiples condiciones
SELECT *
FROM empleados
WHERE cargo IN ('Gerente', 'Director', 'Subdirector');
```

### NOT para negar

```sql
-- Salario FUERA del rango
SELECT nombre, salario
FROM empleados
WHERE salario NOT BETWEEN 50000 AND 70000;

-- Empleados de dept que NO son 1 ni 2
SELECT nombre, id_dept
FROM empleados
WHERE id_dept NOT IN (1, 2);
```

---

## 6. CASE y IF

### CASE simple

```sql
SELECT 
    nombre,
    cargo,
    CASE cargo
        WHEN 'Gerente' THEN 'Nivel 1'
        WHEN 'Director' THEN 'Nivel 2'
        WHEN 'Subdirector' THEN 'Nivel 3'
        ELSE 'Otro'
    END AS nivel_jerarquico
FROM empleados;
```

### CASE con condiciones

```sql
SELECT 
    nombre,
    salario,
    CASE 
        WHEN salario > 80000 THEN 'Alto'
        WHEN salario > 60000 THEN 'Medio'
        ELSE 'Bajo'
    END AS categoria_salario
FROM empleados;
```

### IF() función

```sql
SELECT 
    nombre,
    IF(salario > 70000, 'Premium', 'Regular') AS categoria
FROM empleados;
```

### IFNULL() y COALESCE()

```sql
-- Si el valor es NULL, usar替代值
SELECT 
    nombre,
    IFNULL(telefono, 'Sin teléfono') AS telefono
FROM empleados;

-- Primera no-NULL de la lista
SELECT 
    nombre,
    COALESCE(email, telefono, 'Sin contacto') AS contacto
FROM empleados;
```

---

## 📝 Resumen de Consultas Avanzadas

```
┌─────────────────────────────────────────────────────────────┐
│              OPERADORES Y FUNCIONES AVANZADAS              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PATRONES:                                                  │
│  ├─ LIKE 'patrón%'     → Comienza con                     │
│  ├─ LIKE '%patrón'     → Termina con                       │
│  ├─ LIKE '%patrón%'    → Contiene                          │
│  └─ REGEXP             → Expresiones regulares             │
│                                                             │
│  RANGOS:                                                    │
│  ├─ BETWEEN a AND b    → Entre a y b (inclusive)          │
│  └─ IN (a, b, c)      → En lista de valores               │
│                                                             │
│  CONDICIONALES:                                             │
│  ├─ CASE...WHEN...THEN → Múltiples condiciones             │
│  ├─ IF(cond, v1, v2)  → Si cond entonces v1 sino v2      │
│  └─ IFNULL(v1, v2)    → Si NULL usa v2                    │
│                                                             │
│  AGRUPACIÓN:                                                │
│  ├─ GROUP BY          → Agrupa resultados                  │
│  └─ HAVING            → Filtra después de GROUP BY        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## ➡️ [Volver al Índice del Módulo 3](01-estructura-bd-relacional.md)