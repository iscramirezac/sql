# 🔵 Aprovisionamiento de MariaDB en Ubuntu

> Guía completa para instalar, asegurar y configurar MariaDB con usuario administrador y base de datos lista para producción.

---

## 📋 Requisitos previos

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl gnupg2 ca-certificates lsb-release pwgen
```

> **`pwgen`** se usará para generar contraseñas seguras aleatorias.

---

## 1. Instalación

```bash
sudo apt install -y mariadb-server mariadb-client
sudo systemctl enable --now mariadb
sudo systemctl status mariadb
```

---

## 2. Generar contraseña segura para root

```bash
# Genera una contraseña aleatoria de 24 caracteres
MARIADB_ROOT_PASS=$(pwgen -s 24 1)
echo "🔑 Contraseña root MariaDB: $MARIADB_ROOT_PASS"
# ⚠️ Guárdala en un lugar seguro antes de continuar
```
O (opción reomendada)
```bash
sudo mysql_secure_installation
```
---

## 3. Asegurar la instalación

Equivalente a ejecutar `mysql_secure_installation` de forma desatendida:

```bash
sudo mariadb <<EOF
-- Establecer contraseña para root
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASS}';

-- Eliminar usuarios anónimos
DELETE FROM mysql.user WHERE User='';

-- Deshabilitar acceso remoto para root
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Eliminar base de datos de prueba
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

-- Aplicar cambios
FLUSH PRIVILEGES;
EOF
```

---

## 4. Crear base de datos y usuario administrador

```bash
# Generar contraseña para el nuevo usuario
MARIADB_USER_PASS=$(pwgen -s 20 1)
echo "🔑 Contraseña usuario 'dbadmin': $MARIADB_USER_PASS"

sudo mariadb -u root -p"${MARIADB_ROOT_PASS}" <<EOF
-- Crear base de datos
CREATE DATABASE IF NOT EXISTS mi_base_de_datos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

-- Crear usuario administrador
CREATE USER IF NOT EXISTS 'dbadmin'@'localhost' IDENTIFIED BY '${MARIADB_USER_PASS}';

-- Otorgar TODOS los privilegios sobre la BD
GRANT ALL PRIVILEGES ON mi_base_de_datos.* TO 'dbadmin'@'localhost';

-- (Opcional) Privilegios globales si se requiere superusuario completo
-- GRANT ALL PRIVILEGES ON *.* TO 'dbadmin'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;

-- Verificar privilegios asignados
SHOW GRANTS FOR 'dbadmin'@'localhost';
EOF
```

---

## 5. Configuración recomendada

Crear archivo de configuración personalizado en `/etc/mysql/mariadb.conf.d/`:

```bash
sudo tee /etc/mysql/mariadb.conf.d/99-custom.cnf > /dev/null <<EOF
[mysqld]
# ── Seguridad ────────────────────────────────────────
local-infile          = 0
symbolic-links        = 0

# ── Rendimiento ──────────────────────────────────────
innodb_buffer_pool_size   = 256M
max_connections           = 150
query_cache_size          = 0
query_cache_type          = 0

# ── Logs ─────────────────────────────────────────────
slow_query_log        = 1
slow_query_log_file   = /var/log/mysql/mariadb-slow.log
long_query_time       = 2

# ── Charset por defecto ───────────────────────────────
character-set-server  = utf8mb4
collation-server      = utf8mb4_unicode_ci
EOF

sudo systemctl restart mariadb
```

---

## 6. Verificación

```bash
# Conectarse con el nuevo usuario
mariadb -u dbadmin -p"${MARIADB_USER_PASS}" mi_base_de_datos \
  -e "SELECT DATABASE(), USER(), VERSION();"

# Listar bases de datos visibles para el usuario
mariadb -u dbadmin -p"${MARIADB_USER_PASS}" -e "SHOW DATABASES;"

# Listar todos los usuarios del sistema (como root)
sudo mariadb -u root -p"${MARIADB_ROOT_PASS}" \
  -e "SELECT User, Host, plugin FROM mysql.user;"

# Puerto escuchando
sudo ss -tlnp | grep 3306
```

---

## 7. Firewall (recomendado si la BD es solo local)

```bash
sudo ufw deny 3306
sudo ufw enable
sudo ufw status
```

---

## 🔐 Resumen de credenciales

| Rol         | Usuario   | Contraseña               | Base de datos      |
|-------------|-----------|--------------------------|--------------------|
| Superusuario| `root`    | `$MARIADB_ROOT_PASS`     | — (global)         |
| Administrador| `dbadmin`| `$MARIADB_USER_PASS`     | `mi_base_de_datos` |

> ⚠️ **Nunca** almacenes contraseñas en texto plano en el servidor. Usa herramientas como **HashiCorp Vault**, **AWS Secrets Manager** o al menos un archivo `.env` con permisos `600` fuera del repositorio.

---

## ✅ Checklist final

- [ ] Servicio activo: `sudo systemctl is-active mariadb`
- [ ] Puerto `3306` escuchando: `sudo ss -tlnp | grep 3306`
- [ ] Acceso root con contraseña funcionando
- [ ] Usuario `dbadmin` puede conectarse y operar sobre `mi_base_de_datos`
- [ ] Archivo `99-custom.cnf` aplicado sin errores en el log: `sudo journalctl -u mariadb -n 20`
- [ ] Contraseñas guardadas en gestor de secretos