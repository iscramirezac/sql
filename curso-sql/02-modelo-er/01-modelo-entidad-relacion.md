# Módulo 2: Modelo Entidad-Relación

## 📋 Índice del Módulo

1. [Entidades, Relaciones y Atributos](#1-entidades-relaciones-y-atributos)
2. [Restricciones y Asignación](#2-restricciones-y-asignación)
3. [Claves](#3-claves)
4. [Diagramas E-R y Reducción a Tablas](#4-diagramas-er-y-reducción-a-tablas)
5. [Generalización](#5-generalización)
6. [Agregación](#6-agregación)

---

## 1. Entidades, Relaciones y Atributos

### 1.1 Entidades

Una **entidad** representa un objeto del mundo real que puede identificarse de forma única y del cual almacenamos información.

**Ejemplos de entidades:**

| Entidad | Instancias posibles |
|---------|---------------------|
| EMPLEADO | Juan García, María López, Pedro Martínez |
| PRODUCTO | Laptop Dell, Mouse Inalámbrico, Teclado |
| CLIENTE | Empresa ABC, Juan Pérez, María González |
| DEPARTAMENTO | Ventas, Contabilidad, Recursos Humanos |

**Representación en Diagrama E-R:**

```
┌─────────────┐
│   EMPLEADO  │
└─────────────┘
     │
     │ Representa
     │
     ▼
┌─────────────────────────────────────┐
│  Juan García                        │
│  ID: 1001                           │
│  Cargo: Ingeniero de Software       │
│  Salario: $75,000                   │
└─────────────────────────────────────┘
```

**Características de las entidades:**
- Tienen atributos que las describen
- Cada instancia tiene un identificador único
- Pueden relacionarse con otras entidades
- Las entidades del mismo tipo forman un **conjunto de entidades**

### 1.2 Atributos

Los **atributos** son las características o propiedades que describen a una entidad.

**Tipos de Atributos:**

```
┌─────────────────────────────────────────────────────────────────┐
│                        TIPOS DE ATRIBUTOS                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  SIMPLES vs COMPUESTOS                                          │
│  ────────────────────                                           │
│  simple:     sexo (M/F)                                         │
│  compuesto:  dirección (calle, ciudad, código postal)           │
│                                                                 │
│  UNIVALORADOS vs MULTIVALORADOS                                 │
│  ─────────────────────────                                      │
│  univalorado: fecha_nacimiento                                  │
│  multivalorado: teléfonos (casa, trabajo, móvil)               │
│                                                                 │
│  DERIVADOS                                                      │
│  ──────────                                                     │
│  derivado: edad (se deriva de fecha_nacimiento)                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Ejemplo de atributos en una entidad:**

```
┌─────────────────┐
│    EMPLEADO     │
├─────────────────┤
│  ● id (PK)      │  ← Atributo clave
│  ● nombre       │  ← Atributo simple
│  ● fecha_nac    │  ← Atributo simple
│  ● dirección    │  ← Atributo compuesto
│  │   ├─ calle   │
│  │   ├─ ciudad  │
│  │   └─ cp      │
│  ● teléfonos    │  ← Atributo multivalorado
│  ● edad         │  ← Atributo derivado
└─────────────────┘
```

### 1.3 Relaciones

Una **relación** describe una asociación entre dos o más entidades.

**Ejemplo: Relación entre EMPLEADO y PROYECTO**

```
┌─────────────┐                        ┌─────────────┐
│  EMPLEADO   │────── TRABAJA EN ─────▶│   PROYECTO  │
└─────────────┘                        └─────────────┘
     │                                       │
     │  Juan García ──▶ │ Proyecto Website  │
     │  María López ──▶ │ Proyecto Mobile   │
     │  Pedro Martínez ─▶│ Proyecto Website  │
```

**Grado de una relación:**

| Grado | Descripción | Ejemplo |
|-------|-------------|---------|
| **Binaria** | Une dos entidades | EMPLEADO-TRABAJA EN-PROYYECTO |
| **Ternaria** | Une tres entidades | EMPLEADO-TRABAJA EN-PROYYECTO con ROL |
| **n-aria** | Une n entidades | Complexa |

**Ejemplo de relación ternaria:**

```
                 ┌─────────────┐
                 │   PROYECTO  │
                 └──────┬──────┘
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│  EMPLEADO   │ │    ROL      │ │  CLIENTE    │
└─────────────┘ └─────────────┘ └─────────────┘
                        │
                        │  ASIGNA
                        │
                        ▼
              ┌─────────────────┐
              │ ASIGNACIÓN      │
              │ (Relación n-aria)│
              └─────────────────┘
```

---

## 2. Restricciones y Asignación

### 2.1 Restricciones de Cardinalidad

Las **restricciones de cardinalidad** especifican el número máximo de instancias de una entidad que pueden relacionarse con una instancia de otra entidad.

```
┌─────────────────────────────────────────────────────────────────┐
│                  RESTRICCIONES DE CARDINALIDAD                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  UNO A UNO (1:1)                                                │
│  ─────────────────                                              │
│  Un empleado tiene un escritorio                                │
│  Un escritorio pertenece │
│                                                                 │
│    ┌──────── a un empleado                        ─┐         ASIGNADO_A         ┌──────────┐        │
│    │EMPLEADO │◀──────────────────────────▶│ESCRITORIO│        │
│    └─────────┘                           └──────────┘        │
│                                                                 │
│  UNO A MUCHOS (1:N)                                             │
│  ───────────────────                                             │
│  Un departamento tiene muchos empleados                         │
│  Un empleado pertenece a un departamento                        │
│                                                                 │
│    ┌───────────┐        PERTENECE_A       ┌─────────────┐     │
│    │DEPARTAMENTO│◀────────────────────────│  EMPLEADO   │     │
│    └───────────┘                          └─────────────┘     │
│                                                                 │
│  MUCHOS A MUCHOS (N:M)                                          │
│  ─────────────────────                                          │
│  Un empleado puede trabajar en muchos proyectos                 │
│  Un proyecto puede tener muchos empleados                       │
│                                                                 │
│    ┌─────────┐        TRABAJA_EN         ┌─────────────┐       │
│    │EMPLEADO │◀────────────────────────▶│  PROYECTO   │       │
│    └─────────┘                          └─────────────┘       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Restricciones de Participación

La **participación** especifica si la existencia de una entidad depende de otra.

**Participación total (obligatoria):**
```
┌─────────────────────────────────────────┐
│    EMPLEADO ════════════ TRABAJA EN     │
│                  ─────────────────      │
│              PROYECTO                   │
└─────────────────────────────────────────┘
→ Todo empleado DEBE trabajar en un proyecto
→ Todo proyecto DEBE tener al menos un empleado
```

**Participación parcial (opcional):**
```
┌─────────────────────────────────────────┐
│    EMPLEADO ──────────── GESTIONA       │
│                  - - - - - - -          │
│              DEPARTAMENTO                │
└─────────────────────────────────────────┘
→ Un empleado PUEDE gestionar un departamento
→ Un departamento PUEDE tener un gerente
```

### 2.3 Atributos en Relaciones

Las relaciones también pueden tener atributos:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│    ┌─────────┐                       ┌─────────────┐        │
│    │EMPLEADO │────── TRABAJA EN ─────▶│  PROYECTO  │        │
│    └─────────┘                       └─────────────┘        │
│                        │                                     │
│                        │                                     │
│                        ▼                                     │
│                ┌───────────────┐                             │
│                │   horas       │  ← Atributo de relación    │
│                │   rol         │                             │
│                └───────────────┘                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Ejemplo en datos:**

| Empleado | Proyecto | Horas | Rol |
|----------|----------|-------|-----|
| Juan García | Website | 120 | Desarrollador |
| María López | Website | 80 | Diseñadora |
| Pedro Martínez | Mobile | 200 | Líder técnico |

---

## 3. Claves

### 3.1 Tipos de Claves

```
┌─────────────────────────────────────────────────────────────────┐
│                        TIPOS DE CLAVES                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ SUPERCLAVE                                               │  │
│  │ Conjunto de atributos que identifican unívocamente       │  │
│  │ una entidad                                             │  │
│  │ Ejemplo: {id}, {id, nombre}, {id, nombre, email}        │  │
│  └──────────────────────────────────────────────────────────┘  │
│                           │                                    │
│                           ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ CLAVE CANDIDATA                                         │  │
│  │ Superclave mínima (sin atributos redundantes)          │  │
│  │ Ejemplo: {id}                                           │  │
│  │ Cada clave candidata puede ser identificador único     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                           │                                    │
│                           ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ CLAVE PRIMARIA (Primary Key - PK)                       │  │
│  │ Clave candidata seleccionada como identificador        │  │
│  │ principal de la entidad                                 │  │
│  │ Ejemplo: id                                             │  │
│  └──────────────────────────────────────────────────────────┘  │
│                           │                                    │
│                           ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ CLAVE FORÁNEA (Foreign Key - FK)                        │  │
│  │ Atributo que referencia la clave primaria de otra       │  │
│  │ entidad                                                 │  │
│  │ Ejemplo: dept_id en EMPLEADO referencing DEPARTAMENTO    │  │
│  └──────────────────────────────────────────────────────────┘  │
│                           │                                    │
│                           ▼                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ CLAVE COMPUESTA                                         │  │
│  │ Clave formada por múltiples atributos                   │  │
│  │ Ejemplo: {codigo_curso, semestre}                       │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Ejemplo de Claves

```sql
-- Tabla EMPLEADO
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,           -- CLAVE PRIMARIA
    curp VARCHAR(18) UNIQUE,               -- CLAVE CANDIDATA (alternativa)
    rfc VARCHAR(13) UNIQUE,                 -- CLAVE CANDIDATA (alternativa)
    nombre VARCHAR(100),
    email VARCHAR(100),
    id_departamento INT,                   -- CLAVE FORÁNEA
    FOREIGN KEY (id_departamento) 
        REFERENCES departamento(id_departamento)
);
```

### 3.3 Claves en Relaciones

**Para relación 1:N:**
```sql
-- La clave foránea va en el lado "muchos"
CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_departamento INT,  -- FK a DEPARTAMENTO
    FOREIGN KEY (id_departamento) 
        REFERENCES departamento(id_departamento)
);
```

**Para relación N:M:**
```sql
-- Se crea una tabla intermedia con ambas claves foráneas
CREATE TABLE trabaja_en (
    id_empleado INT,
    id_proyecto INT,
    horas_trabajadas INT,
    rol VARCHAR(50),
    PRIMARY KEY (id_empleado, id_proyecto),  -- CLAVE COMPUESTA
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_proyecto) REFERENCES proyecto(id_proyecto)
);
```

---

## 4. Diagramas E-R y Reducción a Tablas

### 4.1 Notación de Chen

```
┌─────────────────────────────────────────────────────────────────┐
│                    NOTACIÓN DE CHEN                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ENTIDAD:          ┌─────────┐                                  │
│                    │  ENTIDAD│                                  │
│                    └─────────┘                                  │
│                                                                 │
│  RELACIÓN:       ────────────                                    │
│                  │ RELACIÓN │                                   │
│                  ────────────                                    │
│                                                                 │
│  ATRIBUTOS:      ● atributo_simple                              │
│                  (atributo)                                      │
│                  * atributo_clave                               │
│                  ○ atributo_derivado                             │
│                  ▪ atributo_multivalorado                       │
│                                                                 │
│  CARDINALIDAD:   │  1       N                                    │
│                  ───<  │  ────                                   │
│                        │                                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Ejemplo completo:**

```
                              *id_dept
                       ┌──────────────────┐
                       │    DEPARTAMENTO  │
                       │                  │
                       │    (nombre)      │
                       │    [ubicación]   │
                       └────────┬─────────┘
                                │
                                │ 1
                                │
                ┌───────────────┼───────────────┐
                │               │               │
                ▼               │               ▼
        ┌─────────────┐        │       ┌─────────────┐
        │  GERENTE    │        │       │  EMPLEADO   │
        │             │        │       │             │
        └─────────────┘        │       │ *id_emp     │
                               │       │ (nombre)    │
                               │       │ (salario)   │
                               │       └─────────────┘
                               │               │ N
                               └───────────────┘
```

### 4.2 Reducción a Tablas

**Entidades fuertes → Tablas:**

```sql
-- Entidad DEPARTAMENTO
CREATE TABLE departamento (
    id_dept INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(100)
);

-- Entidad EMPLEADO
CREATE TABLE empleado (
    id_emp INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2),
    id_dept INT,
    FOREIGN KEY (id_dept) REFERENCES departamento(id_dept)
);
```

**Relaciones N:M → Tabla:**

```sql
-- Relación TRABAJA_EN (N:M)
CREATE TABLE proyecto (
    id_proy INT PRIMARY KEY,
    nombre VARCHAR(100),
    presupuesto DECIMAL(15,2)
);

CREATE TABLE emp_proy (
    id_emp INT,
    id_proy INT,
    horas INT,
    PRIMARY KEY (id_emp, id_proy),
    FOREIGN KEY (id_emp) REFERENCES empleado(id_emp),
    FOREIGN KEY (id_proy) REFERENCES proyecto(id_proy)
);
```

**Atributos de relaciones:**

```sql
-- Si la relación tiene atributos, van en la tabla de la relación
CREATE TABLE emp_proy (
    id_emp INT,
    id_proy INT,
    horas INT,           -- Atributo de la relación
    rol VARCHAR(50),      -- Atributo de la relación
    fecha_asignacion DATE,
    PRIMARY KEY (id_emp, id_proy),
    FOREIGN KEY (id_emp) REFERENCES empleado(id_emp),
    FOREIGN KEY (id_proy) REFERENCES proyecto(id_proy)
);
```

---

## 5. Generalización

### 5.1 Concepto de Generalización

La **generalización** es el proceso de identificar atributos comunes entre entidades para crear una entidad más general (superclase).

```
┌─────────────────────────────────────────────────────────────────┐
│                    GENERALIZACIÓN                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│                    ┌───────────────┐                            │
│                    │   PERSONA     │  ← SUPERCLASE              │
│                    ├───────────────┤                            │
│                    │ id_persona    │                            │
│                    │ nombre        │                            │
│                    │ fecha_nac     │                            │
│                    └───────┬───────┘                            │
│                           │                                     │
│           ┌───────────────┼───────────────┐                     │
│           │               │               │                     │
│           ▼               ▼               ▼                     │
│    ┌────────────┐  ┌────────────┐  ┌────────────┐               │
│    │  CLIENTE   │  │ EMPLEADO   │  │ PROVEEDOR  │  ← SUBCLASES  │
│    ├────────────┤  ├────────────┤  ├────────────┤               │
│    │ rfc        │  │ salario    │  │ productos  │               │
│    │-credito   │  │ puesto     │  ││            │               │
│    └────────────┘  └────────────┘  └────────────┘               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 5.2 Tipos de Generalización

**Total:** Cada instancia de la superclase debe ser instancia de exactamente una subclase.

**Parcial:** Una instancia de la superclase puede no pertenecer a ninguna subclase.

```
┌─────────────────────────────────────────────────────────────┐
│  GENERALIZACIÓN TOTAL            GENERALIZACIÓN PARCIAL     │
│  ───────────────────────         ────────────────────       │
│                                                             │
│     ┌─────────────┐                 ┌─────────────┐         │
│     │   PERSONA   │                 │   PERSONA   │         │
│     └──────┬──────┘                 └──────┬──────┘         │
│            │                            │                  │
│    ┌───────┴───────┐            ┌───────┴───────┐          │
│    │               │            │               │          │
│    ▼               ▼            ▼               ▼          │
│ ┌──────┐      ┌──────┐     ┌──────┐      ┌──────┐         │
│ │FÍSICA│      │MORAL │     │FÍSICA│      │MORAL │         │
│ └──────┘      └──────┘     └──────┘      └──────┘         │
│    │                           │                            │
│    │ 100% cobertura            │  Cobertura parcial        │
│    ▼                           ▼                            │
│   SON TODOS                PUEDEN EXISTIR                  │
│                           PERSONAS que no son              │
│                           NI FÍSICAS NI MORALES            │
└─────────────────────────────────────────────────────────────┘
```

### 5.3 Implementación de Generalización

**Opción 1: Una sola tabla con discriminador**

```sql
CREATE TABLE persona (
    id_persona INT PRIMARY KEY,
    nombre VARCHAR(100),
    fecha_nac DATE,
    tipo_persona ENUM('FISICA', 'MORAL') NOT NULL,
    
    -- Atributos de CLIENTE
    rfc VARCHAR(18),
    limite_credito DECIMAL(10,2),
    
    -- Atributos de EMPLEADO
    salario DECIMAL(10,2),
    puesto VARCHAR(50),
    
    -- Atributos de PROVEEDOR
    productos TEXT,
    
    CHECK (
        (tipo_persona = 'FISICA' AND rfc IS NOT NULL AND limite_credito IS NOT NULL) OR
        (tipo_persona = 'MORAL' AND rfc IS NOT NULL) OR
        (tipo_persona = 'EMPLEADO' AND salario IS NOT NULL AND puesto IS NOT NULL) OR
        (tipo_persona = 'PROVEEDOR' AND productos IS NOT NULL)
    )
);
```

**Opción 2: Una tabla por subclase (más limpia)**

```sql
-- Tabla base
CREATE TABLE persona (
    id_persona INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_nac DATE,
    tipo ENUM('FISICA', 'MORAL') NOT NULL
);

-- Subclase CLIENTE
CREATE TABLE cliente (
    id_persona INT PRIMARY KEY,
    rfc VARCHAR(18) NOT NULL,
    limite_credito DECIMAL(10,2),
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);

-- Subclase PROVEEDOR
CREATE TABLE proveedor (
    id_persona INT PRIMARY KEY,
    productos TEXT,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona)
);
```

---

## 6. Agregación

### 6.1 Concepto de Agregación

La **agregación** es una forma de agrupar entidades relacionadas en una entidad compuesta.

```
┌─────────────────────────────────────────────────────────────────┐
│                    AGREGACIÓN                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Ejemplo: AGREGADO PEDIDO                                       │
│  ─────────────────────────                                      │
│                                                                 │
│     ┌─────────────────────────────────────────────────┐        │
│     │              AGREGADO PEDIDO                     │        │
│     │  ┌─────────┐    ┌─────────┐    ┌─────────┐     │        │
│     │  │ LINEA   │───▶│ PEDIDO  │◀───│ CLIENTE │     │        │
│     │  │ PEDIDO  │    │         │    │         │     │        │
│     │  └─────────┘    └─────────┘    └─────────┘     │        │
│     │                                                 │        │
│     │  Atributos del agregado:                        │        │
│     │  - fecha_pedido                                 │        │
│     │  - estado                                       │        │
│     │  - total                                        │        │
│     └─────────────────────────────────────────────────┘        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 6.2 Agregación vs Relación

```
┌─────────────────────────────────────────────────────────────┐
│                    COMPARACIÓN                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  RELACIÓN SIMPLE           AGREGACIÓN                       │
│  ───────────────          ───────────                       │
│                                                             │
│  ┌─────────┐             ┌─────────────────────┐           │
│  │EMPLEADO │──────┐      │   ┌─────────┐       │           │
│  └─────────┘      │      │   │PROYECTO │       │           │
│                   ▼      │   └─────────┘       │           │
│              ┌─────────┐ │        ▲             │           │
│              │ CONTROL │ │        │             │           │
│              │ GERENCIAL││   ┌─────────┐       │           │
│              └─────────┘ │   │ GERENTE  │       │           │
│                            │   └─────────┘       │           │
│                            └─────────────────────┘           │
│                                   │                            │
│                                   ▼                            │
│                            ┌─────────────┐                     │
│                            │   REPORTE   │                     │
│                            │   DE        │                     │
│                            │   GERENCIA  │                     │
│                            └─────────────┘                     │
└─────────────────────────────────────────────────────────────┘
```

### 6.3 Ejemplo de Implementación

```sql
-- Entidades base
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE producto (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2)
);

-- Pedido como agregado
CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATE NOT NULL,
    estado ENUM('PENDIENTE', 'PROCESADO', 'ENVIADO', 'ENTREGADO'),
    total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- Líneas de pedido (parte del agregado)
CREATE TABLE linea_pedido (
    id_pedido INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);
```

---

## 📝 Resumen del Módulo

En este módulo hemos aprendido:

1. **Entidades:** Objetos del mundo real con atributos
2. **Relaciones:** Asociaciones entre entidades con cardinalidad
3. **Atributos:** Propiedades simples, compuestas, multivaloradas y derivadas
4. **Claves:** Superclaves, candidatas, primarias, foráneas y compuestas
5. **Restricciones:** Cardinalidad y participación en relaciones
6. **Diagramas E-R:** Notación y símbolos para modelado
7. **Generalización:** Herencia entre entidades (superclases y subclases)
8. **Agregación:** Agrupación de entidades relacionadas

---

## ➡️ Próximo Módulo

[Módulo 3: Modelo Relacional](03-modelo-relacional/01-estructura-bd-relacional.md)