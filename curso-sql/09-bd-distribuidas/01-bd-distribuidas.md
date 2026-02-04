# Módulo 9: Bases de Datos Distribuidas

## 📋 Índice del Módulo

1. [Estructura y Diseño](#1-estructura-y-diseño)
2. [Acceso a Datos Distribuidos](#2-acceso-a-los-datos-de-una-base-de-datos-distribuida)
3. [Transparencia y Autonomía Local](#3-transparencia-y-autonomía-local)
4. [Fragmentación de Datos](#4-fragmentación-de-datos)
5. [Procesamiento Distribuido de Consultas](#5-procesamiento-distribuido-de-consultas)
6. [Recuperación en Sistemas Distribuidos](#6-recuperación-en-sistemas-distribuidos)
7. [Transacciones](#7-transacciones)
8. [Control de Concurrencia](#8-control-de-concurrencia-y-técnicas-de-control)
9. [Selección de Coordinador](#9-selección-de-coordinador)
10. [Sistemas de Bases de Datos Múltiples](#10-sistemas-de-bases-de-datos-múltiples)

---

## 1. Estructura y Diseño

### 1.1 Arquitectura de BD Distribuida

```
┌─────────────────────────────────────────────────────────────┐
│            ARQUITECTURA DE BASE DE DATOS DISTRIBUIDA      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   ┌─────────┐      ┌─────────┐      ┌─────────┐          │
│   │ Nodo 1  │      │ Nodo 2  │      │ Nodo 3  │          │
│   │ ┌─────┐ │      │ ┌─────┐ │      │ ┌─────┐ │          │
│   │ │ SGBD │ │      │ │ SGBD │ │      │ │ SGBD │ │          │
│   │ └─────┘ │      │ └─────┘ │      │ └─────┘ │          │
│   │  ┌────┐│      │  ┌────┐│      │  ┌────┐│          │
│   │  │ BD ││      │  │ BD ││      │  │ BD ││          │
│   │  └────┘│      │  └────┘│      │  └────┘│          │
│   └────┬───┘      └────┬───┘      └────┬───┘          │
│        │               │               │                  │
│        └───────────────┼───────────────┘                  │
│                        │                                  │
│                        ▼                                  │
│              ┌─────────────────┐                         │
│              │   RED DE        │                         │
│              │  COMUNICACIÓN   │                         │
│              └─────────────────┘                         │
│                        │                                  │
│                        ▼                                  │
│              ┌─────────────────┐                         │
│              │   CATÁLOGO      │                         │
│              │   DISTRIBUIDO  │                         │
│              └─────────────────┘                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Tipos de BD Distribuidas

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| **Homogénea** | Mismo SGBD en todos los nodos | MySQL Cluster |
| **Heterogénea** | Diferentes SGBD | Oracle + SQL Server |
| **Federada** | BD autónomas con interfaz unificada | PostgreSQL FDW |
| **Centralizada** | Un solo nodo con acceso remoto | BD tradicional + replicación |

---

## 2. Acceso a Datos Distribuidos

### 2.1 Consultas Distribuidas

```sql
-- MySQL Federated: Acceso a tablas remotas
CREATE TABLE empleado_remoto (
    id INT,
    nombre VARCHAR(100),
    salario DECIMAL(10,2)
) ENGINE=FEDERATED
CONNECTION='mysql://user:pass@host:3306/db/empleado';

-- PostgreSQL Foreign Data Wrapper
CREATE EXTENSION oracle_fdw;
CREATE SERVER oracle_server FOREIGN DATA WRAPPER oracle_fdw
    OPTIONS (dbserver '//host:1521/service');

CREATE FOREIGN TABLE empleado_oracle (
    id INT,
    nombre VARCHAR(100)
) SERVER oracle_server
    OPTIONS (table 'EMPLEADO');

-- Consultar datos distribuidos
SELECT * FROM empleado_remoto;
SELECT * FROM empleado_oracle;
```

### 2.2 Optimización de Consultas Distribuidas

```sql
-- Estrategia: Traer datos pequeños primero
-- Ejemplo: Join entre tablas en diferentes nodos

-- Optimización: Filtrar antes de transferir
SELECT e.nombre, d.nombre_dept
FROM empleado e
INNER JOIN dept_remoto d ON e.id_dept = d.id
WHERE e.salario > 50000;  -- Filtrar primero
```

---

## 3. Transparencia y Autonomía Local

### 3.1 Niveles de Transparencia

```
┌─────────────────────────────────────────────────────────────┐
│                NIVELES DE TRANSPARENCIA                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  TRANSPARENCIA DE FRAGMENTACIÓN                    │   │
│  │  El usuario ve una sola tabla, no sabe que está    │   │
│  │  fragmentada                                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  TRANSPARENCIA DE REPLICACIÓN                      │   │
│  │  El usuario no sabe que existen copias de los      │   │
│  │  datos                                             │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  TRANSPARENCIA DE UBICACIÓN                        │   │
│  │  El usuario no sabe dónde están almacenados los    │   │
│  │  datos                                             │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                 │
│                          ▼                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  TRANSPARENCIA DE RED                              │   │
│  │  El usuario no sabe cómo se accede a la red         │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Autonomía Local

```sql
-- Cada nodo mantiene control sobre sus datos locales
-- Políticas de seguridad locales
-- horarios de mantenimiento independientes
-- backup local

-- Ejemplo: Configuración de autonomía
CREATE DATABASE db_nodo1;  -- Nodo 1
CREATE DATABASE db_nodo2;  -- Nodo 2

-- Políticas de acceso
GRANT SELECT ON tabla_local TO 'user_nodo1'@'localhost';
REVOKE INSERT ON tabla_local FROM 'user_externo'@'%';
```

---

## 4. Fragmentación de Datos

### 4.1 Tipos de Fragmentación

```
┌─────────────────────────────────────────────────────────────┐
│                  TIPOS DE FRAGMENTACIÓN                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  FRAGMENTACIÓN HORIZONTAL                          │   │
│  │                                                     │   │
│  │  EMPLEADO ──→ EMPLEADO_TI   (WHERE dept = 'TI')  │   │
│  │         ──→ EMPLEADO_VENTAS (WHERE dept = 'VENTAS')│
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  FRAGMENTACIÓN VERTICAL                           │   │
│  │                                                     │   │
│  │  EMPLEADO ──→ EMPLEADO_ID   (id, nombre)          │   │
│  │         ──→ EMPLEADO_SALARIO (id, salario, cargo) │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  FRAGMENTACIÓN MIXTA                              │   │
│  │                                                     │   │
│  │  EMPLEADO ──→ EMPLEADO_TI_BASIC  (horizontal)    │   │
│  │         ──→ EMPLEADO_VENTAS_DETAIL (vertical)     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Implementación de Fragmentación

```sql
-- Fragmentación Horizontal (MySQL)
CREATE TABLE empleado (
    id INT,
    nombre VARCHAR(100),
    dept VARCHAR(50),
    salario DECIMAL(10,2)
) PARTITION BY HASH(id) PARTITIONS 4;

-- Fragmentación por Rango
CREATE TABLE pedido_fecha (
    id INT,
    fecha_pedido DATE,
    total DECIMAL(10,2)
) PARTITION BY RANGE (YEAR(fecha_pedido)) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024)
);

-- Fragmentación Vertical (Oracle)
CREATE TABLE empleado (
    id_emp INT PRIMARY KEY,
    nombre VARCHAR2(100)
) TABLESPACE ts1;

CREATE TABLE empleado_detalle (
    id_emp INT PRIMARY KEY,
    salario NUMBER(10,2),
    cargo VARCHAR2(50),
    FOREIGN KEY (id_emp) REFERENCES empleado(id_emp)
) TABLESPACE ts2;
```

---

## 5. Procesamiento Distribuido de Consultas

### 5.1 Optimizador de Consultas

```
┌─────────────────────────────────────────────────────────────┐
│          PROCESAMIENTO DE CONSULTA DISTRIBUIDA            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CONSULTA:                                                  │
│  SELECT e.nombre, SUM(p.total)                             │
│  FROM empleado e, pedido p                                 │
│  WHERE e.id = p.id_emp                                     │
│  GROUP BY e.nombre                                         │
│                                                             │
│  PLAN DE EJECUCIÓN:                                         │
│  1. Traducir a álgebra relacional                          │
│  2. Generar planes de ejecución                            │
│  3. Estimar costos (I/O, CPU, red)                         │
│  4. Seleccionar mejor plan                                  │
│  5. Ejecutar en nodos apropiados                            │
│  6. Combinar resultados                                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 Estrategias de Join Distribuido

```sql
-- Join anidado distribuido
-- Eficiencia: Transferir tabla más pequeña

-- Semi-join para reducir transferencia
SELECT e.nombre, p.total
FROM empleado e, pedido p
WHERE e.id = p.id_emp
  AND e.dept = 'TI';

-- Optimización: Usar semi-join
SELECT e.nombre
FROM empleado e
WHERE e.dept = 'TI'
  AND EXISTS (
    SELECT 1 FROM pedido p WHERE p.id_emp = e.id
  );
```

---

## 6. Recuperación en Sistemas Distribuidos

### 6.1 Tipos de Fallos

```
┌─────────────────────────────────────────────────────────────┐
│                  TIPOS DE FALLOS                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  SOFT FAILURE (Fallos Blandos)                     │   │
│  │                                                     │   │
│  │  - Transacción abortada                            │   │
│  │  - Violación de restricciones                      │   │
│  │  - Interbloqueo                                   │   │
│  │  - Comunicación interrumpida                        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  HARD FAILURE (Fallos Duros)                       │   │
│  │                                                     │   │
│  │  - Caída de nodo                                   │   │
│  │  - Disco dañado                                    │   │
│  │  - Corte de energía                                │   │
│  │  - Red fallida                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 Protocolo de Commit en 2 Fases (2PC)

```
┌─────────────────────────────────────────────────────────────┐
│              PROTOCOLO 2PC (TWO-PHASE COMMIT)             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  FASE 1: PREPARAR (VOTAR)                                 │
│  ────────────────────────────                              │
│  Coordinator → Prepare → Todos los participantes            │
│  Participant1 → VOTE_COMMIT                                │
│  Participant2 → VOTE_COMMIT                               │
│  Participant3 → VOTE_ABORT                                  │
│                                                             │
│  FASE 2: DECIDIR (COMPROMETER)                             │
│  ────────────────────────────                              │
│  Si todos votan COMMIT:                                    │
│    Coordinator → GLOBAL_COMMIT → Participantes             │
│  Si alguno vota ABORT:                                    │
│    Coordinator → GLOBAL_ABORT → Participantes              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 6.3 Implementación de Recuperación

```sql
-- Log distribuido para recuperación
CREATE TABLE log_transaccion (
    id_transaccion INT,
    nodo_id INT,
    operacion VARCHAR(50),
    datos_anterior BLOB,
    datos_nuevo BLOB,
    timestamp TIMESTAMP,
    estado ENUM('PREPARED', 'COMMITTED', 'ABORTED')
);

-- Procedimiento de recuperación
DELIMITER //
CREATE PROCEDURE sp_recuperar_nodo(IN nodo_id INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_trans INT;
    
    DECLARE cur_trans CURSOR FOR 
        SELECT id_transaccion 
        FROM log_transaccion 
        WHERE nodo_id = nodo_id 
          AND estado = 'PREPARED';
    
    OPEN cur_trans;
    
    read_loop: LOOP
        FETCH cur_trans INTO v_trans;
        IF done THEN LEAVE read_loop; END IF;
        
        -- Verificar si el coordinator decidió
        IF EXISTS (
            SELECT 1 FROM log_transaccion_global 
            WHERE id_transaccion = v_trans 
              AND estado = 'COMMITTED'
        ) THEN
            -- Reaplicar commit
            UPDATE log_transaccion SET estado = 'COMMITTED'
            WHERE id_transaccion = v_trans;
        ELSE
            -- Abortar
            UPDATE log_transaccion SET estado = 'ABORTED'
            WHERE id_transaccion = v_trans;
        END IF;
    END LOOP;
    
    CLOSE cur_trans;
END //
DELIMITER ;
```

---

## 7. Transacciones Distribuidas

### 7.1 Propiedades ACID Distribuidas

```sql
-- Configuración de transacción distribuida
START TRANSACTION;

-- Operación en nodo 1
UPDATE empleado SET salario = 75000 WHERE id = 1;

-- Operación en nodo 2
UPDATE cuenta SET balance = balance - 5000 WHERE id_cuenta = 100;

-- Operación en nodo 3
INSERT INTO auditoria (transaccion, accion) VALUES (TX_ID, 'DEDUCCIÓN');

COMMIT;  -- Si todo va bien, confirmar en todos los nodos
```

---

## 8. Control de Concurrencia

### 8.1 Técnicas de Control

```sql
-- Control de concurrencia optimista (MVCC)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Locking distribuido (Redis como gestor de locks)
-- Obtener lock
SET @lock = REDIS_EVAL("
    if redis.call('set', KEYS[1], ARGV[1], 'NX', 'PX', 60000) 
    then return 1 else return 0 end
", 'lock:transaccion:123', 'owner1');

-- Liberar lock
REDIS_EVAL("
    if redis.call('get', KEYS[1]) == ARGV[1] 
    then return redis.call('del', KEYS[1]) else return 0 end
", 'lock:transaccion:123', 'owner1');
```

---

## 10. Sistemas de Bases de Datos Múltiples

### 10.1 Sharding

```sql
-- Aplicación de sharding
-- Shard key: id_cliente

-- shard1
CREATE TABLE pedido_shard1 (
    id INT PRIMARY KEY,
    id_cliente INT,
    total DECIMAL(10,2)
);

-- shard2
CREATE TABLE pedido_shard2 (
    id INT PRIMARY KEY,
    id_cliente INT,
    total DECIMAL(10,2)
);

-- Router de aplicación
-- Si id_cliente BETWEEN 0 AND 10000 → shard1
-- Si id_cliente BETWEEN 10001 AND 20000 → shard2
```

---

## 📝 Resumen del Módulo

- **BD Distribuida:** Datos en múltiples nodos geográficamente distribuidos
- **Fragmentación:** Horizontal, vertical, mixta
- **Replicación:** Copias de datos en varios nodos
- **Transparencia:** Usuario no percibe distribución
- **2PC:** Protocolo de commit en 2 fases
- **Sharding:** Particionamiento horizontal distribuido

---

## ➡️ Próximo Módulo

[Módulo 10: Protección de Datos](10-proteccion-datos/01-proteccion-datos.md)