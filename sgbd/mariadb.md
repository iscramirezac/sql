# 🔵 Aprovisionamiento de MariaDB en Ubuntu

> Guía para instalar y configurar MariaDB para entornos de prueba.

---

## 📋 Requisitos previos

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y mariadb-server mariadb-client
```

---

## 1. Instalación

```bash
sudo apt install -y mariadb-server mariadb-client
sudo systemctl enable --now mariadb
sudo systemctl status mariadb
```

---

## 2. Configurar contraseña para root

```bash
sudo mysql_secure_installation
```

Te pedirá:
- Establecer contraseña para root (ej: `123456`)
- Eliminar usuarios anónimos (responde `y`)
- Deshabilitar acceso remoto para root (responde `y`)
- Eliminar base de datos de prueba (responde `y`)
- Recargar privilegios (responde `y`)

---

## 3. Crear base de datos y usuario administrador

```bash
sudo mariadb -u root -p
```

```sql
-- Crear base de datos
CREATE DATABASE mi_base_de_datos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Crear usuario administrador
CREATE USER 'dbadmin'@'localhost' IDENTIFIED BY 'password';

-- Otorgar privilegios sobre la BD
GRANT ALL PRIVILEGES ON mi_base_de_datos.* TO 'dbadmin'@'localhost';

FLUSH PRIVILEGES;
```

---

## 4. Configuración para acceso remoto

Editar archivo de configuración:

```bash
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
```

Cambiar:
```ini
bind-address = 0.0.0.0
```

Reiniciar el servicio:
```bash
sudo systemctl restart mariadb
```

Crear usuario con acceso remoto:
```sql
CREATE USER 'dbadmin'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON mi_base_de_datos.* TO 'dbadmin'@'%';
FLUSH PRIVILEGES;
```

---

## 5. Verificación

```bash
# Conectarse localmente
mariadb -u dbadmin -p mi_base_de_datos

# Listar bases de datos
mariadb -u dbadmin -p -e "SHOW DATABASES;"

# Ver usuarios
sudo mariadb -u root -p -e "SELECT User, Host FROM mysql.user;"

# Puerto escuchando
sudo ss -tlnp | grep 3306
```

---

## 6. Credenciales por defecto

| Rol | Usuario | Contraseña | Host |
|-----|---------|------------|------|
| Root | `root` | la que configuraste | `localhost` |
| Admin | `dbadmin` | `password` | `localhost` / `%` |

---

## ✅ Checklist final

- [ ] Servicio activo: `sudo systemctl is-active mariadb`
- [ ] Puerto 3306 escuchando: `sudo ss -tlnp \| grep 3306`
- [ ] Usuario `dbadmin` puede conectarse