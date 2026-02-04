# 📚 Curso Completo de SQL

## Bases de Datos SQL - Enfoque MariaDB/MySQL

Bienvenido al curso completo de SQL. Este curso está diseñado para llevarte desde los conceptos fundamentales hasta las técnicas avanzadas de diseño y consulta de bases de datos.

---

## 📚 Temario del Curso

### Módulos Fundamentales

#### [Módulo 1: Arquitectura de los Sistemas de Bases de Datos](curso-sql/01-arquitectura-bd/01-arquitectura-sistemas-bd.md)
- Conceptos básicos de bases de datos
- Abstracción y modelos de datos
- Independencia de datos
- Lenguaje de definición y manipulación de datos (DDL/DML)
- Gestor, administrador y usuario de base de datos
- Estructuras de almacenamiento
- Bases de Datos SQL y NoSQL

#### [Módulo 2: Modelo Entidad-Relación](curso-sql/02-modelo-er/01-modelo-entidad-relacion.md)
- Entidades, relaciones y atributos
- Restricciones y asignación
- Claves (primaria, foránea, compuesta)
- Diagramas E-R y reducción a tablas
- Generalización
- Agregación

#### [Módulo 3: Modelo Relacional](curso-sql/03-modelo-relacional/01-estructura-bd-relacional.md)

##### Fundamentos
- Estructura de la base de datos relacional
- Álgebra relacional

##### SQL: Lenguaje Estructurado de Consulta
- [SELECT básico](curso-sql/03-modelo-relacional/sql/01-select.md)
- [DML: INSERT, UPDATE, DELETE](curso-sql/03-modelo-relacional/sql/02-dml.md)
- [JOINs: INNER, LEFT, RIGHT, FULL](curso-sql/03-modelo-relacional/sql/03-joins.md)
- [Consultas avanzadas](curso-sql/03-modelo-relacional/sql/07-consultas-avanzadas.md)

##### SQL: Database y Tablas
- [DDL: CREATE, DROP, ALTER](curso-sql/03-modelo-relacional/sql/05-ddl.md)
- [Tipos de datos](curso-sql/03-modelo-relacional/sql/06-tipos-datos.md)
- Restricciones y constraints
- Índices

#### [Módulo 4: Estructura Interna de los SGBD](curso-sql/04-estructura-interna/01-estructura-sgbd.md)
- Estructura de archivos y sistemas
- Técnicas de acceso a datos
- Procesamiento de consultas

#### [Módulo 5: Diseño de Bases de Datos](curso-sql/05-diseno-bd/01-diseno-general.md)
- Visión general del proceso de diseño
- Diseño de base de datos
- Reducción a esquemas relacionales

#### [Módulo 6: Diseño de Bases de Datos Relacionales](curso-sql/06-diseno-relacional/01-diseno-relacional.md)
- Características de diseños relacionales
- Dominios atómicos y Primera Forma Normal (1FN)
- Modelado de datos y normalización

### Módulos Avanzados

#### [Módulo 7: Modelo Orientado a Objetos](curso-sql/07-modelo-oo/01-modelo-orientado-objetos.md)
- Conceptos introductorios del modelo OO
- Estructura de objetos
- Clasificación y jerarquía de clases
- Herencia y herencia múltiple
- Diseño lógico de BD orientadas a objetos
- Consultas en BD orientadas a objetos

#### [Módulo 8: Sistemas Relacionales y Extendidos](curso-sql/08-sistemas-relacionales/01-modelo-logico.md)
- Modelo de datos basado en la lógica
- Normalización completa (1FN, 2FN, 3FN, BCNF)
- Desnormalización
- Datos complejos y tipos anidados
- Sistemas expertos de bases de datos

#### [Módulo 9: Bases de Datos Distribuidas](curso-sql/09-bd-distribuidas/01-bd-distribuidas.md)
- Estructura y diseño de BD distribuidas
- Acceso a datos distribuidos
- Transparencia y autonomía local
- Fragmentación de datos
- Procesamiento distribuido de consultas
- Recuperación: Soft y Hard failure
- Protocolo COMMIT en 2 fases
- Transacciones distribuidas
- Control de concurrencia
- Selección de coordinador
- Sistemas de bases de datos múltiples

#### [Módulo 10: Protección de Datos](curso-sql/10-proteccion-datos/01-proteccion-datos.md)
- Funciones del administrador de BD
- Seguridad en la base de datos
- Integridad de datos
- Llaves y restricciones de dominio
- Integridad referencial (asertos, triggers)
- Violaciones de seguridad
- Autorizaciones y vistas
- Cifrado de datos

