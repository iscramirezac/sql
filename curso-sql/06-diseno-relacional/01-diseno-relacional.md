# Módulo 6: Diseño de Bases de Datos Relacionales

## 📋 Índice del Módulo

1. [Características de Diseños Relacionales](#1-características-de-diseños-relacionales)
2. [Dominios Atómicos y Primera Forma Normal](#2-dominios-atómicos-y-primera-forma-normal)
3. [Modelado de Datos](#3-modelado-de-datos)

---

## 1. Características de Diseños Relacionales

### 1.1 Propiedades de una Relación

```sql
-- Ejemplo de relación bien diseñada
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    salario DECIMAL(10,2) CHECK (salario > 0),
    id_departamento INT
);
```

**Características:**
- Cada celda contiene un solo valor (atómico)
- Cada columna tiene un nombre único
- No hay filas duplicadas
- El orden de filas no importa
- El orden de columnas no importa

### 1.2 Problemas del Mal Diseño

**Anomalía de inserción:**
- No se puede agregar un cliente sin un pedido

**Anomalía de eliminación:**
- Si se elimina el único pedido de un cliente, se pierde la información del cliente

**Anomalía de actualización:**
- Cambiar email de cliente requiere actualizar múltiples filas

```sql
-- ❌ MAL DISEÑO: Todo en una tabla
CREATE TABLE pedido_malo (
    id INT PRIMARY KEY,
    cliente_nombre VARCHAR(100),
    cliente_email VARCHAR(100),
    pedido_fecha DATE,
    producto_nombre VARCHAR(100),
    producto_cantidad INT
);
```

---

## 2. Dominios Atómicos y Primera Forma Normal

### 2.1 Dominios Atómicos

Un **dominio** es atómico si sus elementos son indivisibles.

```sql
-- ✅ CORRECTO: Dominios atómicos
CREATE TABLE empleado (
    id INT,
    nombre VARCHAR(100),      -- Atómico
    edad INT,                  -- Atómico
    salario DECIMAL(10,2)     -- Atómico
);
```

```sql
-- ❌ INCORRECTO: Dominios no atómicos
CREATE TABLE empleado_malo (
    id INT,
    nombre_completo VARCHAR(200),  -- Podría dividirse
    direccion TEXT,                 -- Podría dividirse
    telefonos TEXT                 -- Lista, no atómico
);
```

### 2.2 Primera Forma Normal (1FN)

Una tabla está en 1FN si todos los atributos son atómicos.

**Ejemplo de tabla NO en 1FN:**

```
┌────────────────────────────────────────────────────────────┐
│  ID │ NOMBRE       │ TELEFONOS                            │
├────────────────────────────────────────────────────────────┤
│  1  │ Juan García  │ 555-1234, 555-5678                  │
│  2  │ María López  │ 555-9999                             │
└────────────────────────────────────────────────────────────┘
     ↑ 
     └─ "teléfonos" contiene múltiples valores
```

**Transformación a 1FN:**

```sql
CREATE TABLE telefonos_empleado (
    id_empleado INT,
    telefono VARCHAR(20),
    PRIMARY KEY (id_empleado, telefono)
);

INSERT INTO telefonos_empleado VALUES
(1, '555-1234'),
(1, '555-5678'),
(2, '555-9999');
```

---

## 3. Modelado de Datos

### 3.1 Formas Normales

| Forma Normal | Requisito |
|--------------|-----------|
| 1FN | Dominios atómicos |
| 2FN | 1FN + dependencias funcionales completas |
| 3FN | 2FN + sin dependencias transitivas |
| BCNF | 3FN + toda determinante es clave candidata |

### 3.2 Segunda Forma Normal (2FN)

**Requisitos:**
- Estar en 1FN
- Todo atributo no clave depende completamente de la clave primaria

**Ejemplo de tabla NO en 2FN:**

```sql
CREATE TABLE pedido_detalle_malo (
    id_pedido INT,
    id_producto INT,
    nom_producto VARCHAR(100),    -- Depende solo de id_producto
    cantidad INT,
    PRIMARY KEY (id_pedido, id_producto)
);
```

**Problema:** `nom_producto` depende solo de `id_producto`, no de la clave completa.

**Solución:**

```sql
-- Tabla de pedidos
CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY,
    fecha_pedido DATE,
    id_cliente INT
);

-- Tabla de productos
CREATE TABLE producto (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100),
    precio DECIMAL(10,2)
);

-- Tabla de detalles (solo atributos que dependen de la clave)
CREATE TABLE detalle_pedido (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
```

### 3.3 Tercera Forma Normal (3FN)

**Requisitos:**
- Estar en 2FN
- No hay dependencias transitivas

**Ejemplo de tabla NO en 3FN:**

```sql
CREATE TABLE empleado_malo (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_departamento INT,
    nom_departamento VARCHAR(100),  -- Depende de id_departamento
    nom_gerente VARCHAR(100)        -- Depende de id_departamento
);
```

**Problema:** `nom_departamento` y `nom_gerente` dependen de `id_departamento`, no directamente de la clave.

**Solución:**

```sql
CREATE TABLE departamento (
    id_departamento INT PRIMARY KEY,
    nombre_departamento VARCHAR(100),
    nombre_gerente VARCHAR(100)
);

CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_departamento INT,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);
```

---

## 📝 Resumen de Formas Normales

```
┌─────────────────────────────────────────────────────────────┐
│              FORMAS NORMALES - RESUMEN                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1FN: Todos los valores son atómicos                       │
│       → Eliminar grupos repetidos                          │
│       → Crear tablas separadas para datos multivaloradas    │
│                                                             │
│  2FN: 1FN + dependencias funcionales completas             │
│       → Eliminar dependencias parciales                     │
│       → Crear tablas para atributos parcialmente dependientes│
│                                                             │
│  3FN: 2FN + sin dependencias transitivas                   │
│       → Eliminar dependencias transitivas                  │
│       → Mover atributos no clave a otras tablas            │
│                                                             │
│  BCNF: Toda determinante es clave candidata                │
│       → Descomposición sin pérdida                         │
│       → Dependencias funcionales más estrictas             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## ➡️ [Volver al Inicio del Curso](../../README.md)