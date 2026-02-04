# Módulo 1: Arquitectura de los Sistemas de Bases de Datos

## 📋 Índice del Módulo

1. [Conceptos Básicos](#1-conceptos-básicos)
2. [Abstracción y Modelos de Datos](#2-abstracción-y-modelos-de-datos)
3. [Independencia de Datos](#3-independencia-de-datos)
4. [Lenguaje de Definición y Manipulación de Datos](#4-lenguaje-de-definición-y-manipulación-de-datos)
5. [Gestor, Administrador y Usuario de Base de Datos](#5-gestor-administrador-y-usuario-de-base-de-datos)
6. [Estructuras de Almacenamiento](#6-estructuras-de-almacenamiento)
7. [Bases de Datos SQL y NoSQL](#7-bases-de-datos-sql-y-nosql)

---

## 1. Conceptos Básicos

### 1.1 ¿Qué es una Base de Datos?

Una **base de datos** es una colección organizada de datos que están relacionados entre sí, diseñados para cumplir las necesidades informacionales de una organización. Los datos se almacenan de manera que sean independientes de los programas que los utilizan.

**Definición formal:** Una base de datos es un conjunto de datos almacenados sistemáticamente para su posterior uso.

### 1.2 Sistema Gestor de Base de Datos (SGBD)

El **SGBD** (Sistema Gestor de Base de Datos) es el software que permite definir, crear, mantener y controlar el acceso a la base de datos. Actsúa como intermediario entre los usuarios y la base de datos.

**Funciones principales del SGBD:**

| Función | Descripción |
|---------|-------------|
| **Definición de datos** | Permite especificar los tipos, estructuras y restricciones |
| **Manipulación de datos** | Facilita insertar, actualizar, eliminar y consultar datos |
| **Control de acceso** | Gestiona la seguridad y permisos de usuarios |
| **Integridad de datos** | Asegura que los datos cumplan las reglas de negocio |
| **Recuperación** | Permite restaurar la BD después de fallos |

### 1.3 Componentes de un Sistema de Base de Datos

```
┌─────────────────────────────────────────────────────────────┐
│                    SISTEMA DE BASE DE DATOS                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │   HARDWARE   │    │   SOFTWARE   │    │    DATOS     │  │
│  │              │    │              │    │              │  │
│  │ - Servidores │    │ - SGBD       │    │ - Metadatos  │  │
│  │ - Almacenamiento│  │ - SO         │    │ - Datos      │  │
│  │ - Red        │    │ - Aplicaciones│   │ - Índices    │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│                                                             │
│  ┌──────────────┐    ┌──────────────┐                      │
│  │   USUARIOS   │    │ PROCEDIMIENTOS│                     │
│  │              │    │              │                      │
│  │ - DBA        │    │ - Políticas  │                      │
│  │ - Desarroll. │    │ - Normativas │                      │
│  │ - Usuarios finales│  │ - Procedures│                      │
│  └──────────────┘    └──────────────┘                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1.4 Ventajas de las Bases de Datos

**Reducción de redundancia:** Los datos se almacenan una sola vez, eliminando la duplicación innecesaria.

**Consistencia de datos:** Al evitar la redundancia, se elimina la inconsistencia que surge cuando la misma información aparece en múltiples lugares.

**Integridad de datos:** Los datos mantienen su validez y exactitud gracias a las restricciones definidas.

**Compartición de datos:** Múltiples usuarios pueden acceder a los mismos datos simultáneamente.

**Seguridad:** Control de acceso granular para proteger la información sensible.

**Respaldo y recuperación:** Facilidad para recuperar datos en caso de fallos.

---

## 2. Abstracción y Modelos de Datos

### 2.1 Niveles de Abstracción

La arquitectura de tres niveles de ANSI/SPARC permite separar la vista del usuario de la estructura física de la base de datos.

```
┌─────────────────────────────────────────────────────────┐
│                  NIVEL EXTERNO (Vista)                  │
│                                                         │
│   Vista 1        Vista 2        Vista 3                  │
│   ┌─────┐        ┌─────┐        ┌─────┐                │
│   │User1│        │User2│        │User3│                │
│   └─────┘        └─────┘        └─────┘                │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                  NIVEL CONCEPTUAL (Lógico)              │
│                                                         │
│              ┌─────────────────────────┐                 │
│              │   Esquema Conceptual   │                 │
│              │   (Estructura Global)  │                 │
│              └─────────────────────────┘                 │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                  NIVEL INTERNO (Físico)                 │
│                                                         │
│              ┌─────────────────────────┐                 │
│              │   Esquema Interno      │                 │
│              │   (Almacenamiento)     │                 │
│              └─────────────────────────┘                 │
└─────────────────────────────────────────────────────────┘
```

### 2.2 Descripción de los Niveles

**Nivel Externo (Vista de Usuario):**
- Describe cómo ve los datos cada usuario o grupo de usuarios
- Cada usuario tiene su propia "vista" de la base de datos
- Oculta los detalles no relevantes para ese usuario

**Nivel Conceptual (Lógico):**
- Describe la estructura de toda la base de datos para la comunidad de usuarios
- Define qué datos se almacenan y sus relaciones
- Incluye restricciones de integridad y reglas de negocio

**Nivel Interno (Físico):**
- Describe el almacenamiento físico de los datos
- Define cómo se almacenan los datos en disco
- Incluye índices, organización de archivos, compresión

### 2.3 Modelos de Datos

Los modelos de datos son herramientas conceptuales que permiten representar la realidad de forma abstracta.

**Modelo Jerárquico:**
```
    ┌────────────┐
    │  Empresa   │
    └─────┬──────┘
          │
    ┌─────┴──────┐
    │            │
┌───▼──┐    ┌───▼──┐
│Depto1│    │Depto2│
└──┬───┘    └──┬───┘
   │           │
┌──▼──┐    ┌───▼──┐
│Emp1 │    │Emp3  │
└─────┘    └──────┘
```

**Modelo de Red:**
```
        ┌────────────┐
        │  Empresa   │
        └─────┬──────┘
              │
    ┌─────────┼─────────┐
    │         │         │
┌───▼───┐ ┌───▼───┐ ┌───▼───┐
│Depto1 │ │Depto2 │ │Depto3 │
└───┬───┘ └───┬───┘ └───┬───┘
    │         │         │
    └────┬────┼────┬────┘
         │    │    │
      ┌───▼────┴────▼───┐
      │      Empleados  │
      │   (Conectados)  │
      └─────────────────┘
```

**Modelo Relacional:**
```
┌─────────────────┐
│    DEPARTAMENTOS   │
├─────────────────┤
│ dept_id │ nombre │
├─────────┼────────┤
│    1    │   IT   │
│    2    │  Ventas│
└─────────┴────────┘
       │
       │ FK
       ▼
┌─────────────────┐
│    EMPLEADOS    │
├─────────────────┤
│ emp_id │ nombre │ dept_id │
├─────────┼────────┼─────────┤
│   1    │ Juan   │    1    │
│   2    │ María  │    1    │
│   3    │ Pedro  │    2    │
└─────────┴────────┴─────────┘
```

---

## 3. Independencia de Datos

### 3.1 Definición

La **independencia de datos** es la capacidad de modificar el esquema en un nivel sin tener que modificar el esquema del nivel inmediatamente superior.

### 3.2 Tipos de Independencia

**Independencia Lógica de Datos:**
- Capacidad de modificar el esquema conceptual sin afectar las aplicaciones
- Ejemplo: Añadir una nueva tabla no afecta las consultas existentes

**Independencia Física de Datos:**
- Capacidad de modificar el esquema interno sin afectar el conceptual
- Ejemplo: Cambiar el método de almacenamiento de archivos secuenciales a indexados

```
┌────────────────────────────────────────────────────────────┐
│                    INDEPENDENCIA DE DATOS                  │
├────────────────────────────────────────────────────────────┤
│                                                            │
│   ┌─────────────────────┐                                  │
│   │   NIVEL EXTERNO     │  ──────────────────────►        │
│   │   (Aplicaciones)    │    Independencia Lógica         │
│   └─────────────────────┘                                 │
│              ▲                                             │
│              │                                             │
│   ┌─────────────────────┐                                  │
│   │   NIVEL CONCEPTUAL  │  ──────────────────────►        │
│   │   (Estructura Lógica)│    Independencia Física         │
│   └─────────────────────┘                                 │
│              ▲                                             │
│              │                                             │
│   ┌─────────────────────┐                                  │
│   │   NIVEL INTERNO     │                                 │
│   │   (Almacenamiento)  │                                 │
│   └─────────────────────┘                                  │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### 3.3 Beneficios de la Independencia de Datos

| Beneficio | Descripción |
|-----------|-------------|
| **Flexibilidad** | Permite cambios en la estructura sin reescribir aplicaciones |
| **Mantenimiento** | Reduce el costo y tiempo de mantenimiento |
| **Evolución** | Facilita la adaptación a nuevos requerimientos |
| **Portabilidad** | Permite migrar entre diferentes plataformas de almacenamiento |

---

## 4. Lenguaje de Definición y Manipulación de Datos

### 4.1 Lenguaje de Definición de Datos (DDL)

El **DDL** (Data Definition Language) se utiliza para definir y modificar la estructura de la base de datos.

**Comandos DDL principales:**

```sql
-- Crear una base de datos
CREATE DATABASE nombre_bd;

-- Crear una tabla
CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_contratacion DATE
);

-- Modificar una tabla
ALTER TABLE empleados
ADD COLUMN departamento VARCHAR(30);

-- Eliminar una tabla
DROP TABLE empleados;

-- Eliminar base de datos
DROP DATABASE nombre_bd;
```

### 4.2 Lenguaje de Manipulación de Datos (DML)

El **DML** (Data Manipulation Language) se utiliza para insertar, actualizar, eliminar y consultar datos.

**Comandos DML principales:**

```sql
-- Insertar datos
INSERT INTO empleados (id, nombre, salario) 
VALUES (1, 'Juan García', 50000.00);

-- Actualizar datos
UPDATE empleados 
SET salario = 55000.00 
WHERE id = 1;

-- Eliminar datos
DELETE FROM empleados 
WHERE id = 1;

-- Consultar datos
SELECT nombre, salario 
FROM empleados 
WHERE departamento = 'IT';
```

### 4.3 Lenguaje de Control de Datos (DCL)

El **DCL** (Data Control Language) gestiona los permisos y seguridad.

```sql
-- Conceder permisos
GRANT SELECT, INSERT ON empleados TO usuario1;

-- Revocar permisos
REVOKE INSERT ON empleados FROM usuario1;
```

---

## 5. Gestor, Administrador y Usuario de Base de Datos

### 5.1 Roles en un Sistema de Base de Datos

```
┌─────────────────────────────────────────────────────────────┐
│                    ROLES EN LA BASE DE DATOS                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              ADMINISTRADOR (DBA)                    │   │
│  │  • Instala y configura el SGBD                       │   │
│  │  • Diseña la estructura de la BD                     │   │
│  │  • Gestiona usuarios y permisos                      │   │
│  │  • Realiza respaldos y recuperaciones                │   │
│  │  • Optimiza el rendimiento                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                           │                                │
│                           ▼                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              DESARROLLADORES                        │   │
│  │  • Diseñan consultas y procedimientos              │   │
│  │  • Crean aplicaciones que acceden a la BD           │   │
│  │  • Implementan reglas de negocio                    │   │
│  │  • Optimizan queries existentes                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                           │                                │
│                           ▼                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              USUARIOS FINALES                       │   │
│  │  • Acceden a los datos a través de aplicaciones     │   │
│  │  • Generan reportes y consultas simples             │   │
│  │  • No necesitan conocer la estructura técnica       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 Funciones del Administrador de Base de Datos (DBA)

**Instalación y Configuración:**
```sql
-- El DBA realiza estas tareas a nivel de sistema
-- No son comandos SQL, sino configuraciones del SGBD
```

**Gestión de Seguridad:**
```sql
-- Crear usuario
CREATE USER 'ismael'@'localhost' IDENTIFIED BY 'password123';

-- Asignar roles
GRANT ALL PRIVILEGES ON *.* TO 'ismael'@'localhost';

-- Ver permisos
SHOW GRANTS FOR 'ismael'@'localhost';
```

**Respaldos:**
```bash
# Ejemplo de respaldo con mysqldump
mysqldump -u root -p nombre_bd > respaldo.sql
```

**Optimización:**
```sql
-- Análisis de rendimiento
EXPLAIN SELECT * FROM empleados WHERE departamento = 'IT';

-- Optimización de tablas
OPTIMIZE TABLE empleados;
```

---

## 6. Estructuras de Almacenamiento

### 6.1 Organización de Archivos

Los datos se almacenan en archivos que pueden organizarse de diferentes maneras:

**Archivo Secuencial:**
```
Registro 1: Juan | García | 50000
Registro 2: María | López | 60000
Registro 3: Pedro | González | 55000
       ↓
┌─────────────────────────────────┐
│ Juan|García|50000|María|López|60│
│ 000|Pedro|González|55000        │
└─────────────────────────────────┘
```

**Archivo Indexado:**
```
┌─────────────────────────────────────────┐
│               ÍNDICE                    │
├─────────────────────────────────────────┤
│ Clave  │  Apuntador                     │
├────────┼────────────────────────────────┤
│  1001  │  Bloque 5, Offset 0            │
│  1002  │  Bloque 3, Offset 2           │
│  1003  │  Bloque 7, Offset 1           │
└────────┴────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│              DATOS                       │
├─────────────────────────────────────────┤
│ Bloque 3 │ Bloque 5 │ Bloque 7         │
│ 1002     │ 1001     │ 1003              │
│ María    │ Juan     │ Pedro             │
└─────────────────────────────────────────┘
```

### 6.2 Tipos de Índices

**Índice Primario:**
- Solo puede haber uno por tabla
- Los datos se ordenan físicamente por este índice
- Generalmente es la clave primaria

**Índice Secundario:**
- Puedenhaber múltiples por tabla
- No ordena físicamente los datos
- Acceso más rápido a registros específicos

**Índice Cluster:**
- Los registros con valores similares se almacenan cerca físicamente
- Solo puede existir uno por tabla

### 6.3 Estructuras de Datos para Índices

**Árbol B+ (usado por MySQL/MariaDB):**
```
                    [50]
                   /    \
            [25]          [75]
           /    \        /    \
        [10]    [40]  [60]    [90]
         │       │     │       │
        ...     ...   ...     ...
```

**Tabla Hash:**
```
┌─────────┬────────────────┐
│  Hash   │    Datos       │
├─────────┼────────────────┤
│  #1234  │  Juan García   │
│  #5678  │  María López   │
│  #9012  │  Pedro González│
└─────────┴────────────────┘
```

---

## 7. Bases de Datos SQL y NoSQL

### 7.1 Comparación SQL vs NoSQL

| Característica | SQL | NoSQL |
|----------------|-----|-------|
| **Modelo** | Relacional (tablas) | Diverso (documentos, clave-valor, grafos) |
| **Esquema** | Fijo (predefinido) | Flexible (dinámico) |
| **Lenguaje** | SQL estándar | Varía según la BD |
| **Escalabilidad** | Vertical (mayor hardware) | Horizontal (distribuido) |
| **Transacciones** | ACID (completo) | BASE (flexible) |
| ** JOINs** | Soportados nativamente | Generalmente limitados |

### 7.2 Bases de Datos SQL Populares

**MySQL:**
- Desarrollada por Oracle
- Muy popular en aplicaciones web
- Usada por Facebook, YouTube, WordPress

**MariaDB:**
- Fork de MySQL (desarrollado por creadores originales)
- Compatible con MySQL
- Mejor rendimiento en algunas consultas

**PostgreSQL:**
- Sistema objeto-relacional
- Muy robusto y escalable
- Estándar SQL muy estricto

### 7.3 Bases de Datos NoSQL Populares

**MongoDB (Documentos):**
```javascript
// Ejemplo de documento en MongoDB
{
  "_id": "507f1f77bcf86cd799439011",
  "nombre": "Juan García",
  "edad": 30,
  "departamento": "IT",
  "habilidades": ["Python", "JavaScript", "SQL"]
}
```

**Redis (Clave-Valor):**
```
SET usuario:1001 "Juan García"
GET usuario:1001 → "Juan García"
```

**Neo4j (Grafos):**
```
(nodo:Empleado {nombre: "Juan"})-[:TRABAJA_EN]->(dept:Departamento {nombre: "IT"})
```

### 7.4 Cuándo Usar Cada Tipo

**Usar SQL cuando:**
- Se requiere integridad de datos estricta
- Las relaciones entre datos son complejas
- Se necesitan transacciones ACID
- El esquema está bien definido

**Usar NoSQL cuando:**
- El esquema puede cambiar frecuentemente
- Se necesita alta escalabilidad horizontal
- Los datos no son altamente relacionales
- Se prioriza la velocidad sobre la consistencia

---

## 📝 Resumen del Módulo

En este módulo hemos aprendido:

1. **Conceptos básicos:** Qué es una base de datos y un SGBD
2. **Abstracción:** Los tres niveles de arquitectura (externo, conceptual, interno)
3. **Independencia:** La separación entre niveles que permite cambios flexibles
4. **DDL/DML:** Los lenguajes para definir y manipular datos
5. **Roles:** Las funciones de DBA, desarrolladores y usuarios finales
6. **Almacenamiento:** Cómo se organizan y acceden a los datos físicamente
7. **SQL vs NoSQL:** Las diferencias y casos de uso de cada tipo

---

## ➡️ Próximo Módulo

[Módulo 2: Modelo Entidad-Relación](02-modelo-er/01-entes.md)