# SQL: Tipos de Datos

## 📋 Contenido

1. [Tipos Numéricos](#1-tipos-numéricos)
2. [Tipos de Cadena/String](#2-tipos-de-cadenastring)
3. [Tipos de Fecha y Hora](#3-tipos-de-fecha-y-hora)
4. [Tipos Booleanos y Otros](#4-tipos-booleanos-y-otros)

---

## 1. Tipos Numéricos

### Números Enteros

| Tipo | Rango | Uso |
|------|-------|-----|
| TINYINT | -128 a 127 | Valores pequeños |
| SMALLINT | -32,768 a 32,767 | Números pequeños |
| MEDIUMINT | -8,388,608 a 8,388,607 | Números medianos |
| INT | -2,147,483,648 a 2,147,483,647 | Enteros estándar |
| BIGINT | -9,223,372,036,854,775,808 a 9,223,372,036,854,775,807 | Enteros grandes |

### Ejemplos

```sql
CREATE TABLE ejemplo_enteros (
    edad TINYINT,              -- 0-255 sin signo
    contador INT,
    identificador BIGINT       -- Para IDs grandes
);

INSERT INTO ejemplo_enteros VALUES (25, 1000, 9999999999999);
```

### Números Decimales

| Tipo | Descripción | Precisión |
|------|-------------|-----------|
| DECIMAL(p,s) | Número decimal exacto | p=precision, s=escalas |
| NUMERIC(p,s) | Igual que DECIMAL | p=precision, s=escalas |
| FLOAT | Coma flotante (aproximado) | ~7 dígitos |
| DOUBLE | Coma flotante doble | ~15 dígitos |

### Ejemplos

```sql
CREATE TABLE ejemplo_decimales (
    precio DECIMAL(10,2),      -- 99999999.99 máximo
    porcentaje FLOAT(5,2),     -- Porcentaje con 2 decimales
    distancia DOUBLE            -- Alta precisión científica
);

INSERT INTO ejemplo_decimales VALUES (199.99, 15.50, 1234.56789012345);
```

### Números con Signo y Sin Signo

```sql
CREATE TABLE ejemplos_signo (
    positivo INT UNSIGNED,      -- Solo 0 a 4,294,967,295
    negativo INT,               -- Con signo (-2B a 2B)
    numero_tiny TINYINT UNSIGNED -- 0 a 255
);
```

---

## 2. Tipos de Cadena/String)

### Tipos de Texto

| Tipo | Longitud máxima | Uso |
|------|----------------|-----|
| CHAR(n) | 0-255 caracteres | Longitud fija |
| VARCHAR(n) | 0-65,535 caracteres | Longitud variable |
| TINYTEXT | 255 bytes | Texto pequeño |
| TEXT | 65,535 bytes | Texto largo |
| MEDIUMTEXT | 16,777,215 bytes | Texto mediano |
| LONGTEXT | 4,294,967,295 bytes | Texto muy largo |

### CHAR vs VARCHAR

```sql
-- CHAR: Longitud fija, completa con espacios
CHAR(10) para 'Juan' → 'Juan      ' (10 chars)

-- VARCHAR: Longitud variable, no completa
VARCHAR(10) para 'Juan' → 'Juan' (4 chars)
```

### Ejemplos

```sql
CREATE TABLE ejemplo_cadenas (
    codigo CHAR(5),                    -- 'ABC12' siempre 5 chars
    nombre VARCHAR(100),               -- Nombres hasta 100 chars
    descripcion TEXT,                  -- Descripciones largas
    biografia MEDIUMTEXT              -- Textos largos
);

INSERT INTO ejemplo_cadenas VALUES 
('ABC12', 'Juan García', 'Desarrollador con 10 años de experiencia...', 'Biografía completa...');
```

### Conjuntos de Caracteres (Charset)

```sql
-- Especificar charset
CREATE TABLE ejemplo_charset (
    nombre VARCHAR(100) CHARACTER SET utf8mb4,
    texto_espanol TEXT COLLATE utf8mb4_unicode_ci
);
```

---

## 3. Tipos de Fecha y Hora

| Tipo | Formato | Rango |
|------|---------|-------|
| DATE | 'YYYY-MM-DD' | '1000-01-01' a '9999-12-31' |
| TIME | 'HH:MM:SS' | '-838:59:59' a '838:59:59' |
| DATETIME | 'YYYY-MM-DD HH:MM:SS' | '1000-01-01' a '9999-12-31' |
| TIMESTAMP | 'YYYY-MM-DD HH:MM:SS' | '1970-01-01' a '2038-01-09' |
| YEAR | 'YYYY' | 1901 a 2155 |

### Ejemplos

```sql
CREATE TABLE ejemplo_fechas (
    fecha_nacimiento DATE,
    hora_entrada TIME,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultima_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    anio YEAR
);

INSERT INTO ejemplo_fechas VALUES 
('1990-05-15', '08:30:00', NULL, NULL, 2024);
```

### Funciones de fecha/hora

```sql
-- Obtener fecha/hora actual
SELECT CURRENT_DATE();    -- '2024-01-15'
SELECT CURRENT_TIME();    -- '14:30:00'
SELECT NOW();            -- '2024-01-15 14:30:00'
SELECT CURRENT_TIMESTAMP(); -- '2024-01-15 14:30:00'

-- Operaciones con fechas
SELECT DATE_ADD('2024-01-15', INTERVAL 30 DAY);     -- '2024-02-14'
SELECT DATE_SUB('2024-01-15', INTERVAL 1 MONTH);   -- '2023-12-15'
SELECT DATEDIFF('2024-02-15', '2024-01-15');       -- 31 días
SELECT TIMESTAMPDIFF(DAY, '2024-01-15', '2024-02-15'); -- 31 días

-- Extraer partes de fecha
SELECT YEAR('2024-01-15');    -- 2024
SELECT MONTH('2024-01-15');   -- 1
SELECT DAY('2024-01-15');     -- 15
SELECT DAYNAME('2024-01-15'); -- 'Monday'
```

---

## 4. Tipos Booleanos y Otros

### Booleanos

```sql
CREATE TABLE ejemplo_booleanos (
    activo BOOLEAN,         -- TRUE o FALSE (1 o 0)
    verificado TINYINT(1)   -- Alternativa común
);

INSERT INTO ejemplo_booleanos VALUES (TRUE, 1), (FALSE, 0);
```

### Enum y Set

```sql
-- ENUM: Seleccionar un valor de una lista
CREATE TABLE ejemplo_enum (
    genero ENUM('Masculino', 'Femenino', 'Otro'),
    prioridad ENUM('Baja', 'Media', 'Alta', 'Urgente') DEFAULT 'Media'
);

INSERT INTO ejemplo_enum VALUES ('Masculino', 'Urgente');

-- SET: Seleccionar múltiples valores
CREATE TABLE ejemplo_set (
    dias_trabajo SET('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes')
);

INSERT INTO ejemplo_set VALUES ('Lunes,Miércoles,Viernes');
```

### Tipos Binarios

| Tipo | Descripción |
|------|-------------|
| BINARY(n) | Cadena binaria fija |
| VARBINARY(n) | Cadena binaria variable |
| BLOB | Datos binarios grandes |
| TINYBLOB | Binario pequeño (255 bytes) |
| MEDIUMBLOB | Binario mediano |
| LONGBLOB | Binario muy grande |

### JSON (MySQL 5.7+)

```sql
CREATE TABLE ejemplo_json (
    id INT PRIMARY KEY,
    datos JSON,
    preferencias JSON
);

INSERT INTO ejemplo_json VALUES 
(1, '{"nombre": "Juan", "edad": 30}', '{"tema": "oscuro", "notificaciones": true}');

-- Consultar JSON
SELECT datos->'$.nombre' FROM ejemplo_json;       -- "Juan"
SELECT datos->>'$.nombre' FROM ejemplo_json;     -- Juan (sin comillas)
SELECT JSON_EXTRACT(datos, '$.edad') FROM ejemplo_json; -- 30
```

---

## 📝 Resumen de Tipos de Datos

```
┌─────────────────────────────────────────────────────────────┐
│                 GUÍA RÁPIDA DE TIPOS                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  NUMÉRICOS:                                                 │
│  ├─ ENTEROS: TINYINT, SMALLINT, MEDIUMINT, INT, BIGINT    │
│  ├─ DECIMALES: DECIMAL(p,s), NUMERIC(p,s)                │
│  └─ FLOTANTES: FLOAT, DOUBLE                              │
│                                                             │
│  CADENAS:                                                   │
│  ├─ FIJA: CHAR(n)                                         │
│  ├─ VARIABLE: VARCHAR(n)                                   │
│  └─ LARGOS: TEXT, MEDIUMTEXT, LONGTEXT                    │
│                                                             │
│  FECHAS:                                                    │
│  ├─ DATE: 'YYYY-MM-DD'                                   │
│  ├─ TIME: 'HH:MM:SS'                                      │
│  ├─ DATETIME: 'YYYY-MM-DD HH:MM:SS'                      │
│  └─ TIMESTAMP: UTC timestamp                              │
│                                                             │
│  ESPECIALES:                                                │
│  ├─ ENUM: Un valor de lista                              │
│  ├─ SET: Múltiples valores de lista                       │
│  └─ JSON: Datos estructurados                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## ➡️ Próximo Tema

[SQL: Consultas Avanzadas](07-consultas-avanzadas.md)