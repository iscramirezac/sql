-- ========================================
-- SCRIPT BASE DE DATOS DE EJEMPLO
-- Para uso en todo el curso de SQL
-- Compatible con MySQL/MariaDB
-- ========================================

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS empresa_db;
USE empresa_db;

-- ========================================
-- TABLA: DEPARTAMENTOS
-- ========================================
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS departamentos;

CREATE TABLE departamentos (
    id_dept INT PRIMARY KEY AUTO_INCREMENT,
    nombre_dept VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(100),
    presupuesto DECIMAL(15,2) DEFAULT 0.00,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Insertar departamentos
INSERT INTO departamentos (id_dept, nombre_dept, ubicacion, presupuesto) VALUES
(1, 'TI', 'Edificio A - Piso 3', 500000.00),
(2, 'Ventas', 'Edificio B - Piso 1', 300000.00),
(3, 'Recursos Humanos', 'Edificio A - Piso 1', 150000.00),
(4, 'Contabilidad', 'Edificio A - Piso 2', 200000.00),
(5, 'Marketing', 'Edificio C - Piso 1', 250000.00);

-- Ver departamentos
SELECT * FROM departamentos;

-- ========================================
-- TABLA: EMPLEADOS
-- ========================================
CREATE TABLE empleados (
    id_emp INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20),
    cargo VARCHAR(50),
    salario DECIMAL(10,2) CHECK (salario > 0),
    comision DECIMAL(10,2) DEFAULT 0.00,
    id_dept INT,
    id_gerente INT,
    fecha_nacimiento DATE,
    fecha_contratacion DATE DEFAULT (CURRENT_DATE),
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_dept) REFERENCES departamentos(id_dept)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (id_gerente) REFERENCES empleados(id_emp)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Insertar empleados
INSERT INTO empleados (nombre, email, telefono, cargo, salario, comision, id_dept, id_gerente, fecha_nacimiento, fecha_contratacion) VALUES
('Juan García', 'juan.garcia@empresa.com', '555-1234', 'Gerente de TI', 85000.00, 5000.00, 1, NULL, '1975-03-15', '2010-01-15'),
('María López', 'maria.lopez@empresa.com', '555-5678', 'Analista Senior', 75000.00, 3000.00, 1, 1, '1980-07-22', '2012-03-20'),
('Pedro Martínez', 'pedro.martinez@empresa.com', '555-9012', 'Desarrollador', 65000.00, 2000.00, 1, 1, '1985-11-08', '2015-06-01'),
('Ana Hernández', 'ana.hernandez@empresa.com', '555-3456', 'Gerente de Ventas', 80000.00, 8000.00, 2, NULL, '1972-05-30', '2009-02-10'),
('Carlos Ruiz', 'carlos.ruiz@empresa.com', '555-7890', 'Vendedor', 55000.00, 5000.00, 2, 4, '1990-09-12', '2018-04-15'),
('Laura Díaz', 'laura.diaz@empresa.com', '555-2345', 'Vendedor', 52000.00, 4500.00, 2, 4, '1992-01-25', '2019-08-20'),
('Miguel Torres', 'miguel.torres@empresa.com', '555-6789', 'Director de RH', 90000.00, 0.00, 3, NULL, '1968-12-03', '2005-11-01'),
('Sofía Ramírez', 'sofia.ramirez@empresa.com', '555-0123', 'Analista de RH', 60000.00, 0.00, 3, 7, '1988-04-18', '2016-07-01'),
('Roberto Gómez', 'roberto.gomez@empresa.com', '555-4567', 'Contador Senior', 70000.00, 0.00, 4, NULL, '1979-08-22', '2011-05-15'),
('Elena Vargas', 'elena.vargas@empresa.com', '555-8901', 'Contador', 55000.00, 0.00, 4, 9, '1991-02-14', '2017-09-01'),
('Fernando Castro', 'fernando.castro@empresa.com', '555-3210', 'Gerente de Marketing', 78000.00, 6000.00, 5, NULL, '1975-06-28', '2010-08-15'),
('Patricia Lima', 'patricia.lima@empresa.com', '555-6543', 'Especialista en Marketing', 62000.00, 3000.00, 5, 11, '1987-10-05', '2014-12-01');

