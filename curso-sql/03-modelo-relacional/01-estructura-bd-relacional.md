# Módulo 3: Modelo Relacional

## 📋 Índice del Módulo

### 3.1 Estructura de la Base de Datos Relacional
- [Conceptos Fundamentales](#31-estructura-de-la-base-de-datos-relacional)
- [Componentes del Modelo Relacional](#32-componentes-del-modelo-relacional)
- [Esquema Relacional](#33-esquema-relacional)

### 3.2 Álgebra Relacional
- [Operaciones Fundamentales](#321-operaciones-fundamentales)
- [Operaciones de Conjunto](#322-operaciones-de-conjunto)
- [Operaciones de Join](#323-operaciones-de-join)

### 3.3 SQL: Lenguaje Estructurado de Consulta
- [SELECT básico](#331-select)
- [SELECT con condiciones](#332-where-y-operadores)
- [Funciones de agregación](#333-funciones-de-agregación)
- [JOINs](#334-joins)
- [Subconsultas](#335-subconsultas)

### 3.4 SQL: Database y Tablas
- [DDL - Data Definition Language](#341-ddl)
- [Constraints y Restricciones](#342-constraints)
- [Índices](#343-índices)

### 3.5 Tipos de Datos
- [Tipos Numéricos](#351-tipos-numéricos)
- [Tipos de Cadena](#352-tipos-de-cadena)
- [Tipos de Fecha y Hora](#353-tipos-de-fecha-y-hora)
- [Otros Tipos](#354-otros-tipos)

---

## 3.1 Estructura de la Base de Datos Relacional

### 3.1.1 Conceptos Fundamentales

El **modelo relacional** fue propuesto por Edgar F. Codd en 1970 y se basa en el concepto matemático de relación.

**Principios fundamentales:**

1. **Datos organizados en tablas** - Todo se representa como tablas
2. **Operaciones matemáticas** - Las consultas se basan en teoría de conjuntos
3. **Independencia lógica** - Los usuarios ven solo la vista necesaria
4. **Integridad referencial** - Las relaciones entre datos se mantienen

### 3.1.2 Componentes del Modelo Relacional

```
┌─────────────────────────────────────────────────────────────────┐
│              ESTRUCTURA DEL MODELO RELACIONAL                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                      TABLA (Relación)                    │   │
│  │  ┌─────────────────────────────────────────────────┐    │   │
│  │  │  ┌─────┬──────────┬───────┬─────────┐           │    │   │
│  │  │  │ PK  │  NOMBRE  │ CARGO │ SALARIO │           │    │   │
│  │  │  ├─────┼──────────┼───────┼─────────┤           │    │   │
│  │  │  │  1  │ Juan     │ Ing.  │ 75,000  │  ← Fila   │    │   │
│  │  │  │  2  │ María    │ Anal. │ 65,000  │  (Tupla)  │    │   │
│  │  │  │  3  │ Pedro    │ Líder │ 85,000  │           │    │   │
│  │  │  └─────┴──────────┴───────┴─────────┘           │    │   │
│  │  │           │         │      │                     │    │   │
│  │  │           ▼         ▼      ▼                     │    │   │
│  │  │        Columna   Columna Columna  ← Atributos   │    │   │
│  │  │        (Campo)   (Campo) (Campo)                │    │   │
│  │  └─────────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  TERMINOLOGÍA:                                                  │
│  ┌──────────────┬─────────────────┬─────────────────────┐   │
│  │  Relacional  │    SQL          │     Matemática      │   │
│  ├──────────────┼─────────────────┼─────────────────────┤   │
│  │   Relación   │     Tabla       │       Conjunto      │   │
│  │    Tupla     │     Fila        │       Elemento      │   │
│  │  Atributo    │     Columna     │       Dominio       │   │
│  │     Grado    │  # Columnas     │       Cardinalidad  │   │
│  │ Cardinalidad │  # Filas        │       Atributos     │   │
│  └──────────────┴─────────────────┴─────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3.1.3 Esquema Relacional

Un **esquema relacional** define la estructura de la base de datos:

```sql
-- Notación de esquema
EMPLEADO(id_emp, nombre, cargo, salario, id_dept)
    → PK: id_emp
    → FK: id_dept → DEPARTAMENTO(id_dept)

DEPARTAMENTO(id_dept, nombre_dept, ubicacion)
    → PK: id_dept
```

**Ejemplo visual:**

```
┌─────────────────────────────────────────────────────────────┐
│                    ESQUEMA RELACIONAL                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────┐          ┌─────────────────────┐   │
│  │     EMPLEADO        │          │    DEPARTAMENTO     │   │
│  ├─────────────────────┤          ├─────────────────────┤   │
│  │ id_emp (PK) ────────┼───┐      │ id_dept (PK) ◀─────┼───┘
│  │ nombre              │   │      │ nombre_dept         │
│  │ cargo               │   │      │ ubicacion           │
│  │ salario             │   │      └─────────────────────┘
│  │ id_dept (FK) ───────┼───┘
│  └─────────────────────┘
│                                                             │
│  RELACIÓN: EMPLEADO pertiene_a DEPARTAMENTO                 │
│  CARDINALIDAD: 1:N                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Ejemplo de datos:**

```sql
-- Tabla DEPARTAMENTO
SELECT * FROM departamento;
+----+--------------+------------+
| id | nombre_dept  | ubicacion  |
+----+--------------+------------+
|  1 | IT           | Edif. A    |
|  2 | Ventas       | Edif. B    |
|  3 | Contabilidad | Edif. A    |
+----+--------------+------------+

-- Tabla EMPLEADO
SELECT * FROM empleado;
+----+----------+---------+---------+---------+
| id | nombre    | cargo   | salario | id_dept |
+----+----------+---------+---------+---------+
|  1 | Juan García | Ing.   | 75000   |       1 |
|  2 | María López | Anal.  | 65000   |       1 |
|  3 | Pedro Martínez| Vend. | 55000   |       2 |
|  4 | Ana Hernández| Cont. | 60000   |       3 |
+----+----------+---------+---------+---------+
```

---

## 3.2 Álgebra Relacional

### 3.2.1 Operaciones Fundamentales

El **álgebra relacional** define operaciones que producen nuevas relaciones a partir de otras.

```
┌─────────────────────────────────────────────────────────────────┐
│              OPERACIONES FUNDAMENTALES                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. SELECCIÓN (σ - sigma)                                      │
│     → Filtra filas según una condición                        │
│     → σ_{condición}(relación)                                 │
│                                                                 │
│  2. PROYECCIÓN (π - pi)                                        │
│     → Selecciona columnas específicas                         │
│     → π_{atributos}(relación)                                 │
│                                                                 │
│  3. UNIÓN (∪)                                                  │
│     → Combina dos relaciones                                  │
│     → relación1 ∪ relación2                                    │
│                                                                 │
│  4. DIFERENCIA (-)                                             │
│     → Elementos en A pero no en B                             │
│     → relación1 - relación2                                    │
│                                                                 │
│  5. PRODUCTO CARTESIANO (×)                                    │
│     → Combinación de todas las filas                          │
│     → relación1 × relación2                                    │
│                                                                 │
│  6. RENOMBRAR (ρ - rho)                                        │
│     → Cambia el nombre de atributos o relaciones              │
│     → ρ_{nuevo_nombre}(relación)                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2.2 Operaciones de Conjunto

**UNIÓN (∪):** Devuelve todas las filas de ambas relaciones (sin duplicados)

```sql
-- En SQL: UNION
(SELECT nombre FROM clientes_vip)
UNION
(SELECT nombre FROM empleados);
```

**INTERSECCIÓN (∩):** Devuelve filas presentes en ambas relaciones

```sql
-- En SQL: INTERSECT (o INNER JOIN)
SELECT nombre FROM clientes
INTERSECT
SELECT nombre FROM empleados;
```

**DIFERENCIA (-):** Devuelve filas de la primera relación que no están en la segunda

```sql
-- En SQL: EXCEPT o MINUS
SELECT nombre FROM todos_usuarios
EXCEPT
SELECT nombre FROM usuarios_activos;
```

### 3.2.3 Operaciones de Join

**JOIN NATURAL (⨝):** Combina filas con valores iguales en atributos comunes

```sql
-- En SQL: NATURAL JOIN o JOIN con condiciones
SELECT * FROM empleado 
JOIN departamento ON empleado.id_dept = departamento.id_dept;
```

**JOIN EXTERNO (LEFT/RIGHT/FULL):** Incluye filas sin coincidencia

```sql
-- LEFT JOIN: Incluye todos los empleados, con datos de dept si existen
SELECT e.nombre, d.nombre_dept
FROM empleado e
LEFT JOIN departamento d ON e.id_dept = d.id_dept;

-- RIGHT JOIN: Incluye todos los departamentos
SELECT e.nombre, d.nombre_dept
FROM empleado e
RIGHT JOIN departamento d ON e.id_dept = d.id_dept;
```

---

## 📝 Resumen

El modelo relacional se basa en:
- **Tablas** como estructura principal
- **Operaciones** del álgebra relacional para manipular datos
- **Claves** (primaria y foránea) para establecer relaciones
- **SQL** como lenguaje para implementar operaciones relacionales

---

## ➡️ Próximo Tema

[3.3 SQL: Lenguaje Estructurado de Consulta - SELECT](sql/01-select.md)