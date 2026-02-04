# Módulo 4: Estructura Interna de los Sistemas de Base de Datos y SGBD

## 📋 Índice del Módulo

1. [Estructura de Archivos y Sistemas](#1-estructura-de-archivos-y-sistemas)
2. [Técnicas de Acceso a Datos](#2-técnicas-de-acceso-a-datos)
3. [Procesamiento de Consultas](#3-procesamiento-de-consultas)

---

## 1. Estructura de Archivos y Sistemas

### 1.1 Arquitectura de Archivos

Los sistemas de bases de datos utilizan archivos especializados para el almacenamiento:

```
┌─────────────────────────────────────────────────────────────┐
│               ESTRUCTURA DE ALMACENAMIENTO                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              ARCHIVO DE DATOS                       │   │
│  │  - Contiene los registros de las tablas             │   │
│  │  - Organizado en páginas/bloques                    │   │
│  │  - Acceso directo a través de direcciones           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              ARCHIVO DE ÍNDICES                     │   │
│  │  - Estructuras para búsqueda rápida                 │   │
│  │  - Árboles B+, Tablas Hash                         │   │
│  │  - Reducen tiempo de búsqueda                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            ARCHIVO DE METADATOS                     │   │
│  │  - Catálogo del sistema                            │   │
│  │  - Definiciones de tablas, columnas, índices       │   │
│  │  - Estadísticas de uso                             │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            ARCHIVO DE LOGS                          │   │
│  │  - Registro de transacciones                        │   │
│  │  - Para recuperación de fallos                     │   │
│  │  - Historial de operaciones                         │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Organización de Archivos

**Archivo Heap (Montón):**
- Registros almacenados sin orden específico
- Búsqueda requiere escaneo completo
- Inserción rápida

**Archivo Secuencial:**
- Registros ordenados por una clave
- Búsqueda eficiente con binary search
- Mantenimiento del orden costoso

**Archivo Hash:**
- Función hash sobre clave
- Acceso directo muy rápido
- Solo búsqueda por clave exacta

---

## 2. Técnicas de Acceso a Datos

### 2.1 Métodos de Acceso

```
┌─────────────────────────────────────────────────────────────┐
│                 TÉCNICAS DE ACCESO                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              ACCESO SECUENCIAL                      │   │
│  │                                                     │   │
│  │  Bloque 1 → Bloque 2 → Bloque 3 → Bloque 4        │   │
│  │                                                     │   │
│  │  Uso: Lectura completa, backups                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              ACCESO DIRECTO (Índices)              │   │
│  │                                                     │   │
│  │  Clave → Tabla Hash/B+Tree → Dirección → Registro  │   │
│  │                                                     │   │
│  │  Uso: Búsquedas por clave, joins                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              ACCESO POR ÍNDICE                     │   │
│  │                                                     │   │
│  │  - Primary Index: Clave primaria                   │   │
│  │  - Secondary Index: Otras columnas                 │   │
│  │  - Clustered Index: Orden físico                   │   │
│  │  - Non-Clustered Index: Puntero a datos            │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Estructuras de Índices

**Árbol B+ (MySQL/MariaDB):**

```
                    [50 | 100]
                   /    |      \
            [25|40]    [75]    [125|150]
             /  |       |       /   |    \
         ...  ...     ...     ...  ...    ...
```

**Ventajas del árbol B+:**
- Búsqueda O(log n)
- Compatible con escaneo secuencial
- Manejo eficiente de grandes volúmenes

---

## 3. Procesamiento de Consultas

### 3.1 Fases del Procesamiento

```
┌─────────────────────────────────────────────────────────────┐
│              PROCESAMIENTO DE CONSULTAS                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. ANALIZADOR SINTÁCTICO                                   │
│     ↓                                                       │
│     SQL → Árbol de parseo → Verificar sintaxis              │
│                                                             │
│  2. OPTIMIZADOR                                             │
│     ↓                                                       │
│     Múltiples planes → Elegir el más eficiente              │
│     → Costo estimado de cada plan                           │
│                                                             │
│  3. GENERADOR DE PLAN                                       │
│     ↓                                                       │
│     Plan de ejecución óptimo                               │
│                                                             │
│  4. EJECUTOR                                                │
│     ↓                                                       │
│     Ejecutar operaciones → Retornar resultados              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Optimización de Consultas

**Reglas heurísticas:**
- Aplicar WHERE primero (reducir filas)
- Usar índices para JOINs
- Proyectar solo columnas necesarias
- Evitar SELECT *

```sql
-- MAL: Escaneo completo
SELECT * FROM empleados WHERE cargo = 'Gerente';

-- BIEN: Solo columnas necesarias + índice
SELECT nombre, salario FROM empleados WHERE cargo = 'Gerente';
```

### 3.3 Planes de Ejecución

```sql
-- Ver plan de ejecución
EXPLAIN SELECT * FROM empleados WHERE id = 1;

+----+-------------+----------+-------+---------------+
| id | select_type| table    | type  | key          |
+----+-------------+----------+-------+---------------+
|  1 | SIMPLE     | empleados| const | PRIMARY       |
+----+-------------+----------+-------+---------------+
```

**Tipo de acceso:**
- const: Acceso por clave primaria (más rápido)
- eq_ref: JOIN por clave única
- ref: JOIN por clave indexada
- range: Rango de valores
- ALL: Escaneo completo (más lento)

---

## 📝 Resumen

- **Archivos especializados:** Datos, índices, metadatos, logs
- **Técnicas de acceso:** Secuencial, directo, indexado
- **Índices:** B+ tree (más común), Hash
- **Procesamiento:** Parseo → Optimización → Ejecución
- **Optimización:** Planes de ejecución, uso de índices

---

## ➡️ Próximo Módulo

[Módulo 5: Diseño de Bases de Datos](05-diseno-bd/01-diseno-general.md)