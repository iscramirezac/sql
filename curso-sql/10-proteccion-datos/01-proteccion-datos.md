# Módulo 10: Protección de Datos

## 📋 Índice del Módulo

1. [Funciones del Administrador de Bases de Datos](#1-funciones-del-administrador-de-bases-de-datos)
2. [Seguridad en la Base de Datos](#2-seguridad-en-la-base-de-datos-y-el-administrador-de-bases-de-datos)
3. [Integridad de Datos](#3-integridad)
4. [Llaves de Dominio](#4-llaves-de-dominio)
5. [Restricciones de Dominio](#5-restricciones-de-dominio)
6. [Integridad Referencial](#6-integridad-referencial)
7. [Violaciones de Seguridad](#7-violaciones-de-seguridad)
8. [Autorizaciones y Vistas](#8-autorizaciones-y-vistas)
9. [Cifrado de Datos](#9-cifrado)

---

## 1. Funciones del Administrador de Bases de Datos

### 1.1 Responsabilidades del DBA

```
┌─────────────────────────────────────────────────────────────┐
│              FUNCIONES DEL DBA                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  INSTALACIÓN Y CONFIGURACIÓN                        │   │
│  │  • Instalar SGBD                                    │   │
│  │  • Configurar parámetros                            │   │
│  │  • Optimizar rendimiento                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  DISEÑO DE LA BASE DE DATOS                         │   │
│  │  • Diseñar esquema                                   │   │
│  │  • Planificar capacidad                             │   │
│  │  • Definir estándares                               │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  SEGURIDAD Y ACCESO                                 │   │
│  │  • Crear usuarios                                    │   │
│  │  • Asignar permisos                                  │   │
│  │  • Implementar políticas                            │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  RESPALDOS Y RECUPERACIÓN                           │   │
│  │  • Programar backups                                 │   │
│  │  • Documentar procedimientos                        │   │
│  │  • Plan de desastres                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  MANTENIMIENTO Y MONITOREO                         │   │
│  │  • Monitorear rendimiento                          │   │
│  │  • Aplicar parches                                   │   │
│  │  • Actualizar documentación                        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Tareas del Día a Día del DBA

```sql
-- Verificar espacio en disco
SELECT table_schema,
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS size_mb
FROM information_schema.tables
GROUP BY table_schema;

-- Monitorear conexiones activas
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Aborted_connects';

-- Ver locks activos
SELECT * FROM information_schema.innodb_locks;

-- Revisar queries lentos
SHOW VARIABLES LIKE 'slow_query_log';
SELECT * FROM mysql.slow_log;
```

---

## 2. Seguridad en la Base de Datos

### 2.1 Modelo de Seguridad

```sql
-- Crear usuarios con diferentes niveles de acceso
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin123!';
CREATE USER 'desarrollador'@'%' IDENTIFIED BY 'Dev123!';
CREATE USER 'consultor'@'localhost' IDENTIFIED BY 'Consul123!';
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'App123!';

-- Asignar roles (MySQL 8.0+)
CREATE ROLE 'admin_role';
CREATE ROLE 'dev_role';
CREATE ROLE 'read_role';

GRANT ALL PRIVILEGES ON empresa_db.* TO 'admin_role';
GRANT SELECT, INSERT, UPDATE ON empresa_db.* TO 'dev_role';
GRANT SELECT ON empresa_db.* TO 'read_role';

GRANT 'admin_role' TO 'admin'@'localhost';
GRANT 'dev_role' TO 'desarrollador'@'%';
```

### 2.2 Principio de Mínimo Privilegio

```sql
-- ✅ CORRECTO: Solo los permisos necesarios
GRANT SELECT, INSERT, UPDATE ON empleado TO 'app_user'@'localhost';

-- ❌ INCORRECTO: Demasiados permisos
GRANT ALL ON empresa_db.* TO 'app_user'@'localhost';

-- Revisar permisos otorgados
SHOW GRANTS FOR 'app_user'@'localhost';

-- Revocar permisos innecesarios
REVOKE DELETE ON empresa_db.empleado FROM 'app_user'@'localhost';
```

---

## 3. Integridad de Datos

### 3.1 Tipos de Integridad

```
┌─────────────────────────────────────────────────────────────┐
│                 TIPOS DE INTEGRIDAD                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  INTEGRIDAD DE ENTIDAD                             │   │
│  │                                                     │   │
│  │  • Cada tabla tiene clave primaria única           │   │
│  │  • No hay valores NULL en clave primaria           │   │
│  │  • No hay filas duplicadas                         │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  INTEGRIDAD DE DOMINIO                              │   │
│  │                                                     │   │
│  │  • Los valores cumplen el tipo de dato             │   │
│  │  • Los valores están en el rango válido             │   │
│  │  • Los valores tienen el formato correcto          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  INTEGRIDAD REFERENCIAL                            │   │
│  │                                                     │   │
│  │  • Las claves foráneas referencian datos válidos  │   │
│  │  • No hay huérfanos en las relaciones              │   │
│  │  • Se mantienen las restricciones ON DELETE/UPDATE  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Implementación de Integridad

```sql
-- Integridad de entidad
CREATE TABLE empleado (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    UNIQUE KEY uk_email (email)
);

-- Integridad de dominio
CREATE TABLE producto (
    id INT PRIMARY KEY,
    precio DECIMAL(10,2) CHECK (precio >= 0),
    cantidad INT CHECK (cantidad >= 0),
    estado ENUM('ACTIVO', 'INACTIVO') DEFAULT 'ACTIVO'
);

-- Integridad referencial
CREATE TABLE pedido (
    id INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```

---

## 4. Llaves de Dominio

```sql
-- Definición de dominio
CREATE DOMAIN tipo_email VARCHAR(100)
    CHECK (VALUE LIKE '%@%');

CREATE DOMAIN tipo_positivo DECIMAL(10,2)
    CHECK (VALUE >= 0);

CREATE DOMAIN tipo_edad INT
    CHECK (VALUE BETWEEN 0 AND 150);

-- Uso de dominios
CREATE TABLE contacto (
    id INT PRIMARY KEY,
    email tipo_email,
    edad tipo_edad,
    presupuesto tipo_positivo
);
```

---

## 5. Restricciones de Dominio

```sql
-- CHECK constraints
CREATE TABLE empleado (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    salario DECIMAL(10,2),
    fecha_nacimiento DATE,
    
    -- Restricciones CHECK
    CHECK (salario > 0),
    CHECK (email LIKE '%@%'),
    CHECK (fecha_nacimiento < CURRENT_DATE),
    
    -- CHECK complejo
    CHECK (
        (cargo = 'Gerente' AND salario > 80000) OR
        (cargo != 'Gerente')
    )
);

-- Restricciones con nombres (más claras)
CREATE TABLE pedido (
    id INT PRIMARY KEY,
    cantidad INT,
    precio DECIMAL(10,2),
    total DECIMAL(10,2),
    
    CONSTRAINT chk_positivo CHECK (cantidad > 0),
    CONSTRAINT chk_precio_positivo CHECK (precio >= 0),
    CONSTRAINT chk_calculo CHECK (total = cantidad * precio)
);
```

---

## 6. Integridad Referencial

### 6.1 Restricciones ON DELETE y ON UPDATE

```sql
CREATE TABLE cliente (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE pedido (
    id INT PRIMARY KEY,
    id_cliente INT,
    fecha DATE,
    
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
        ON DELETE RESTRICT      -- No permite borrar cliente con pedidos
        ON UPDATE CASCADE       -- Si cambia ID del cliente, actualiza
);

-- Opciones disponibles:
-- RESTRICT: Cancela la operación (por defecto)
-- CASCADE: Propaga el cambio/borrado
-- SET NULL: Pone NULL en la FK
-- NO ACTION: Similar a RESTRICT
-- SET DEFAULT: Pone el valor por defecto
```

### 6.2 Asertos (Assertions)

```sql
-- PostgreSQL: Assertions (verificación automática)
CREATE ASSERTION pedidos_no_vacios
CHECK (
    NOT EXISTS (
        SELECT 1 FROM pedido p
        WHERE NOT EXISTS (
            SELECT 1 FROM detalle_pedido d
            WHERE d.id_pedido = p.id
        )
    )
);

-- En MySQL, usar triggers como alternativa
DELIMITER //
CREATE TRIGGER trg_check_pedido
BEFORE INSERT ON pedido
FOR EACH ROW
BEGIN
    IF NEW.total <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido debe tener un total mayor a 0';
    END IF;
END //
DELIMITER ;
```

### 6.3 Disparadores (Triggers) de Integridad

```sql
-- Trigger para validar integridad
DELIMITER //
CREATE TRIGGER trg_validar_credito
BEFORE INSERT ON pedido
FOR EACH ROW
BEGIN
    DECLARE limite DECIMAL(10,2);
    DECLARE total_actual DECIMAL(10,2);
    
    -- Obtener límite de crédito
    SELECT limite_credito INTO limite
    FROM cliente WHERE id = NEW.id_cliente;
    
    -- Calcular total actual de pedidos
    SELECT IFNULL(SUM(total), 0) INTO total_actual
    FROM pedido 
    WHERE id_cliente = NEW.id_cliente
      AND estado != 'CANCELADO';
    
    -- Verificar que no exceda el límite
    IF (total_actual + NEW.total) > limite THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Pedido excede límite de crédito';
    END IF;
END //
DELIMITER ;
```

---

## 7. Violaciones de Seguridad

### 7.1 Tipos de Amenazas

```
┌─────────────────────────────────────────────────────────────┐
│               VIOLACIONES DE SEGURIDAD                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  AMENAZAS INTERNAS                                 │   │
│  │                                                     │   │
│  │  • Empleado descontento                           │   │
│  │  • Error humano                                    │   │
│  │  • Abuso de privilegios                            │   │
│  │  • Robo de información                             │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  AMENAZAS EXTERNAS                                 │   │
│  │                                                     │   │
│  │  • Ataque de inyección SQL                         │   │
│  │  • Hacking                                          │   │
│  │  • Malware                                         │   │
│  │  • Ataque de fuerza bruta                          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 7.2 Prevención de Inyección SQL

```sql
-- ❌ VULNERABLE: Concatenación directa
SELECT * FROM users 
WHERE username = '" + username + "' AND password = '" + password + "';

-- ✅ SEGURO: Prepared statements
PREPARE stmt FROM 
    'SELECT * FROM users WHERE username = ? AND password = ?';
SET @username = 'juan';
SET @password = 'password123';
EXECUTE stmt USING @username, @password;

-- En aplicación (JDBC)
String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, username);
pstmt.setString(2, password);
ResultSet rs = pstmt.executeQuery();
```

---

## 8. Autorizaciones y Vistas

### 8.1 Sistema de Permisos

```sql
-- Conceder permisos específicos
GRANT SELECT ON empleado TO 'consultor'@'localhost';
GRANT SELECT, INSERT, UPDATE ON cliente TO 'operador'@'%';
GRANT SELECT, UPDATE ON salario TO 'rrhh'@'localhost';

-- Conceder con grant option
GRANT SELECT ON empresa_db.* TO 'admin'@'localhost'
    WITH GRANT OPTION;

-- Roles (MySQL 8.0)
CREATE ROLE 'analista';
CREATE ROLE 'gerente_rrhh';

GRANT SELECT ON empresa_db.empleado TO 'analista';
GRANT SELECT, UPDATE ON empresa_db.empleado TO 'gerente_rrhh';
GRANT 'analista' TO 'user1'@'%';
```

### 8.2 Vistas para Seguridad

```sql
-- Vista para ocultar datos sensibles
CREATE VIEW vista_empleados_publico AS
SELECT 
    id,
    nombre,
    cargo,
    id_dept
FROM empleado;

-- Vista con datos agregados (sin detalles)
CREATE VIEW vista_salarios_dept AS
SELECT 
    id_dept,
    COUNT(*) AS num_empleados,
    AVG(salario) AS salario_promedio,
    MIN(salario) AS salario_minimo,
    MAX(salario) AS salario_maximo
FROM empleado
GROUP BY id_dept;

-- Vista con columnas calculadas
CREATE VIEW vista_resumen AS
SELECT 
    nombre,
    cargo,
    salario * 1.10 AS salario_con_bono
FROM empleado;
```

---

## 9. Cifrado de Datos

### 9.1 Cifrado en Tránsito

```sql
-- Configurar SSL/TLS en MySQL
-- En my.cnf
-- [mysqld]
-- ssl-ca=/path/to/ca.pem
-- ssl-cert=/path/to/server-cert.pem
-- ssl-key=/path/to/server-key.pem

-- Forzar conexiones SSL
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%'
    REQUIRE SSL;

-- Verificar SSL
SHOW VARIABLES LIKE '%ssl%';
```

### 9.2 Cifrado en Reposo (At Rest)

```sql
-- MySQL: Tablespace encryption
ALTER TABLE empleado ENCRYPTION = 'Y';

-- Oracle: Transparent Data Encryption (TDE)
CREATE TABLESPACE secure_ts 
    DATAFILE 'secure01.dbf' 
    ENCRYPTION USING 'AES256';

-- PostgreSQL: pgcrypto extension
CREATE EXTENSION pgcrypto;

-- Cifrar datos sensibles
UPDATE empleado 
SET numero_seguro = PGP_SYM_ENCRYPT(numero_seguro, 'clave_secreta')
WHERE id = 1;

-- Descifrar datos
SELECT 
    id,
    PGP_SYM_DECRYPT(numero_seguro, 'clave_secreta') AS numero_seguro
FROM empleado
WHERE id = 1;
```

### 9.3 Cifrado de Contraseñas

```sql
-- MySQL 8.0+: Native password encryption
CREATE USER 'user'@'localhost' 
    IDENTIFIED WITH mysql_native_password BY 'password123';

-- Usar funciones de hash
INSERT INTO usuario (username, password_hash)
VALUES (
    'juan',
    SHA2('password123', 256)
);

-- Verificar contraseña
SELECT * FROM usuario 
WHERE username = 'juan' 
  AND password_hash = SHA2('password123', 256);
```

---

## 📝 Resumen del Módulo

- **DBA:** Instala, configura, mantiene y protege la BD
- **Seguridad:** Usuarios, roles, permisos, mínimo privilegio
- **Integridad:** Entidad, dominio, referencial
- **Restricciones:** CHECK, NOT NULL, UNIQUE, FOREIGN KEY
- **Vistas:** Para control de acceso y ocultar datos sensibles
- **Cifrado:** En tránsito (SSL) y en reposo (TDE)

---

## ➡️ Próximo Módulo

[Módulo 11: Estudio de Casos](11-estudio-casos/01-estudio-casos.md)