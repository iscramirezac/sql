# Módulo 11: Estudio de Casos

## 📋 Índice del Módulo

1. [Sistema R](#1-sistema-r)
2. [Sistemas Comerciales](#2-sistemas-comerciales)
3. [Sistemas de Base de Datos para Microcomputadores](#3-sistemas-de-base-de-datos-para-microcomputadores)

---

## 1. Sistema R

### 1.1 Historia e Importancia

**Sistema R** fue el proyecto de investigación de IBM que dio origen al modelo relacional y SQL.

```
┌─────────────────────────────────────────────────────────────┐
│                   HISTORIA DEL SISTEMA R                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1970: Publicación de Codd: "A Relational Model of Data"  │
│        ────────────────────────────────────────────────     │
│        Introduce el concepto de modelo relacional          │
│                                                             │
│  1974: IBM inicia proyecto System R                        │
│        ────────────────────────────────────────────────     │
│        Objetivo: Implementar modelo relacional              │
│                                                             │
│  1979: Primera implementación de SQL                       │
│        ────────────────────────────────────────────────     │
│        Lenguaje SEQUEL (Structured English Query Language)  │
│                                                             │
│  1986: SQL se convierte en estándar ANSI                  │
│        ────────────────────────────────────────────────     │
│        SQL-86 (SQL-87)                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Contribuciones del Sistema R

| Contribución | Descripción |
|-------------|-------------|
| **Modelo Relacional** | Teoría matemática de relaciones |
| **SQL** | Lenguaje de consulta estándar |
| **Arquitectura de catálogos** | Metadatos del sistema |
| **Optimización de consultas** | Planes de ejecución |
| **Control de concurrencia** | Protocolos de locking |
| **Recuperación** | WAL (write_to_file-Ahead Logging) |

### 1.3 Arquitectura del Sistema R

```
┌─────────────────────────────────────────────────────────────┐
│              ARQUITECTURA DEL SISTEMA R                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   INTERFAZ SQL                        │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              COMPILADOR SQL                         │   │
│  │  • Parseo de consultas                              │   │
│  │  • Optimización                                     │   │
│  │  • Generación de planes                             │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              EJECUTOR DE PLANES                     │   │
│  │  • Acceso a datos                                   │   │
│  │  • Índices                                          │   │
│  │  • Joins                                            │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              GESTOR DE ALMACENAMIENTO              │   │
│  │  • Archivos                                         │   │
│  │  • Índices                                          │   │
│  │  • Buffer pool                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Sistemas Comerciales

### 2.1 Oracle

```sql
-- Características de Oracle
-- Líder del mercado enterprise

-- Oracle 19c/21c: Features
CREATE TABLE empleado (
    id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100),
    salary NUMBER(10,2),
    hire_date DATE DEFAULT SYSDATE
);

-- Particionamiento
CREATE TABLE ventas (
    id NUMBER,
    fecha DATE,
    monto NUMBER(10,2)
)
PARTITION BY RANGE (fecha) (
    PARTITION p2020 VALUES LESS THAN (DATE '2021-01-01'),
    PARTITION p2021 VALUES LESS THAN (DATE '2022-01-01'),
    PARTITION p2022 VALUES LESS THAN (DATE '2023-01-01')
);

-- Oracle JSON
SELECT JSON_VALUE(datos, '$.nombre') FROM empleado_json;
```

### 2.2 Microsoft SQL Server

```sql
-- SQL Server: Integración con ecosistema Microsoft

-- Tipos de datos
CREATE TABLE empleado (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100),
    salary DECIMAL(10,2),
    hire_date DATE DEFAULT GETDATE(),
    profile NVARCHAR(MAX)  -- Para JSON
);

-- Stored Procedure
CREATE PROCEDURE sp_empleados_por_dept
    @dept_id INT
AS
BEGIN
    SELECT * FROM empleado WHERE id_dept = @dept_id;
END;

-- JSON en SQL Server
SELECT * FROM empleado 
FOR JSON PATH;

-- Integración con .NET
-- CLR Stored Procedures
-- SQL Server Analysis Services (OLAP)
```

### 2.3 MySQL/MariaDB

```sql
-- MySQL: Popular en web apps, open source

CREATE TABLE empleado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2),
    hire_date DATE DEFAULT CURRENT_DATE
) ENGINE=InnoDB;

-- MySQL 8.0+: Window functions
SELECT 
    nombre,
    salary,
    AVG(salary) OVER (PARTITION BY id_dept) AS avg_dept
FROM empleado;

-- MySQL 8.0+: CTEs (Common Table Expressions)
WITH recursive cte AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 10
)
SELECT * FROM cte;
```

### 2.4 PostgreSQL

```sql
-- PostgreSQL: "The world's most advanced open source database"

-- Tipos avanzados
CREATE TYPE direccion AS (
    calle VARCHAR(200),
    ciudad VARCHAR(100),
    cp VARCHAR(10)
);

CREATE TABLE empleado (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    direccion direccion,
    telefonos TEXT[]
);

-- JSON/JSONB nativo
CREATE TABLE orden (
    id SERIAL PRIMARY KEY,
    data JSONB
);

INSERT INTO orden VALUES (
    '{"cliente": "Juan", "total": 150.50}'
);

-- Búsqueda en JSONB
SELECT * FROM orden 
WHERE data @> '{"cliente": "Juan"}';

-- Full-text search
CREATE TABLE article (
    id SERIAL PRIMARY KEY,
    title TEXT,
    content TEXT
);

CREATE INDEX article_search 
ON article USING gin(to_tsvector('spanish', title || ' ' || content));

-- Materialized Views
CREATE MATERIALIZED VIEW mv_ventas AS
SELECT 
    producto,
    SUM(cantidad) AS total_vendido
FROM ventas
GROUP BY producto;
```

### 2.5 Comparativa de SGBD Comerciales

| Característica | Oracle | SQL Server | MySQL | PostgreSQL |
|---------------|--------|------------|-------|------------|
| **Licencia** | Propietaria | Propietaria | GPL | BSD |
| **Escala** | Enterprise | Enterprise | Web/SMB | Todas |
| **Complejidad** | Alta | Media | Baja | Media |
| **JSON** | Sí | Sí | Sí | Nativo JSONB |
| **Full-text** | Sí | Sí | Sí | Nativo |
| **Procedural** | PL/SQL | T-SQL | Stored Proc | PL/pgSQL |
| **Replicación** | Advanced | Completa | Básica | Completa |
| **Particionamiento** | Sí | Sí | Sí | Sí |

---

## 3. Sistemas de Base de Datos para Microcomputadores

### 3.1 Microsoft Access

```
┌─────────────────────────────────────────────────────────────┐
│               MICROSOFT ACCESS                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Características:                                          │
│  • Base de datos de escritorio                             │
│  • Interfaz gráfica intuitive                             │
│  • Ideal para pequeñas aplicaciones                        │
│  • Integración con Microsoft Office                       │
│  • VBA para programación                                  │
│  • Limite: 2GB por archivo                                │
│                                                             │
│  Uso típico:                                               │
│  • Inventarios pequeños                                    │
│  • Control de gastos                                      │
│  • Bases de datos personales                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 SQLite

```sql
-- SQLite: Base de datos embebida

-- Características:
-- • Zero-configuration
-- • Sin servidor (embebida)
-- • Un solo archivo
-- • Ideal para móviles y embebidos
-- • Soporta SQL estándar

-- Crear base de datos
-- sqlite3 empresa.db

CREATE TABLE empleado (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    salario REAL
);

INSERT INTO empleado VALUES (1, 'Juan', 75000);
SELECT * FROM empleado;

-- SQLite en Python
import sqlite3
conn = sqlite3.connect('empresa.db')
cursor.execute("SELECT * FROM empleado")
```

### 3.3 Comparativa de BD de Escritorio

| Característica | Access | SQLite | Firebird |
|---------------|--------|--------|----------|
| **Licencia** | Propietaria | Dominio público | IDPL |
| **Usuarios** | Multi (local) | Mono/Multi | Multi |
| **Tamaño** | 2GB | Ilimitado | Ilimitado |
| **SQL** | Access SQL | SQLite SQL | Firebird SQL |
| **Embebida** | No | Sí | Sí |
| **Transacciones** | Limitadas | ACID | ACID |
| **Precio** | Incluido Office | Gratis | Gratis |

---

## 📝 Resumen del Módulo

- **Sistema R:** Fundamento teórico y práctica del modelo relacional
- **SGBD Comerciales:** Oracle, SQL Server, MySQL, PostgreSQL
- **BD Escritorio:** Access, SQLite, Firebird
- **Selección:** Depende del caso de uso, escala y presupuesto

---

## 📚 Recursos Adicionales

### Documentación Oficial
- [Oracle Documentation](https://docs.oracle.com/)
- [MySQL Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/)

### Libros Recomendados
- "Database System Concepts" - Silberschatz, Korth, Sudarshan
- "SQL Performance Explained" - Markus Winand
- "High Performance MySQL" - Schwartz, Zaitsev, Tkachenko

---

## ✅ Curso Completado

¡Felicidades por completar el Curso Completo de SQL!

### Lo que has aprendido:

1. ✅ **Fundamentos de BD:** Arquitectura, modelos, SGBD
2. ✅ **Modelado de datos:** Modelo E-R, diseño conceptual
3. ✅ **SQL Práctico:** Consultas, joins, DDL, DML
4. ✅ **Normalización:** Formas normales, diseño relacional
5. ✅ **Temas Avanzados:** BD OO, distribuidas, seguridad
6. ✅ **Sistemas Reales:** Oracle, MySQL, PostgreSQL, SQL Server

### Próximos pasos:

- 💻 Practicar con proyectos reales
- 📚 Profundizar en tu SGBD favorito
- 🌐 Explorar tecnologías cloud (AWS RDS, Azure SQL)
- 🔒 Estudiar seguridad de bases de datos
- 📊 Aprender sobre Data Warehousing y Big Data

---

## 📧 Contacto y Recursos

- Documentación: Consulta los links de cada módulo
- Práctica: Usa los scripts SQL proporcionados
- Comunidad: Foros, Stack Overflow, Reddit

**¡Continúa aprendiendo y desarrollando tus habilidades en bases de datos!** 🚀