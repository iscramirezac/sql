# SQL: DML - Manipulación de Datos

## 📋 Contenido

1. [INSERT INTO - Insertar datos](#1-insert-into---insertar-datos)
2. [UPDATE - Actualizar datos](#2-update---actualizar-datos)
3. [DELETE - Eliminar datos](#3-delete---eliminar-datos)
4. [INSERT INTO SELECT](#4-insert-into-select)

---

## 1. INSERT INTO - Insertar datos

### Sintaxis básica

```sql
INSERT INTO nombre_tabla (columna1, columna2, ...)
VALUES (valor1, valor2, ...);
```

### Insertar una fila

```sql
-- Insertar valores en todas las columnas
INSERT INTO empleados VALUES (1, 'Juan García', 'Ingeniero', 75000.00, 1);

-- Insertar valores en columnas específicas
INSERT INTO empleados (id, nombre, cargo, salario) 
VALUES (2, 'María López', 'Analista', 65000.00);
```

### Resultado

```sql
INSERT INTO empleados VALUES (2, 'María López', 'Analista', 65000.00, 2);
Query OK, 1 row affected (0.00 sec)

SELECT * FROM empleados WHERE id = 2;
+----+-------------+----------+----------+---------+
| id | nombre      | cargo    | salario  | id_dept |
+----+-------------+----------+----------+---------+
|  2 | María López | Analista | 65000.00 |       2 |
+----+-------------+----------+----------+---------+
```

### Insertar múltiples filas

```sql
INSERT INTO empleados (id, nombre, cargo, salario, id_dept) VALUES
(3, 'Pedro Martínez', 'Gerente', 85000.00, 1),
(4, 'Ana Hernández', 'Diseñador', 55000.00, 2),
(5, 'Carlos Ruiz', 'Desarrollador', 70000.00, 1);
```

### Insertar con SELECT

```sql
-- Copiar datos de otra tabla
INSERT INTO empleados_respaldo 
SELECT * FROM empleados WHERE id_dept = 1;
```

---

## 2. UPDATE - Actualizar datos

### Sintaxis básica

```sql
UPDATE nombre_tabla
SET columna1 = valor1, columna2 = valor2, ...
WHERE condición;
```

### Actualizar una columna

```sql
-- Aumentar salario a un empleado específico
UPDATE empleados 
SET salario = 80000.00 
WHERE id = 1;
```

### Resultado

```sql
UPDATE empleados SET salario = 80000.00 WHERE id = 1;
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

SELECT * FROM empleados WHERE id = 1;
+----+-------------+-----------+----------+---------+
| id | nombre      | cargo     | salario  | id_dept |
+----+-------------+-----------+----------+---------+
|  1 | Juan García | Ingeniero | 80000.00 |       1 |
+----+-------------+-----------+----------+---------+
```

### Actualizar múltiples columnas

```sql
-- Actualizar salario y departamento
UPDATE empleados 
SET salario = salario * 1.10,  -- Aumento del 10%
    id_dept = 1                  -- Cambiar al dept 1
WHERE cargo = 'Gerente';
```

### Actualizar con condiciones complejas

```sql
-- Aumentar salario según condiciones
UPDATE empleados 
SET salario = CASE
    WHEN cargo = 'Gerente' THEN salario * 1.15
    WHEN cargo = 'Ingeniero' THEN salario * 1.10
    ELSE salario * 1.05
END
WHERE id_dept = 1;
```

### ⚠️ Peligro: Actualizar sin WHERE

```sql
-- ¡Esto actualiza TODOS los registros!
UPDATE empleados SET salario = 50000;
-- WARNING: Afectará todas las filas
```

---

## 3. DELETE - Eliminar datos

### Sintaxis básica

```sql
DELETE FROM nombre_tabla
WHERE condición;
```

### Eliminar filas específicas

```sql
-- Eliminar un empleado específico
DELETE FROM empleados WHERE id = 5;
```

### Resultado

```sql
DELETE FROM empleados WHERE id = 5;
Query OK, 1 row affected (0.00 sec)

SELECT * FROM empleados;
+----+-----------------+-----------+----------+---------+
| id | nombre          | cargo     | salario  | id_dept |
+----+-----------------+-----------+----------+---------+
|  1 | Juan García     | Ingeniero | 80000.00 |       1 |
|  2 | María López     | Analista  | 65000.00 |       2 |
|  3 | Pedro Martínez  | Gerente   | 85000.00 |       1 |
|  4 | Ana Hernández   | Diseñador | 55000.00 |       2 |
+----+-----------------+-----------+----------+---------+
```

### Eliminar con subconsulta

```sql
-- Eliminar empleados de departamentos inactivos
DELETE FROM empleados 
WHERE id_dept IN (
    SELECT id FROM departamentos WHERE activo = 0
);
```

### ⚠️ Peligro: Eliminar sin WHERE

```sql
-- ¡Esto elimina TODOS los registros!
DELETE FROM empleados;
-- WARNING: La tabla quedará vacía
```

---

## 4. INSERT INTO SELECT

### Copiar datos entre tablas

```sql
-- Crear respaldo de empleados del dept 1
INSERT INTO empleados_backup 
SELECT * FROM empleados WHERE id_dept = 1;
```

### Copiar con transformación

```sql
-- Crear tabla de resumen
INSERT INTO dept_salarios (departamento, total_empleados, salario_promedio)
SELECT 
    id_dept,
    COUNT(*),
    AVG(salario)
FROM empleados 
GROUP BY id_dept;
```

---

## 📝 Resumen de DML

| Comando | Descripción | Peligro |
|---------|-------------|---------|
| INSERT | Añade nuevas filas | Ninguno |
| UPDATE | Modifica filas existentes | ¡Usar WHERE! |
| DELETE | Elimina filas | ¡Usar WHERE! |
| TRUNCATE | Elimina todas las filas (más rápido) | ¡Irreversible! |

---

## ➡️ Próximo Tema

[SQL: JOINs - Consultas con múltiples tablas](03-joins.md)