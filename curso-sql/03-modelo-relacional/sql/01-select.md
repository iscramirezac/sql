# SQL: SELECT y Consultas Básicas

## 📋 Contenido

1. [SELECT básico](#1-select-básico)
2. [SELECT DISTINCT](#2-select-distinct)
3. [WHERE - Filtrado de filas](#3-where---filtrado-de-filas)
4. [Operadores AND, OR, NOT](#4-operadores-and-or-not)
5. [ORDER BY - Ordenamiento](#5-order-by---ordenamiento)
6. [LIMIT - Limitar resultados](#6-limit---limitar-resultados)

---

## 1. SELECT básico

La instrucción **SELECT** se utiliza para seleccionar datos de una base de datos.

### Sintaxis básica

```sql
SELECT columna1, columna2, ...
FROM nombre_tabla;
```

### Ejemplos prácticos

```sql
-- Seleccionar todas las columnas
SELECT * FROM empleados;

-- Seleccionar columnas específicas
SELECT nombre, cargo, salario FROM empleados;

-- Seleccionar con expresiones calculadas
SELECT 
    nombre, 
    salario,
    salario * 1.10 AS salario_nuevo  -- Aumento del 10%
FROM empleados;
```

### Resultado de ejemplo

```sql
SELECT nombre, cargo, salario FROM empleados;
+-------------+------------------+----------+
| nombre      | cargo            | salario  |
+-------------+------------------+----------+
| Juan García | Ingeniero        | 75000.00 |
| María López | Analista         | 65000.00 |
| Pedro Martínez| Gerente        | 85000.00 |
| Ana Hernández| Diseñador       | 55000.00 |
+-------------+------------------+----------+
4 rows in set (0.01 sec)
```

### Alias de columnas

```sql
-- Usar AS para renombrar columnas
SELECT 
    nombre AS "Nombre del Empleado",
    cargo AS "Puesto",
    salario AS "Salario Mensual"
FROM empleados;
```

---

## 2. SELECT DISTINCT

**SELECT DISTINCT** devuelve solo valores únicos (elimina duplicados).

### Sintaxis

```sql
SELECT DISTINCT columna1, columna2, ...
FROM nombre_tabla;
```

### Ejemplos

```sql
-- Obtener cargos únicos
SELECT DISTINCT cargo FROM empleados;

-- Obtener combinación única de departamento y ciudad
SELECT DISTINCT id_departamento, ciudad 
FROM empleados;
```

### Resultado

```sql
SELECT DISTINCT cargo FROM empleados;
+------------------+
| cargo            |
+------------------+
| Ingeniero        |
| Analista         |
| Gerente          |
| Diseñador       |
+------------------+
4 rows in set (0.00 sec)
```

### Comparación con y sin DISTINCT

```sql
-- Sin DISTINCT (muestra todos)
SELECT cargo FROM empleados;
+------------------+
| cargo            |
+------------------+
| Ingeniero        |
| Analista         |
| Gerente          |
| Diseñador       |
| Ingeniero        |  ← duplicado
+------------------+

-- Con DISTINCT (solo únicos)
SELECT DISTINCT cargo FROM empleados;
+------------------+
| cargo            |
+------------------+
| Ingeniero        |
| Analista         |
| Gerente          |
| Diseñador       |
+------------------+
```

---

## 3. WHERE - Filtrado de filas

La cláusula **WHERE** filtra registros según una condición específica.

### Sintaxis

```sql
SELECT columna1, columna2, ...
FROM nombre_tabla
WHERE condición;
```

### Operadores de comparación

| Operador | Descripción |
|----------|-------------|
| `=` | Igual |
| `<>` o `!=` | Diferente |
| `>` | Mayor que |
| `<` | Menor que |
| `>=` | Mayor o igual |
| `<=` | Menor o igual |

### Ejemplos

```sql
-- Filtrar por igual
SELECT * FROM empleados WHERE id = 1;

-- Filtrar por mayor que
SELECT * FROM empleados WHERE salario > 60000;

-- Filtrar por diferente
SELECT * FROM empleados WHERE cargo <> 'Gerente';

-- Filtrar por rango
SELECT * FROM empleados WHERE salario >= 50000 AND salario <= 80000;
```

### Resultado de ejemplo

```sql
SELECT * FROM empleados WHERE salario > 70000;
+----+-------------+-----------+----------+-----------+
| id | nombre      | cargo     | salario  | id_dept   |
+----+-------------+-----------+----------+-----------+
|  1 | Juan García | Ingeniero | 75000.00 |         1 |
|  3 | Pedro Martínez| Gerente  | 85000.00 |         1 |
+----+-------------+-----------+----------+-----------+
```

---

## 4. Operadores AND, OR, NOT

### AND - AND lógico

```sql
-- Ambas condiciones deben ser verdaderas
SELECT * FROM empleados 
WHERE cargo = 'Ingeniero' AND salario > 70000;
```

### OR - O lógico

```sql
-- Al menos una condición debe ser verdadera
SELECT * FROM empleados 
WHERE cargo = 'Gerente' OR cargo = 'Director';
```

### NOT - Negación lógica

```sql
-- Invierte la condición
SELECT * FROM empleados 
WHERE NOT cargo = 'Gerente';
```

### Combinación de operadores

```sql
-- AND y OR juntos (AND tiene prioridad)
SELECT * FROM empleados 
WHERE (cargo = 'Ingeniero' OR cargo = 'Analista') 
  AND salario >= 60000;

-- Uso de NOT con otras condiciones
SELECT * FROM empleados 
WHERE NOT (cargo = 'Gerente' OR cargo = 'Director');
```

### Tabla de verdad

| A | B | A AND B | A OR B | NOT A |
|---|---|----------|--------|-------|
| TRUE | TRUE | TRUE | TRUE | FALSE |
| TRUE | FALSE | FALSE | TRUE | FALSE |
| FALSE | TRUE | FALSE | TRUE | TRUE |
| FALSE | FALSE | FALSE | FALSE | TRUE |

---

## 5. ORDER BY - Ordenamiento

Ordena los resultados por una o más columnas.

### Sintaxis

```sql
SELECT columna1, columna2, ...
FROM nombre_tabla
ORDER BY columna1 [ASC|DESC], columna2 [ASC|DESC], ...;
```

### Ejemplos

```sql
-- Orden ascendente (por defecto)
SELECT * FROM empleados ORDER BY nombre;

-- Orden descendente
SELECT * FROM empleados ORDER BY salario DESC;

-- Múltiples columnas
SELECT * FROM empleados 
ORDER BY cargo ASC, salario DESC;

-- Orden por expresión
SELECT * FROM empleados 
ORDER BY LENGTH(nombre);  -- Por longitud del nombre
```

### Resultado

```sql
SELECT * FROM empleados ORDER BY salario DESC;
+----+-----------------+-----------+----------+-----------+
| id | nombre          | cargo     | salario  | id_dept   |
+----+-----------------+-----------+----------+-----------+
|  3 | Pedro Martínez  | Gerente   | 85000.00 |         1 |
|  1 | Juan García     | Ingeniero | 75000.00 |         1 |
|  2 | María López     | Analista  | 65000.00 |         2 |
|  4 | Ana Hernández    | Diseñador | 55000.00 |         3 |
+----+-----------------+-----------+----------+-----------+
```

---

## 6. LIMIT - Limitar resultados

Limita el número de filas devueltas.

### Sintaxis (MySQL/MariaDB)

```sql
SELECT columna1, columna2, ...
FROM nombre_tabla
LIMIT [offset,] número_filas;
```

### Ejemplos

```sql
-- Obtener los primeros 5 empleados
SELECT * FROM empleados LIMIT 5;

-- Obtener 5 empleados, comenzando desde el registro 10
SELECT * FROM empleados LIMIT 10, 5;

-- Top 3 con mayor salario
SELECT * FROM empleados ORDER BY salario DESC LIMIT 3;
```

### Resultado

```sql
SELECT * FROM empleados ORDER BY salario DESC LIMIT 3;
+----+-----------------+-----------+----------+-----------+
| id | nombre          | cargo     | salario  | id_dept   |
+----+-----------------+-----------+----------+-----------+
|  3 | Pedro Martínez  | Gerente   | 85000.00 |         1 |
|  1 | Juan García     | Ingeniero | 75000.00 |         1 |
|  2 | María López     | Analista  | 65000.00 |         2 |
+----+-----------------+-----------+----------+-----------+
```

---

## 📝 Ejercicios Prácticos

```sql
-- Ejercicio 1: Mostrar empleados del departamento 1
SELECT * FROM empleados WHERE id_dept = 1;

-- Ejercicio 2: Mostrar empleados con salario entre 50000 y 70000
SELECT * FROM empleados WHERE salario BETWEEN 50000 AND 70000;

-- Ejercicio 3: Mostrar nombre y salario aumentado 15%
SELECT nombre, salario * 1.15 AS salario_aumentado 
FROM empleados WHERE cargo = 'Ingeniero';

-- Ejercicio 4: Top 5 de empleados mejor pagados
SELECT * FROM empleados ORDER BY salario DESC LIMIT 5;
```

---

## ➡️ Próximo Tema

[SQL: INSERT, UPDATE, DELETE](02-dml.md)