-- Ver empleados
SELECT * FROM empleados;

-- ========================================
-- TABLA: PROYECTOS
-- ========================================
DROP TABLE IF EXISTS proyectos;
DROP TABLE IF EXISTS asignaciones_proyecto;

CREATE TABLE proyectos (
    id_proy INT PRIMARY KEY AUTO_INCREMENT,
    nombre_proy VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    presupuesto DECIMAL(15,2),
    estado ENUM('Planificación', 'En Progreso', 'Completado', 'Cancelado') DEFAULT 'Planificación'
) ENGINE=InnoDB;

-- Insertar proyectos
INSERT INTO proyectos (nombre_proy, descripcion, fecha_inicio, fecha_fin, presupuesto, estado) VALUES
('Sistema de Inventario', 'Desarrollo de nuevo sistema de gestión de inventario', '2024-01-15', '2024-06-30', 150000.00, 'En Progreso'),
('Portal Web 2.0', 'Rediseño completo del portal web corporativo', '2024-03-01', '2024-09-30', 80000.00, 'En Progreso'),
('App Móvil Clientes', 'Aplicación móvil para clientes', '2024-06-01', '2024-12-31', 120000.00, 'Planificación'),
('Migración a Cloud', 'Migración de servidores a la nube', '2024-02-01', '2024-08-31', 200000.00, 'En Progreso'),
('Automatización RH', 'Automatización de procesos de recursos humanos', '2024-04-01', '2024-10-31', 60000.00, 'Planificación');

-- ========================================
-- TABLA: ASIGNACIONES DE PROYECTO
-- ========================================
CREATE TABLE asignaciones_proyecto (
    id_emp INT,
    id_proy INT,
    horas_asignadas INT DEFAULT 0,
    rol VARCHAR(50) DEFAULT 'Miembro',
    fecha_asignacion DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_emp, id_proy),
    FOREIGN KEY (id_emp) REFERENCES empleados(id_emp)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_proy) REFERENCES proyectos(id_proy)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Insertar asignaciones
INSERT INTO asignaciones_proyecto (id_emp, id_proy, horas_asignadas, rol) VALUES
(1, 1, 100, 'Líder del Proyecto'),
(2, 1, 200, 'Analista'),
(3, 1, 300, 'Desarrollador'),
(1, 2, 50, 'Asesor Técnico'),
(3, 2, 150, 'Desarrollador'),
(11, 2, 100, 'Gerente de Proyecto'),
(4, 3, 80, 'Stakeholder'),
(7, 5, 120, 'Líder del Proyecto'),
(8, 5, 200, 'Analista'),
(1, 4, 200, 'Líder Técnico'),
(2, 4, 100, 'Arquitecto'),
(3, 4, 150, 'Desarrollador');

-- Ver asignaciones
SELECT * FROM asignaciones_proyecto;

-- ========================================
-- TABLA: CLIENTES (Para ejercicios de ventas)
-- ========================================
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    ciudad VARCHAR(50),
    pais VARCHAR(50),
    limite_credito DECIMAL(10,2) DEFAULT 50000.00,
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Insertar clientes
INSERT INTO clientes (nombre, contacto, email, telefono, ciudad, pais, limite_credito) VALUES
('Empresa ABC', 'Pedro Soto', 'pedro@abc.com', '555-1111', 'Ciudad de México', 'México', 100000.00),
('Corporación XYZ', 'Laura Méndez', 'laura@xyz.com', '555-2222', 'Guadalajara', 'México', 150000.00),
('Industrias Beta', 'Roberto Ruiz', 'rruiz@beta.com', '555-3333', 'Monterrey', 'México', 80000.00),
('Tech Solutions', 'Ana García', 'agarcia@techsol.com', '555-4444', 'Ciudad de México', 'México', 120000.00),
('Grupo Delta', 'Carlos Vega', 'cvega@delta.com', '555-5555', 'Tijuana', 'México', 90000.00);

