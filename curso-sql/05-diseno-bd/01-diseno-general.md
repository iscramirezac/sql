# Módulo 5: Diseño de Bases de Datos y Modelo E-R

## 📋 Índice del Módulo

1. [Visión General del Proceso de Diseño](#1-visión-general-del-proceso-de-diseño)
2. [Diseño de Base de Datos](#2-diseño-de-base-de-datos)
3. [Reducción a Esquemas Relacionales](#3-reducción-a-esquemas-relacionales)

---

## 1. Visión General del Proceso de Diseño

### 1.1 Fases del Diseño

```
┌─────────────────────────────────────────────────────────────┐
│              PROCESO DE DISEÑO DE BD                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  FASE 1: RECOLECCIÓN Y ANÁLISIS DE REQUERIMIENTOS   │   │
│  │                                                     │   │
│  │  - Reuniones con usuarios                          │   │
│  │  - Documentar necesidades de información          │   │
│  │  - Identificar restricciones de negocio            │   │
│  └─────────────────────────────────────────────────────┘   │
│                          ↓                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  FASE 2: DISEÑO CONCEPTUAL                         │   │
│  │                                                     │   │
│  │  - Modelo E-R de alto nivel                        │   │
│  │  - Entidades, relaciones, atributos                │   │
│  │  - Independiente del SGBD                          │   │
│  └─────────────────────────────────────────────────────┘   │
│                          ↓                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  FASE 3: DISEÑO LÓGICO                             │   │
│  │                                                     │   │
│  │  - Transformar E-R a modelo relacional             │   │
│  │  - Definir tablas, claves, restricciones            │   │
│  │  - Normalización                                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                          ↓                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  FASE 4: DISEÑO FÍSICO                            │   │
│  │                                                     │   │
│  │  - Optimización de rendimiento                      │   │
│  │  - Creación de índices                              │   │
│  │  - Particionamiento                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Diseño de Base de Datos

### 2.1 Principios del Diseño

**Objetivos:**
- Minimizar redundancia de datos
- Evitar anomalías de actualización
- Garantizar integridad de datos
- Facilitar consultas eficientes

**Errores comunes:**
- Tablas con muchos atributos no relacionados
- Duplicación de información
- Claves mal definidas
- Falta de relaciones necesarias

### 2.2 Ejemplo de Diseño Incorrecto

```sql
-- ❌ MALA PRÁCTICA: Una tabla para todo
CREATE TABLE pedido_incorrecto (
    id_pedido INT,
    cliente_nombre VARCHAR(100),
    cliente_email VARCHAR(100),
    cliente_direccion VARCHAR(200),
    producto_nombre VARCHAR(100),
    producto_precio DECIMAL(10,2),
    cantidad INT,
    fecha_pedido DATE
);
```

**Problemas:**
- Si un cliente hace 5 pedidos, sus datos se repiten 5 veces
- Actualizar email del cliente requiere actualizar múltiples filas
- Inconsistencia de datos

### 2.3 Diseño Correcto (Normalizado)

```sql
-- ✅ BUENA PRÁCTICA: Tablas relacionadas
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    direccion VARCHAR(200)
);

CREATE TABLE producto (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2)
);

CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE detalle_pedido (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
```

---

## 3. Reducción a Esquemas Relacionales

### 3.1 Reglas de Transformación

| Elemento E-R | Transformación |
|--------------|---------------|
| Entidad fuerte | Una tabla |
| Relación 1:1 | FK en cualquiera de las tablas |
| Relación 1:N | FK en el lado "muchos" |
| Relación N:M | Tabla intermedia con FKs |
| Atributo simple | Columna en la tabla |
| Atributo multivalorado | Tabla separada |
| Generalización | Una tabla o múltiples tablas |

### 3.2 Ejemplo de Transformación

**Diagrama E-R:**

```
┌─────────┐         ┌─────────┐         ┌─────────┐
│ CLIENTE │ 1     N │ PEDIDO │ 1     N │PRODUCTO │
└─────────┘─────────└─────────┘─────────└─────────┘
```

**Transformación a SQL:**

```sql
-- Entidad CLIENTE
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100)
);

-- Entidad PRODUCTO
CREATE TABLE producto (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2)
);

-- Entidad PEDIDO (relación CLIENTE-PEDIDO: 1:N)
CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Entidad DETALLE_PEDIDO (relación PEDIDO-PRODUCTO: N:M)
CREATE TABLE detalle_pedido (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
```

---

## 📝 Resumen

- **Diseño en fases:** Conceptual → Lógico → Físico
- **Principios:** Normalización, evitar redundancia
- **Transformación E-R a Relacional:** Entidades→Tablas, Relaciones→FKs o tablas intermedias
- **Normalización:** Organizar datos para minimizar duplicación

---

## ➡️ Próximo Módulo

[Módulo 6: Diseño de Bases de Datos Relacionales](06-diseno-relacional/01-diseno-relacional.md)