# 🐘 Aprovisionamiento de PostgreSQL en Ubuntu

> Guía para instalar y configurar PostgreSQL para entornos de prueba.

---

## 📋 Requisitos previos

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y postgresql postgresql-client
```

---

## 1. Instalación

```bash
sudo apt install -y postgresql postgresql-client
sudo systemctl enable --now postgresql
sudo systemctl status postgresql
```

---

## 2. Configurar contraseña para el superusuario `postgres`

```bash
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '123456';"
```

---

## 3. Crear base de datos y usuario administrador

```bash
sudo -u postgres psql
```

```sql
-- Crear rol administrador
CREATE USER pg_admin WITH
  PASSWORD 'password'
  CREATEDB
  CREATEROLE
  LOGIN;

-- Crear base de datos con propietario asignado
CREATE DATABASE mi_base_postgres
  OWNER pg_admin
  ENCODING 'UTF8';

-- Verificar
\du
\l
```

---

## 4. Configuración para acceso remoto

Editar `postgresql.conf`:
```bash
sudo nano /etc/postgresql/*/main/postgresql.conf
```

Cambiar:
```ini
listen_addresses = '*'
```

Editar `pg_hba.conf`:
```bash
sudo nano /etc/postgresql/*/main/pg_hba.conf
```

Agregar:
```conf
host    mi_base_postgres    pg_admin    0.0.0.0/0    md5
```

Reiniciar el servicio:
```bash
sudo systemctl restart postgresql
```

---

## 5. Verificación

```bash
# Conectarse localmente
psql -U pg_admin -d mi_base_postgres

# Listar bases de datos
psql -U pg_admin -c "\l"

# Ver usuarios
sudo -u postgres psql -c "\du"

# Puerto escuchando
sudo ss -tlnp | grep 5432
```

---

## 6. Credenciales por defecto

| Rol | Usuario | Contraseña | Host |
|-----|---------|------------|------|
| Superusuario | `postgres` | `123456` | `localhost` |
| Admin | `pg_admin` | `password` | `localhost` / `%` |

---

## ✅ Checklist final

- [ ] Servicio activo: `sudo systemctl is-active postgresql`
- [ ] Puerto 5432 escuchando: `sudo ss -tlnp \| grep 5432`
- [ ] Usuario `pg_admin` puede conectarse