-- ========================================
-- TABLA: PEDIDOS
-- ========================================
DROP TABLE IF EXISTS pedidos;
DROP TABLE IF EXISTS detalles_pedido;

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    fecha_pedido DATE DEFAULT CURRENT_DATE,
    fecha_envio DATE,
    estado ENUM('Pendiente', 'Procesando', 'Enviado', 'Entregado', 'Cancelado') DEFAULT 'Pendiente',
    total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Insertar pedidos
INSERT INTO pedidos (id_cliente, fecha_pedido, fecha_envio, estado, total) VALUES
(1, '2024-01-15', '2024-01-18', 'Entregado', 45000.00),
(2, '2024-01-20', '2024-01-25', 'Entregado', 32000.00),
(3, '2024-02-05', NULL, 'Pendiente', 28000.00),
(1, '2024-02-10', '2024-02-15', 'Entregado', 55000.00),
(4, '2024-02-15', NULL, 'Procesando', 41000.00),
(5, '2024-02-20', NULL, 'Pendiente', 23000.00);

-- ========================================
-- TABLA: DETALLES DE PEDIDO
-- ========================================
CREATE TABLE productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_unitario DECIMAL(10,2) CHECK (precio_unitario > 0),
    stock INT DEFAULT 0,
    categoria VARCHAR(50)
) ENGINE=InnoDB;

INSERT INTO productos (nombre_producto, descripcion, precio_unitario, stock, categoria) VALUES
('Laptop Dell XPS', 'Laptop profesional 15"', 25000.00, 50, 'Hardware'),
('Monitor Samsung 27"', 'Monitor 4K 27 pulgadas', 8500.00, 100, 'Hardware'),
('Teclado Mecánico', 'Teclado gaming RGB', 2500.00, 200, 'Accesorios'),
('Mouse Inalámbrico', 'Mouse ergonómico inalámbrico', 1500.00, 300, 'Accesorios'),
('Licencia Windows 11', 'Licencia OEM', 3500.00, 500, 'Software'),
('Licencia Office 2021', 'Licencia perpetua', 8500.00, 200, 'Software');

CREATE TABLE detalles_pedido (
    id_pedido INT,
    id_producto INT,
    cantidad INT CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO detalles_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 25000.00),
(1, 3, 5, 2500.00),
(1, 4, 5, 1500.00),
(2, 2, 2, 8500.00),
(2, 5, 3, 3500.00),
(3, 1, 1, 25000.00),
(3, 6, 1, 8500.00),
(4, 2, 3, 8500.00),
(4, 5, 5, 3500.00),
(5, 1, 1, 25000.00),
(5, 4, 10, 1500.00),
(6, 3, 5, 2500.00),
(6, 5, 2, 3500.00);

-- ========================================
-- VISTAS DE EJEMPLO
-- ========================================

-- Vista de empleados con departamento
CREATE VIEW vista_empleados_dept AS
SELECT e.id_emp, e.nombre, e.cargo, e.salario, d.nombre_dept, d.ubicacion
FROM empleados e
LEFT JOIN departamentos d ON e.id_dept = d.id_dept;

-- Vista de pedidos con cliente
CREATE VIEW vista_pedidos_cliente AS
SELECT p.id_pedido, p.fecha_pedido, p.estado, p.total, 
       c.nombre AS cliente, c.ciudad, c.pais
FROM pedidos p
LEFT JOIN clientes c ON p.id_cliente = c.id_cliente;

-- Vista de proyectos con horas asignadas
CREATE VIEW vista_proyectos_horas AS
