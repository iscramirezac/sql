# SQL: DDL - Lenguaje de Definición de Datos

## 📋 Contenido

1. [CREATE DATABASE](#1-create-database---crear-base-de-datos)
2. [DROP DATABASE](#2-drop-database---eliminar-base-de-datos)
3. [CREATE TABLE](#3-create-table---crear-tablas)
4. [DROP TABLE](#4-drop-table---eliminar-tablas)
5. [ALTER TABLE](#5-alter-table---modificar-tablas)
6. [Restricciones](#6-restricciones-constraints)

---

## 1. CREATE DATABASE - Crear Base de Datos

### Sintaxis básica

```sql
CREATE DATABASE nombre_base_datos;
```

### Ejemplos

```sql
-- Crear una nueva base de datos
CREATE DATABASE empresa_db;

-- Crear si no existe (evita error)
CREATE DATABASE IF NOT EXISTS empresa_db;

-- Especificar conjunto de caracteres
CREATE DATABASE empresa_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
```

### Verificar creación

```sql
-- Listar bases de datos
SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| empresa_db         |
| test               |
+--------------------+
```

---

## 2. DROP DATABASE - Eliminar Base de Datos

### Sintaxis

```sql
DROP DATABASE nombre_base_datos;
```

### Ejemplos

```sql
-- Eliminar base de datos
DROP DATABASE empresa_db;

-- Eliminar si existe (evita error)
DROP DATABASE IF EXISTS empresa_db;
```

> ⚠️ **PELIGRO:** Esta operación es IRREVERSIBLE. Todos los datos se eliminan permanentemente.

---

## 3. CREATE TABLE - Crear Tablas

### Sintaxis básica

```sql
CREATE TABLE nombre_tabla (
    nombre_columna1 tipo_dato restricciones,
    nombre_columna2 tipo_dato restricciones,
    ...
);
```

### Ejemplo completo

```sql
CREATE TABLE empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    salario DECIMAL(10,2) CHECK (salario > 0),
    id_departamento INT,
    fecha_contratacion DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id)
);
```

### Resultado de creación

```sql
DESCRIBE empleados;
+------------------+---------------+------+-----+---------+----------------+
| Field            | Type          | Null | Key | Default | Extra          |
+------------------+---------------+------+-----+---------+----------------+
| id               | int(11)       | NO   | PRI | NULL    | auto_increment |
| nombre           | varchar(100)  | NO   |     | NULL    |                |
| email            | varchar(100)  | YES  | UNI | NULL    |                |
| telefono         | varchar(20)   | YES  |     | NULL    |                |
| salario          | decimal(10,2) | YES  |     | NULL    |                |
| id_departamento  | int(11)       | YES  | MUL | NULL    |                |
| fecha_contratacion| date         | YES  |     | curdate()|               |
+------------------+---------------+------+-----+---------+----------------+
```

### Crear tabla desde otra tabla

```sql
-- Clonar estructura
CREATE TABLE empleados_backup LIKE empleados;

-- Clonar estructura y datos
CREATE TABLE empleados_respaldo
SELECT * FROM empleados WHERE 1=0;  -- Sin datos ( WHERE 1=0 )
```

---

## 4. DROP TABLE - Eliminar Tablas

### Sintaxis

```sql
DROP TABLE nombre_tabla;
```

### Ejemplos

```sql
-- Eliminar tabla
DROP TABLE empleados;

-- Eliminar solo si existe
DROP TABLE IF EXISTS empleados;

-- Eliminar tabla y datos (más rápido que DROP)
TRUNCATE TABLE empleados;
```

> ⚠️ **PELIGRO:** TRUNCATE elimina todos los datos pero mantiene la estructura.

---

## 5. ALTER TABLE - Modificar Tablas

### Añadir columnas

```sql
ALTER TABLE empleados
ADD COLUMN telefono VARCHAR(20) AFTER email,
ADD COLUMN activo BOOLEAN DEFAULT TRUE;
```

### Modificar columnas

```sql
-- Cambiar tipo de dato
ALTER TABLE empleados
MODIFY COLUMN salario DECIMAL(12,2);

-- Renombrar columna
ALTER TABLE empleados
CHANGE COLUMN nombre nombre_completo VARCHAR(150);
```

### Eliminar columnas

```sql
ALTER TABLE empleados
DROP COLUMN telefono;
```

### Añadir restricciones

```sql
-- Añadir Primary Key
ALTER TABLE empleados
ADD PRIMARY KEY (id);

-- Añadir Foreign Key
ALTER TABLE empleados
ADD FOREIGN KEY (id_dept) REFERENCES departamentos(id);

-- Añadir Unique
ALTER TABLE empleados
ADD UNIQUE (email);
```

### Eliminar restricciones

```sql
-- Eliminar Primary Key
ALTER TABLE empleados
DROP PRIMARY KEY;

-- Eliminar Foreign Key
ALTER TABLE empleados
DROP FOREIGN KEY empleado_ibfk_1;
```

---

## 6. Restricciones (Constraints)

### PRIMARY KEY - Clave Primaria

```sql
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    ...
);

-- O fuera de la definición de columnas
CREATE TABLE empleados (
    id INT,
    nombre VARCHAR(100),
    PRIMARY KEY (id)
);

-- Clave compuesta
CREATE TABLE pedidos (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_pedido, id_producto)
);
```

### FOREIGN KEY - Clave Foránea

```sql
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id)
        ON DELETE CASCADE      -- Eliminar empleados si se borra dept
        ON UPDATE SET NULL     -- Set NULL si cambia ID del dept
);
```

### Opciones de ON DELETE/UPDATE

| Opción | Descripción |
|--------|-------------|
| CASCADE | Elimina/actualiza filas relacionadas |
| SET NULL | Pone NULL en las columnas FK |
| RESTRICT | Previene eliminación/actualización |
| NO ACTION | Igual que RESTRICT |

### CHECK - Restricción de validación

```sql
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT CHECK (edad >= 18),
    salario DECIMAL(10,2) CHECK (salario > 0),
    genero CHAR(1) CHECK (genero IN ('M', 'F'))
);
```

### NOT NULL - No permite valores nulos

```sql
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,    -- Obligatorio
    email VARCHAR(100),                -- Opcional (puede ser NULL)
    telefono VARCHAR(20) NOT NULL     -- Obligatorio
);
```

### UNIQUE - Valores únicos

```sql
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,        -- Un solo email único
    rfc VARCHAR(13) UNIQUE
);

-- Multiple columnas únicas
CREATE TABLE usuarios_roles (
    usuario_id INT,
    rol_id INT,
    UNIQUE KEY uk_usuario_rol (usuario_id, rol_id)
);
```

### DEFAULT - Valor por defecto

```sql
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### AUTO_INCREMENT - Incremento automático

```sql
CREATE TABLE empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

-- Iniciar desde un valor específico
ALTER TABLE empleados AUTO_INCREMENT = 1000;
```

---

## 📝 Resumen de Constraints

| Restricción | Propósito | Ejemplo |
|-------------|-----------|---------|
| PRIMARY KEY | Identificador único | id INT PRIMARY KEY |
| FOREIGN KEY | Referencia a otra tabla | FK(id_dept) REFERENCES dept |
| NOT NULL | Campo obligatorio | nombre VARCHAR(100) NOT NULL |
| UNIQUE | Valor único en columna | email VARCHAR(100) UNIQUE |
| CHECK | Validación de datos | CHECK (edad >= 18) |
| DEFAULT | Valor predeterminado | estado VARCHAR(20) DEFAULT 'ACTIVO' |
| AUTO_INCREMENT | Incremento automático | id INT AUTO_INCREMENT |

---

## ➡️ Próximo Tema

[SQL: Tipos de Datos](06-tipos-datos.md)