#### [Módulo 11: Estudio de Casos](curso-sql/11-estudio-casos/01-estudio-casos.md)
- Sistema R: Historia e importancia
- Sistemas Comerciales: Oracle, SQL Server, MySQL, PostgreSQL
- Bases de datos para microcomputadores: Access, SQLite
- Comparativas de SGBD
- Recursos adicionales y próximos pasos

---

## 🎯 Objetivos del Curso

Al finalizar este curso podrás:

1. ✅ Comprender la arquitectura y funcionamiento de los sistemas de bases de datos
2. ✅ Diseñar modelos entidad-relación para sistemas de información
3. ✅ Implementar bases de datos relacionales usando SQL
4. ✅ Escribir consultas simples y avanzadas
5. ✅ Aplicar técnicas de normalización
6. ✅ Optimizar el diseño de bases de datos

---

## 🛠️ Herramientas Recomendadas

### Servidores de Bases de Datos
- **MySQL** (https://www.mysql.com/)
- **MariaDB** (https://mariadb.org/)
- **XAMPP** (incluye MySQL)
- **WAMP** (incluye MySQL)

### Clientes SQL
- **MySQL Workbench**
- **DBeaver** (multi-database)
- ** HeidiSQL** (Windows)
- **phpMyAdmin** (web)

---

## 📁 Estructura del Proyecto

```
sql/
├── README.md
├── curso-sql/
│   ├── 01-arquitectura-bd/
│   │   └── 01-arquitectura-sistemas-bd.md
│   ├── 02-modelo-er/
│   │   └── 01-modelo-entidad-relacion.md
│   ├── 03-modelo-relacional/
│   │   ├── 01-estructura-bd-relacional.md
│   │   └── sql/
│   │       ├── 01-select.md
│   │       ├── 02-dml.md
│   │       ├── 03-joins.md
│   │       ├── 05-ddl.md
│   │       ├── 06-tipos-datos.md
│   │       └── 07-consultas-avanzadas.md
│   ├── 04-estructura-interna/
│   │   └── 01-estructura-sgbd.md
│   ├── 05-diseno-bd/
│   │   └── 01-diseno-general.md
│   └── 06-diseno-relacional/
│       └── 01-diseno-relacional.md
```

---

## 💡 Cómo Usar Este Curso

1. **Inicio:** Comienza por el Módulo 1 para entender los fundamentos
2. **Progresión:** Sigue el orden de los módulos
3. **Práctica:** Cada tema incluye ejemplos de SQL
4. **Experimentación:** Ejecuta los scripts en tu propio servidor
5. **Scripts SQL:** Usa los scripts de la carpeta `scripts/` para practicar

---

## 📁 Scripts SQL de Ejemplo

```
sql/
└── scripts/
    ├── 01-base-datos-ejemplo.sql     # Base de datos completa
    ├── 02-consultas-ejemplos.sql      # Consultas SELECT, DML
    ├── 03-joins-ejemplos.sql         # INNER, LEFT, RIGHT, FULL JOINs
    └── 04-avanzado.sql              # Vistas, Stored Procedures, Triggers
```

### Cómo usar los scripts:

1. Abre MySQL/MariaDB
2. Ejecuta `curso-sql/scripts/01-base-datos-ejemplo.sql` para crear la BD
3. Practica con los ejemplos de `02-consultas-ejemplos.sql`
4. Aprende JOINs con `03-joins-ejemplos.sql`
5. Explora temas avanzados con `04-avanzado.sql`

---

## 📚 Recursos Adicionales

### Documentación Oficial
- [MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

### Libros Recomendados
- "Database System Concepts" - Silberschatz, Korth, Sudarshan
- "Fundamentals of Database Systems" - Elmasri, Navathe
- "SQL in 10 Minutes a Day" - Ben Forta

### Práctica Online
- [SQLZoo](https://sqlzoo.net/)
- [W3Schools SQL](https://www.w3schools.com/sql/)
- [LeetCode SQL](https://leetcode.com/problemset/database/)

---

## 📝 Licencia

Este curso educativo está disponible para uso personal y académico.

---

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si encuentras errores o quieres mejorar el contenido, no dudes en abrir un issue o pull request.

---

**¡Bienvenido al mundo de las bases de datos SQL!** 🚀