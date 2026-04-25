# 🐘 Aprovisionamiento de PostgreSQL en Ubuntu

> Guía completa para instalar, asegurar y configurar PostgreSQL con usuario administrador y base de datos lista para producción.

---

## 📋 Requisitos previos

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl gnupg2 ca-certificates lsb-release pwgen
```

> **`pwgen`** se usará para generar contraseñas seguras aleatorias.

---

## 1. Instalación (repositorio oficial PGDG)

```bash
# Agregar clave GPG y repositorio oficial de PostgreSQL
sudo install -d /usr/share/postgresql-common/pgdg

sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail \
  https://www.postgresql.org/media/keys/ACCC4CF8.asc

sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] \
  https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
  > /etc/apt/sources.list.d/pgdg.list'

sudo apt update
sudo apt install -y postgresql-16 postgresql-client-16

sudo systemctl enable --now postgresql
sudo systemctl status postgresql
```

---

## 2. Generar contraseña segura para el superusuario `postgres`

```bash
# Genera una contraseña aleatoria de 24 caracteres
PG_ROOT_PASS=$(pwgen -s 24 1)
echo "🔑 Contraseña superusuario 'postgres': $PG_ROOT_PASS"
# ⚠️ Guárdala en un lugar seguro antes de continuar
```

```bash
# Establecer contraseña al rol postgres
sudo -u postgres psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD '${PG_ROOT_PASS}';"
```

---

## 3. Crear base de datos y usuario administrador

```bash
# Generar contraseña para el nuevo usuario
PG_USER_PASS=$(pwgen -s 20 1)
echo "🔑 Contraseña usuario 'pg_admin': $PG_USER_PASS"
```

> **Nota:** Si el locale `es_MX.UTF-8` no está disponible en tu sistema, ejecuta primero:
> ```bash
> sudo locale-gen es_MX.UTF-8 && sudo update-locale
> ```
> O bien reemplázalo por `en_US.UTF-8`.

```bash
sudo -u postgres psql <<EOF
-- Crear rol administrador
CREATE USER pg_admin WITH
  ENCRYPTED PASSWORD '${PG_USER_PASS}'
  CREATEDB
  CREATEROLE
  LOGIN;

-- Crear base de datos con propietario asignado
CREATE DATABASE mi_base_postgres
  OWNER      pg_admin
  ENCODING   'UTF8'
  LC_COLLATE 'es_MX.UTF-8'
  LC_CTYPE   'es_MX.UTF-8'
  TEMPLATE   template0;

-- Otorgar todos los privilegios sobre la BD
GRANT ALL PRIVILEGES ON DATABASE mi_base_postgres TO pg_admin;

-- Verificar roles y bases de datos
\du
\l mi_base_postgres
EOF
```

---

## 4. Configurar autenticación (`pg_hba.conf`)

```bash
# Obtener ruta real del archivo hba
PG_HBA=$(sudo -u postgres psql -t -P format=unaligned -c "SHOW hba_file;")
echo "📄 Archivo hba: $PG_HBA"

# Hacer backup antes de modificar
sudo cp "$PG_HBA" "${PG_HBA}.bak"

# Agregar reglas para el nuevo usuario y BD
sudo tee -a "$PG_HBA" > /dev/null <<EOF

# ── Reglas personalizadas ──────────────────────────────────────────
host    mi_base_postgres    pg_admin    127.0.0.1/32    scram-sha-256
host    mi_base_postgres    pg_admin    ::1/128         scram-sha-256
EOF

# Recargar configuración sin reiniciar el servicio
sudo systemctl reload postgresql
```

---

## 5. Configuración recomendada (`postgresql.conf`)

```bash
sudo tee /etc/postgresql/16/main/conf.d/99-custom.conf > /dev/null <<EOF
# ── Conexiones ────────────────────────────────────────
max_connections         = 100
listen_addresses        = 'localhost'

# ── Memoria ───────────────────────────────────────────
shared_buffers          = 256MB
work_mem                = 4MB
maintenance_work_mem    = 64MB
effective_cache_size    = 1GB

# ── WAL / Durabilidad ─────────────────────────────────
wal_level               = replica
synchronous_commit      = on

# ── Logs ──────────────────────────────────────────────
log_min_duration_statement  = 1000
log_line_prefix             = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h '
log_timezone                = 'America/Mexico_City'

# ── Localización ──────────────────────────────────────
timezone                = 'America/Mexico_City'
lc_messages             = 'es_MX.UTF-8'
EOF

sudo systemctl restart postgresql
```

---

## 6. Verificación

```bash
# Conectarse con el nuevo usuario vía TCP
psql -h 127.0.0.1 -U pg_admin -d mi_base_postgres -c "\conninfo"

# Listar bases de datos
psql -h 127.0.0.1 -U pg_admin -d mi_base_postgres -c "\l"

# Listar roles del sistema (como postgres)
sudo -u postgres psql -c "\du"

# Puerto escuchando
sudo ss -tlnp | grep 5432
```

---

## 7. Firewall (recomendado si la BD es solo local)

```bash
sudo ufw deny 5432
sudo ufw enable
sudo ufw status
```

---

## 🔐 Resumen de credenciales

| Rol          | Usuario    | Contraseña          | Base de datos       |
|--------------|------------|---------------------|---------------------|
| Superusuario | `postgres` | `$PG_ROOT_PASS`     | — (global)          |
| Administrador| `pg_admin` | `$PG_USER_PASS`     | `mi_base_postgres`  |

> ⚠️ **Nunca** almacenes contraseñas en texto plano en el servidor. Usa herramientas como **HashiCorp Vault**, **AWS Secrets Manager** o al menos un archivo `.env` con permisos `600` fuera del repositorio.

---

## ✅ Checklist final

- [ ] Servicio activo: `sudo systemctl is-active postgresql`
- [ ] Puerto `5432` escuchando: `sudo ss -tlnp | grep 5432`
- [ ] Acceso al superusuario `postgres` con contraseña funcionando
- [ ] Usuario `pg_admin` puede conectarse y operar sobre `mi_base_postgres`
- [ ] Archivo `99-custom.conf` aplicado sin errores: `sudo journalctl -u postgresql -n 20`
- [ ] Reglas en `pg_hba.conf` recargadas correctamente
- [ ] Contraseñas guardadas en gestor de secretos