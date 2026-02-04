# Módulo 8: Sistemas Relacionales y Extendidos

## 📋 Índice del Módulo

1. [Modelo de Datos Basado en la Lógica](#1-modelo-de-datos-basado-en-la-lógica)
2. [Normalización](#2-normalización)
3. [Modelo Relacional Anidado](#3-modelo-relacional-anidado)
4. [Sistemas Expertos de Bases de Datos](#4-sistemas-expertos-de-bases-de-datos)

---

## 1. Modelo de Datos Basado en la Lógica

### 1.1 Niveles del Modelo de Datos

```
┌─────────────────────────────────────────────────────────────┐
│            MODELO DE DATOS BASADO EN LÓGICA                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           MODELO CONCEPTUAL (Externo)              │   │
│  │                                                     │   │
│  │  Vista del usuario:                                 │   │
│  │  "Yo veo los empleados con sus departamentos"      │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │             MODELO LÓGICO                          │   │
│  │                                                     │   │
│  │  Estructura abstracta independiente del SGBD:      │   │
│  │  - Entidades                                       │   │
│  │  - Atributos                                       │   │
│  │  - Relaciones                                      │   │
│  │  - Restricciones                                   │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              MODELO FÍSICO                          │   │
│  │                                                     │   │
│  │  Implementación específica:                          │   │
│  │  - Archivos                                        │   │
│  │  - Índices                                         │   │
│  │  - Métodos de acceso                               │   │
│  │  - Organización física                              │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Modelo Conceptual

```sql
-- Representación conceptual de una empresa
-- Entidades: EMPLEADO, DEPARTAMENTO, PROYECTO
-- Relaciones: EMPLEADO trabaja_en DEPARTAMENTO
--             EMPLEADO participa_en PROYECTO

-- Reglas de negocio:
-- 1. Cada empleado pertenece a un departamento
-- 2. Un departamento tiene muchos empleados
-- 3. Un proyecto puede tener muchos empleados
```

### 1.3 Modelo Lógico

```sql
-- Transformación del modelo conceptual al lógico relacional
-- Tabla EMPLEADO
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(100),
    cargo VARCHAR(50),
    salario DECIMAL(10,2),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id)
);

-- Tabla DEPARTAMENTO
CREATE TABLE departamento (
    id INT PRIMARY KEY,
    nombre_dept VARCHAR(50),
    presupuesto DECIMAL(15,2)
);
```

### 1.4 Modelo Físico

```sql
-- Implementación física específica (MySQL/MariaDB)

-- Crear tablespace
CREATE TABLESPACE ts_datos 
    ADD DATAFILE 'datos.ibd';

-- Particionamiento por rango
CREATE TABLE empleado_partition (
    id INT,
    nombre VARCHAR(100),
    fecha_contratacion DATE
)
PARTITION BY RANGE (YEAR(fecha_contratacion)) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Índices para optimización
CREATE INDEX idx_empleado_nombre ON empleado(nombre);
CREATE INDEX idx_empleado_salario ON empleado(salario);
```

---

## 2. Normalización

### 2.1 Primera Forma Normal (1FN)

```sql
-- ❌ Tabla NO en 1FN (valores no atómicos)
CREATE TABLE cliente_mal (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    telefonos VARCHAR(500)  -- '555-1234,555-5678,555-9012'
);

-- ✅ Tabla EN 1FN
CREATE TABLE cliente (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE cliente_telefono (
    id_cliente INT,
    telefono VARCHAR(20),
    PRIMARY KEY (id_cliente, telefono),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);
```

### 2.2 Segunda Forma Normal (2FN)

```sql
-- ❌ NO en 2FN (dependencia parcial de clave compuesta)
CREATE TABLE pedido_detalle_mal (
    id_pedido INT,
    id_producto INT,
    nom_producto VARCHAR(100),    -- Depende solo de id_producto
    cantidad INT,
    precio_unitario DECIMAL(10,2), -- Depende solo de id_producto
    PRIMARY KEY (id_pedido, id_producto)
);

-- ✅ EN 2FN
CREATE TABLE producto (
    id_producto INT PRIMARY KEY,
    nom_producto VARCHAR(100),
    precio_unitario DECIMAL(10,2)
);

CREATE TABLE pedido_detalle (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
```

### 2.3 Tercera Forma Normal (3FN)

```sql
-- ❌ NO en 3FN (dependencia transitiva)
CREATE TABLE empleado_mal (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_departamento INT,
    nom_departamento VARCHAR(50),  -- Depende de id_departamento
    nom_gerente VARCHAR(100)       -- Depende de id_departamento
);

-- ✅ EN 3FN
CREATE TABLE departamento (
    id_departamento INT PRIMARY KEY,
    nombre_dept VARCHAR(50),
    nombre_gerente VARCHAR(100)
);

CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);
```

### 2.4 Forma Normal de Boyce-Codd (BCNF)

```sql
-- BCNF: Todo determinante es clave candidata
-- Más estricta que 3FN

-- ❌ NO en BCNF
CREATE TABLE asignacion_curso_mal (
    id_profesor INT,
    especialidad VARCHAR(50),
    id_curso INT,
    nivel VARCHAR(20),
    -- Un profesor tiene una especialidad
    -- Un curso tiene un nivel específico
    -- Pero no hay clave única clara
    PRIMARY KEY (id_profesor, id_curso)
);

-- ✅ EN BCNF
CREATE TABLE profesor (
    id_profesor INT PRIMARY KEY,
    especialidad VARCHAR(50)
);

CREATE TABLE curso (
    id_curso INT PRIMARY KEY,
    nivel VARCHAR(20)
);

CREATE TABLE asignacion_curso (
    id_profesor INT,
    id_curso INT,
    PRIMARY KEY (id_profesor, id_curso),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso)
);
```

### 2.5 Desnormalización

```sql
-- Desnormalización: Introducir redundancia controlada
-- para mejorar rendimiento

-- Tabla normalizada
CREATE TABLE orden (
    id_orden INT PRIMARY KEY,
    id_cliente INT,
    fecha DATE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);

CREATE TABLE orden_detalle (
    id_orden INT,
    id_producto INT,
    cantidad INT,
    precio DECIMAL(10,2)
);

-- Tabla desnormalizada (denormalizada)
CREATE TABLE orden_con_info (
    id_orden INT PRIMARY KEY,
    id_cliente INT,
    nombre_cliente VARCHAR(100),   -- redundancy, pero evita JOIN
    fecha DATE,
    ciudad_cliente VARCHAR(50),     -- redundancy
    -- Datos repetidos para evitar joins
    total_orden DECIMAL(10,2)      -- stored aggregate
);
```

---

## 3. Modelo Relacional Anidado

### 3.1 Datos Complejos en SQL

```sql
-- PostgreSQL: Tipos compuestos
CREATE TYPE direccion_type AS (
    calle VARCHAR(200),
    ciudad VARCHAR(100),
    cp VARCHAR(10),
    pais VARCHAR(50)
);

CREATE TABLE empleado_complex (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    direccion direccion_type,      -- Tipo anidado
    telefonos TEXT[]               -- Array
);

-- Insertar datos anidados
INSERT INTO empleado_complex VALUES (
    1,
    'Juan García',
    ROW('Calle 123', 'Ciudad de México', '01000', 'México')::direccion_type,
    ARRAY['555-1234', '555-5678']::TEXT[]
);

-- Consultar datos anidados
SELECT 
    nombre,
    (direccion).ciudad,
    (direccion).cp,
    telefonos[1] AS telefono_principal
FROM empleado_complex;
```

### 3.2 JSON en MySQL/MariaDB

```sql
-- MySQL 8.0+: JSON como tipo de dato
CREATE TABLE pedido_json (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    datos JSON,                    -- Datos flexibles
    productos JSON,                -- Array de productos
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar JSON
INSERT INTO pedido_json (cliente_id, datos, productos) VALUES
(1, 
 '{"nombre": "Juan García", "email": "juan@email.com"}',
 '[{"id": 1, "cantidad": 2}, {"id": 2, "cantidad": 1}]'
);

-- Consultar JSON
SELECT 
    cliente_id,
    JSON_UNQUOTE(datos->'$.nombre') AS nombre_cliente,
    JSON_EXTRACT(productos, '$[0].id') AS primer_producto,
    JSON_QUERY(productos, '$[*]') AS todos_productos
FROM pedido_json;
```

### 3.3 XML en SQL

```sql
-- Oracle/MySQL: Soporte XML
CREATE TABLE documento_xml (
    id INT PRIMARY KEY,
    contenido XMLTYPE
);

-- Insertar XML
INSERT INTO documento_xml VALUES (
    1,
    '<empleado>
        <nombre>Juan García</nombre>
        <departamento>TI</departamento>
        <salario>75000</salario>
    </empleado>'
);

-- Consultar XML (Oracle)
SELECT 
    EXTRACT(contenido, '/empleado/nombre').GETSTRINGVAL() AS nombre,
    EXTRACT(contenido, '/empleado/salario').GETNUMBERVAL() AS salario
FROM documento_xml;
```

---

## 4. Sistemas Expertos de Bases de Datos

### 4.1 Concepto

Los **sistemas expertos** incorporan reglas de conocimiento para la toma de decisiones inteligentes en las bases de datos.

```
┌─────────────────────────────────────────────────────────────┐
│            SISTEMA EXPERTO DE BASE DE DATOS               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              INTERFAZ DE USUARIO                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           MOTOR DE INFERENCIA                       │   │
│  │  ┌───────────────────────────────────────────────┐ │   │
│  │  │            BASE DE CONOCIMIENTO               │ │   │
│  │  │  IF salario > 80000 THEN categoria = 'Alto'  │ │   │
│  │  │  IF antiguedad > 5 THEN bono = 10%           │ │   │
│  │  └───────────────────────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │             BASE DE DATOS                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Implementación con Triggers

```sql
-- Sistema experto para evaluar crédito

-- Tabla de reglas
CREATE TABLE reglas_credito (
    id_regla INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    condicion TEXT,
    accion VARCHAR(50),
    prioridad INT
);

INSERT INTO reglas_credito (nombre, condicion, accion, prioridad) VALUES
('Salario Alto', 'salario_mensual > 50000', 'AUTO_APROBAR', 1),
('Salario Medio', 'salario_mensual BETWEEN 30000 AND 50000', 'REVISAR', 2),
('Salario Bajo', 'sueldo_mensual < 30000', 'REQUIERE_GARANTIA', 3),
('Historial Bueno', 'score_crediticio > 700', 'APROBAR', 1),
('Historial Malo', 'score_crediticio < 500', 'RECHAZAR', 1);

-- Motor de inferencia (procedimiento almacenado)
DELIMITER //
CREATE PROCEDURE sp_evaluar_credito(IN cliente_id INT)
BEGIN
    DECLARE v_salario DECIMAL(10,2);
    DECLARE v_score INT;
    DECLARE v_resultado VARCHAR(50);
    
    -- Obtener datos del cliente
    SELECT salario_mensual, score_crediticio 
    INTO v_salario, v_score
    FROM cliente 
    WHERE id = cliente_id;
    
    -- Aplicar reglas (motor de inferencia)
    IF v_salario > 50000 THEN
        SET v_resultado = 'AUTO_APROBAR';
    ELSEIF v_score > 700 THEN
        SET v_resultado = 'APROBAR';
    ELSEIF v_score < 500 THEN
        SET v_resultado = 'RECHAZAR';
    ELSE
        SET v_resultado = 'REQUIERE_REVISION';
    END IF;
    
    UPDATE cliente 
    SET estado_credito = v_resultado 
    WHERE id = cliente_id;
    
    SELECT v_resultado AS decision;
END //
DELIMITER ;
```

---

## 📝 Resumen del Módulo

- **Modelo en 3 niveles:** Conceptual → Lógico → Físico
- **Normalización:** 1FN, 2FN, 3FN, BCNF para eliminar redundancia
- **Desnormalización:** Introducir redundancia para rendimiento
- **Datos complejos:** Tipos anidados, JSON, XML
- **Sistemas expertos:** Reglas de negocio + Motor de inferencia

---

## ➡️ Próximo Módulo

[Módulo 9: Bases de Datos Distribuidas](09-bd-distribuidas/01-bd-distribuidas.md)