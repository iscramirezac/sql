# SQL: JOINs - Consultas con Múltiples Tablas

## 📋 Contenido

1. [Introducción a JOINs](#1-introducción-a-joins)
2. [INNER JOIN](#2-inner-join)
3. [LEFT JOIN](#3-left-join)
4. [RIGHT JOIN](#4-right-join)
5. [FULL JOIN](#5-full-join)
6. [CROSS JOIN](#6-cross-join)
7. [SELF JOIN](#7-self-join)

---

## 1. Introducción a JOINs

Los **JOINs** combinan filas de dos o más tablas basándose en una relación entre ellas.

```
┌─────────────────────────────────────────────────────────────────┐
│                    TIPOS DE JOIN                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                                                          │   │
│  │    Tabla A         Tabla B                               │   │
│  │   ┌───────┐      ┌───────┐                              │   │
│  │   │ 1     │      │ A     │                              │   │
│  │   │ 2     │      │ B     │                              │   │
│  │   │ 3     │      │ C     │                              │   │
│  │   └───────┘      └───────┘                              │   │
│  │                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  INNER JOIN:  Intersección (A ∩ B)                             │
│  LEFT JOIN:   Todo A + lo que coincida de B                    │
│  RIGHT JOIN:  Todo B + lo que coincida de A                   │
│  FULL JOIN:   Unión (A ∪ B)                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. INNER JOIN

Devuelve solo las filas que tienen coincidencia en ambas tablas.

### Sintaxis

```sql
SELECT columnas
FROM tabla1
INNER JOIN tabla2 ON tabla1.columna_común = tabla2.columna_común;
```

### Ejemplo

```sql
-- Tables setup
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_dept INT,
    FOREIGN KEY (id_dept) REFERENCES departamentos(id)
);

CREATE TABLE departamentos (
    id INT PRIMARY KEY,
    nombre_dept VARCHAR(50)
);

INSERT INTO departamentos VALUES 
(1, 'IT'), (2, 'Ventas'), (3, 'Recursos Humanos');

INSERT INTO empleados VALUES 
(1, 'Juan García', 1),
(2, 'María López', 2),
(3, 'Pedro Martínez', 1),
(4, 'Ana Hernández', NULL);  -- Sin departamento
```

### INNER JOIN en acción

```sql
SELECT e.nombre, e.cargo, d.nombre_dept
FROM empleados e
INNER JOIN departamentos d ON e.id_dept = d.id;
```

### Resultado

```
+------------------+-----------+-------------+
| nombre           | cargo     | nombre_dept |
+------------------+-----------+-------------+
| Juan García      | Ingeniero | IT          |
| María López      | Vendedor  | Ventas      |
| Pedro Martínez   | Desarrollador| IT        |
+------------------+-----------+-------------+
3 rows in set (0.00 sec)
```

> **Nota:** Ana Hernández no aparece porque NO tiene departamento asignado (NULL).

---

## 3. LEFT JOIN

Devuelve todas las filas de la tabla izquierda, más las coincidencias de la tabla derecha.

### Sintaxis

```sql
SELECT columnas
FROM tabla1
LEFT JOIN tabla2 ON tabla1.columna_común = tabla2.columna_común;
```

### LEFT JOIN en acción

```sql
SELECT e.nombre, e.cargo, d.nombre_dept
FROM empleados e
LEFT JOIN departamentos d ON e.id_dept = d.id;
```

### Resultado

```
+------------------+-----------+-------------+
| nombre           | cargo     | nombre_dept |
+------------------+-----------+-------------+
| Juan García      | Ingeniero | IT          |
| María López      | Vendedor  | Ventas      |
| Pedro Martínez   | Desarrollador| IT       |
| Ana Hernández    | Contador  | NULL        |  ← Incluida!
+------------------+-----------+-------------+
4 rows in set (0.00 sec)
```

> **Nota:** Ana Hernández aparece ahora, con NULL en nombre_dept porque no tiene departamento.

### LEFT JOIN con filtro

```sql
-- Empleados SIN departamento
SELECT e.nombre, e.cargo
FROM empleados e
LEFT JOIN departamentos d ON e.id_dept = d.id
WHERE d.id IS NULL;
```

---

## 4. RIGHT JOIN

Devuelve todas las filas de la tabla derecha, más las coincidencias de la tabla izquierda.

### Sintaxis

```sql
SELECT columnas
FROM tabla1
RIGHT JOIN tabla2 ON tabla1.columna_común = tabla2.columna_común;
```

### RIGHT JOIN en acción

```sql
-- Añadir departamento sin empleados
INSERT INTO departamentos VALUES (4, 'Contabilidad');

SELECT e.nombre, d.nombre_dept
FROM empleados e
RIGHT JOIN departamentos d ON e.id_dept = d.id;
```

### Resultado

```
+------------------+-------------+
| nombre           | nombre_dept |
+------------------+-------------+
| Juan García      | IT          |
| Pedro Martínez   | IT          |
| María López      | Ventas      |
| NULL             | Contabilidad|  ← Dept sin empleados
+------------------+-------------+
4 rows in set (0.00 sec)
```

> **Nota:** "Contabilidad" aparece aunque no tiene empleados.

---

## 5. FULL JOIN

Devuelve todas las filas cuando hay coincidencia en cualquiera de las tablas.

### Sintaxis

```sql
SELECT columnas
FROM tabla1
FULL OUTER JOIN tabla2 ON tabla1.columna_común = tabla2.columna_común;
```

> **Nota:** MySQL/MariaDB no soporta FULL JOIN directamente, se simula con UNION.

### FULL JOIN simulado

```sql
SELECT e.nombre, d.nombre_dept
FROM empleados e
LEFT JOIN departamentos d ON e.id_dept = d.id

UNION

SELECT e.nombre, d.nombre_dept
FROM empleados e
RIGHT JOIN departamentos d ON e.id_dept = d.id;
```

### Resultado

```
+------------------+-------------+
| nombre           | nombre_dept |
+------------------+-------------+
| Juan García      | IT          |
| Pedro Martínez   | IT          |
| María López      | Ventas      |
| Ana Hernández    | NULL        |
| NULL             | Contabilidad|
+------------------+-------------+
```

---

## 6. CROSS JOIN

Producto cartesiano de ambas tablas (todas las combinaciones).

### Sintaxis

```sql
SELECT columnas
FROM tabla1
CROSS JOIN tabla2;
```

### Ejemplo

```sql
SELECT e.nombre, d.nombre_dept
FROM empleados e
CROSS JOIN departamentos d;
```

### Resultado

```
+------------------+-------------+
| nombre           | nombre_dept |
+------------------+-------------+
| Juan García      | IT          |
| Juan García      | Ventas      |
| Juan García      | Contabilidad│
| María López      | IT          |
| María López      | Ventas      |
| María López      | Contabilidad│
| ...              | ...         |
+------------------+-------------+
12 rows (4 empleados × 3 dept)
```

---

## 7. SELF JOIN

Une una tabla consigo misma.

### Ejemplo: Empleados y sus gerentes

```sql
-- Tabla de empleados con referencia a gerente
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_gerente INT,
    FOREIGN KEY (id_gerente) REFERENCES empleados(id)
);

INSERT INTO empleados VALUES
(1, 'Director General', NULL),
(2, 'Gerente de IT', 1),
(3, 'Gerente de Ventas', 1),
(4, 'Desarrollador Senior', 2),
(5, 'Diseñador', 2),
(6, 'Vendedor', 3);
```

### SELF JOIN

```sql
SELECT 
    e.nombre AS empleado,
    g.nombre AS gerente
FROM empleados e
LEFT JOIN empleados g ON e.id_gerente = g.id;
```

### Resultado

```
+------------------+------------------+
| empleado         | gerente          |
+------------------+------------------+
| Director General | NULL             |
| Gerente de IT    | Director General |
| Gerente de Ventas| Director General |
| Desarrollador Sr | Gerente de IT    |
| Diseñador        | Gerente de IT    |
| Vendedor         | Gerente de Ventas|
+------------------+------------------+
```

---

## 📝 Resumen Visual

```
┌─────────────────────────────────────────────────────────────┐
│                    RESUMEN DE JOINS                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Tabla A      INNER JOIN     Tabla B                        │
│  ┌───┐    =    ┌───┐∩┌───┐   =   ┌───┐                    │
│  │ 1 │        │ 1 │  │ A │       │ A │                    │
│  │ 2 │        │ 2 │  └───┘       └───┘                    │
│  └───┘        └───┘                                        │
│                                                             │
│  Tabla A      LEFT JOIN      Tabla B                         │
│  ┌───┐    =    ┌───┐∪┌───┐   =   ┌───┐                    │
│  │ 1 │        │ 1 │  │ A │       │ A │                    │
│  │ 2 │        │ 2 │  │ 3 │       │ 3 │ (nullable)          │
│  │ 3 │        │ 3 │  └───┘       └───┘                    │
│  └───┘        └───┘                                        │
│                                                             │
│  Tabla A     RIGHT JOIN      Tabla B                         │
│  ┌───┐    =    ┌───┐∪┌───┐   =   ┌───┐                    │
│  │ A │        │ 1 │  │ A │       │ 1 │                    │
│  └───┘        │ 2 │  └───┘       └───┘                    │
│              │ A │                                        │
│              └───┘                                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## ➡️ Próximo Tema

[SQL: UNION y operadores de conjunto](04-union.md)