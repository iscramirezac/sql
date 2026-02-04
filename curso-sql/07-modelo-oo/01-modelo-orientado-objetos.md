# Módulo 7: Modelo Orientado a Objetos

## 📋 Índice del Módulo

1. [Conceptos Introductorios](#1-conceptos-introductorios)
2. [Estructura de Objetos](#2-estructura-de-objetos)
3. [Clasificación y Jerarquía de Clases](#3-clasificación-y-jerarquía-de-clases)
4. [Herencia y Herencia Múltiple](#4-herencia-y-herencia-múltiple)
5. [Diseño Lógico de Bases de Datos Orientadas a Objetos](#5-diseño-lógico-de-bases-de-datos-orientadas-a-objetos)
6. [Consultas en Bases de Datos Orientadas a Objetos](#6-consultas-en-bases-de-datos-orientadas-a-objetos)

---

## 1. Conceptos Introductorios

### 1.1 ¿Qué es el Modelo Orientado a Objetos?

El **modelo orientado a objetos** es un paradigma de programación que usa "objetos" para representar datos y métodos. En el contexto de bases de datos, permite almacenar objetos complejos directamente.

```java
// Ejemplo de clase en Java
public class Empleado {
    private int id;
    private String nombre;
    private Date fechaNacimiento;
    private List<Proyecto> proyectos;
    
    public double calcularSalario() { /* ... */ }
    public void agregarProyecto(Proyecto p) { /* ... */ }
}
```

### 1.2 Comparación: Relacional vs Orientado a Objetos

| Aspecto | Modelo Relacional | Modelo Orientado a Objetos |
|---------|------------------|---------------------------|
| **Unidad básica** | Tupla/Registro | Objeto |
| **Datos complejos** | Normalizados en múltiples tablas | Objeto completo |
| **Comportamiento** | Stored procedures externos | Métodos del objeto |
| **Identidad** | Clave primaria | OID (Object Identifier) |
| **Herencia** | No soportada | Nativamente soportada |
| **Consultas** | SQL | OQL, métodos |

### 1.3 Ventajas del Modelo OO

- **Representación natural:** Modela el mundo real de forma más intuitiva
- **Datos complejos:** Maneja estructuras anidadas sin normalización
- **Reutilización:** Herencia permite compartir código
- **Encapsulamiento:** Datos y métodos juntos
- **Consistencia:** Mantiene integridad del objeto

---

## 2. Estructura de Objetos

### 2.1 Componentes de un Objeto

```
┌─────────────────────────────────────────────────────────────┐
│                    ESTRUCTURA DE OBJETO                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    OBJETO                          │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │ OID: 1001                                   │   │   │
│  │  ├─────────────────────────────────────────────┤   │   │
│  │  │              ESTADO (Atributos)             │   │   │
│  │  │  - id: 1                                    │   │   │
│  │  │  - nombre: "Juan García"                   │   │   │
│  │  │  - salario: 75000.00                       │   │   │
│  │  ├─────────────────────────────────────────────┤   │   │
│  │  │           COMPORTAMIENTO (Métodos)          │   │   │
│  │  │  + calcularSalario()                       │   │   │
│  │  │  + obtenerBonificacion()                    │   │   │
│  │  │  + cambiarDepartamento(dept)                │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Tipos de Atributos en Objetos

```java
// Atributos primitivos
private int edad;
private String nombre;
private double salario;

// Referencias a otros objetos
private Departamento dept;
private List<Proyecto> proyectos;

// Colecciones
private Set<String> telefonos;
private Map<String, Direccion> direcciones;
```

### 2.3 OID (Object Identifier)

```sql
-- En bases de datos orientadas a objetos (ej. ObjectDB)
CREATE TYPE Empleado AS OBJECT (
    oid INTEGER PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    salario DECIMAL(10,2),
    fecha_contratacion DATE
);
```

**Características del OID:**
- Único y permanente (no cambia)
- Asignado por el sistema
- Invisible para el usuario
- Independiente de los datos

---

## 3. Clasificación y Jerarquía de Clases

### 3.1 Clases y Objetos

```java
// Definición de clase
public class Persona {
    protected String nombre;
    protected Date fechaNacimiento;
    
    public String obtenerEdad() { /* ... */ }
}

// Creación de objetos
Persona p1 = new Persona();
Persona p2 = new Persona();
```

### 3.2 Jerarquía de Clases

```
┌─────────────────────────────────────────────────────────────┐
│              JERARQUÍA DE CLASES                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                          ┌─────────────┐                   │
│                          │   PERSONA   │  ← Superclase     │
│                          ├─────────────┤                   │
│                          │ nombre      │                   │
│                          │ fechaNac    │                   │
│                          └──────┬──────┘                   │
│                                 │                          │
│            ┌───────────────────┼───────────────────┐      │
│            │                   │                   │      │
│            ▼                   ▼                   ▼      │
│    ┌───────────────┐   ┌───────────────┐   ┌─────────────┐│
│    │   EMPLEADO    │   │   CLIENTE     │   │  PROVEEDOR │ │
│    ├───────────────┤   ├───────────────┤   ├─────────────┤│
│    │ salario       │   │ credito       │   │ productos   │ │
│    │ puesto        │   │ limite        │   │ contratos   │ │
│    └───────┬───────┘   └───────────────┘   └──────┬──────┘│
│            │                                       │       │
│            │                   │                   │       │
│            ▼                   ▼                   ▼       │
│    ┌───────────────┐   ┌───────────────┐   ┌─────────────┐│
│    │ GERENTE      │   │ VIP           │   │ FABRICANTE  │ │
│    │ ├─ bono       │   │ └─ descuento  │   │ └─ marca    │ │
│    │ └─ equipo     │   │ └─ asesor     │   │ └─ pais     │ │
│    └───────────────┘   └───────────────┘   └─────────────┘│
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.3 Especialización y Generalización

```java
// Generalización
public abstract class Persona {
    protected String nombre;
    protected String email;
    
    public abstract String obtenerTipo();
}

// Especialización - Empleado
public class Empleado extends Persona {
    private double salario;
    private String departamento;
    
    @Override
    public String obtenerTipo() {
        return "Empleado";
    }
}

// Especialización - Cliente
public class Cliente extends Persona {
    private double limiteCredito;
    private String categoria;
    
    @Override
    public String obtenerTipo() {
        return "Cliente";
    }
}
```

---

## 4. Herencia y Herencia Múltiple

### 4.1 Herencia Simple

```java
// Herencia simple: una clase deriva de una sola superclase
public class Gerente extends Empleado {
    private double bonoGerencial;
    private List<Empleado> equipo;
    
    public double calcularSalarioTotal() {
        return salario + bonoGerencial;
    }
}
```

### 4.2 Herencia Múltiple

```java
// Herencia múltiple: una clase deriva de múltiples superclases
public class ManagerTecnico extends Gerente, EmpleadoEspecial {
    // Accede a atributos y métodos de ambas superclases
}

// Ejemplo más común: Interfaces
public interface Gestionable {
    void gestionar();
}

public interface Reporteable {
    void generarReporte();
}

public class Proyecto implements Gestionable, Reporteable {
    // Debe implementar ambos interfaces
}
```

### 4.3 Tipos de Herencia en BD OO

```sql
-- Herencia por tabla única (SINGLE TABLE)
CREATE TABLE personas_oo (
    oid INTEGER PRIMARY KEY,
    tipo VARCHAR(20),           -- Discriminador
    -- Atributos comunes
    nombre VARCHAR(100),
    email VARCHAR(100),
    -- Atributos específicos
    salario DECIMAL(10),         -- Para EMPLEADO
    limite_credito DECIMAL(10), -- Para CLIENTE
    PRIMARY KEY (oid),
    CHECK (tipo IN ('EMPLEADO', 'CLIENTE', 'PROVEEDOR'))
);

-- Herencia por clase concreta (CONCRETE TABLE)
CREATE TABLE empleados_oo (
    oid INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    salario DECIMAL(10)
);

CREATE TABLE clientes_oo (
    oid INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    limite_credito DECIMAL(10)
);

-- Herencia por clase (CLASS TABLE) - Recomendada
CREATE TABLE personas_base_oo (
    oid INTEGER PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    tipo VARCHAR(20) NOT NULL,
    PRIMARY KEY (oid)
);

CREATE TABLE empleados_oo (
    oid INTEGER PRIMARY KEY,
    FOREIGN KEY (oid) REFERENCES personas_base_oo(oid),
    salario DECIMAL(10),
    FOREIGN KEY (oid) REFERENCES personas_base_oo(oid) ON DELETE CASCADE
);
```

---

## 5. Diseño Lógico de Bases de Datos OO

### 5.1 Principios de Diseño

```
┌─────────────────────────────────────────────────────────────┐
│            DISEÑO LÓGICO BD ORIENTADA A OBJETOS            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PASOS:                                                     │
│  1. Identificar clases del dominio                         │
│  2. Definir atributos y tipos                              │
│  3. Establecer relaciones entre clases                     │
│  4. Implementar jerarquías (herencia)                      │
│  5. Definir métodos y comportamientos                     │
│  6. Especificar restricciones de integridad                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 Ejemplo de Diseño OO

```java
// Diagrama de clases UML
public class Empresa {
    private String nombre;
    private List<Departamento> departamentos;
    private List<Empleado> empleados;
}

public class Departamento {
    private String nombre;
    private Empleado gerente;
    private List<Empleado> personal;
    private List<Proyecto> proyectos;
}

public class Empleado extends Persona {
    private double salario;
    private Date fechaContratacion;
    private Departamento departamento;
    private List<Proyecto> asignaciones;
}

public class Proyecto {
    private String nombre;
    private Date fechaInicio;
    private Date fechaFin;
    private List<Empleado> equipo;
    private double presupuesto;
}
```

### 5.3 Mapeo OO a BD Relacional

```sql
-- Estrategia: Mapeo de objetos complejos

-- 1. Tabla para Empleado con campos normales
CREATE TABLE empleado_oo (
    oid SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    salario DECIMAL(10,2),
    id_departamento INT,
    oid_gerente BIGINT REFERENCES empleado_oo(oid),
    CONSTRAINT fk_dept FOREIGN KEY (id_departamento) 
        REFERENCES departamento_oo(id)
);

-- 2. Tabla para datos anidados (colecciones)
CREATE TABLE empleado_telefonos_oo (
    oid_empleado BIGINT REFERENCES empleado_oo(oid),
    telefono VARCHAR(20),
    tipo ENUM('casa', 'trabajo', 'movil'),
    PRIMARY KEY (oid_empleado, telefono)
);

-- 3. Tabla para objetos embebidos (Embeddable)
CREATE TYPE direccion_t AS (
    calle VARCHAR(200),
    ciudad VARCHAR(100),
    cp VARCHAR(10),
    pais VARCHAR(50)
);

CREATE TABLE empleado_direccion_oo (
    oid BIGINT REFERENCES empleado_oo(oid),
    tipo ENUM('casa', 'trabajo'),
    direccion direccion_t,
    PRIMARY KEY (oid, tipo)
);
```

---

## 6. Consultas en Bases de Datos Orientadas a Objetos

### 6.1 OQL (Object Query Language)

```sql
-- OQL es el lenguaje de consultas para BD OO (estándar ODMG)

-- Consultas básicas
SELECT e FROM Empleado e WHERE e.salario > 50000

-- Consultas con herencia
SELECT * FROM Persona p WHERE p instanceof Gerente

-- Consultas con navegación
SELECT e.nombre FROM Empleado e 
WHERE e.departamento.nombre = 'TI'

-- Consultas con colecciones
SELECT p FROM Proyecto p 
WHERE p.equipo IS NOT EMPTY

-- Agregación
SELECT AVG(e.salario) FROM Empleado e
```

### 6.2 Consultas con Métodos

```java
// OQL con invocación de métodos
SELECT e FROM Empleado e 
WHERE e.calcularSalarioTotal() > 100000

// Método en colección
SELECT p FROM Proyecto p 
WHERE p.obtenerDiasRestantes() < 30
```

### 6.3 SQL con Extensiones Orientadas a Objetos

```sql
-- Oracle: Tipos de objetos
CREATE TYPE direccion_typ AS OBJECT (
    calle VARCHAR2(200),
    ciudad VARCHAR2(100),
    cp VARCHAR2(10),
    pais VARCHAR2(50)
) NOT FINAL;

CREATE TYPE empleado_typ AS OBJECT (
    oid NUMBER,
    nombre VARCHAR2(100),
    direccion direccion_typ,
    MEMBER FUNCTION obtenerEdad RETURN NUMBER
) NOT FINAL;

-- Uso de objetos en consultas
SELECT e.nombre, e.direccion.ciudad 
FROM empleado_typ e
WHERE e.direccion.pais = 'México';
```

### 6.4 Comparación de Lenguajes de Consulta

| Característica | SQL | OQL | LINQ |
|----------------|-----|-----|------|
| **Paradigma** | Relacional | Orientado a Objetos | OO-Integrado |
| **Objetos** | Tablas | Objetos reales | Colecciones |
| **Herencia** | No | Sí | Sí |
| **Métodos** | No | Sí | Sí |
| **Complejidad** | Moderada | Alta | Variable |

---

## 📝 Resumen del Módulo

- **Modelo OO:** Usa objetos que combinan datos y comportamiento
- **OID:** Identificador único de objeto asignado por el sistema
- **Herencia:** Permite crear jerarquías de clases
- **Consultas:** OQL para BD OO, SQL con extensiones para BD híbridas
- **Diseño:** Mapeo de clases a tablas con estrategias específicas

---

## ➡️ Próximo Módulo

[Módulo 8: Sistemas Relacionales y Extendidos](08-sistemas-relacionales/01-modelo-logico.md)