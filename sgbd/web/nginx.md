# Instalación y Configuración de Nginx

## Guía Funcional para Debian/Ubuntu

---

## Índice
1. [Requisitos previos](#requisitos-previos)
2. [Instalación de Nginx](#instalación-de-nginx)
3. [Configuración básica](#configuración-básica)
4. [Sitios virtuales](#sitios-virtuales)
5. [Proxy inverso](#proxy-inverso)
6. [Optimización](#optimización)
7. [Seguridad](#seguridad)
8. [Mantenimiento y logs](#mantenimiento-y-logs)
9. [Solución de problemas](#solución-de-problemas)
10. [Comandos rápidos](#comandos-rápidos)

---

## Requisitos previos

```bash
sudo apt update
ping -c 3 google.com
sudo ss -tlnp | grep -E ':80|:443'
```

---

## Instalación de Nginx

### Paso 1: Instalar

```bash
sudo apt install nginx -y
```

### Paso 2: Verificar

```bash
sudo systemctl status nginx
nginx -v
sudo ss -tlnp | grep :80
```

### Paso 3: Habilitar autoinicio

```bash
sudo systemctl enable nginx
```

### Paso 4: Probar

```bash
ip addr show
# Navegador: http://TU_IP_LOCAL
# Debería mostrar "Welcome to nginx!"
```

### Paso 5: Firewall

```bash
sudo ufw allow 80/tcp
sudo ufw status
```

---

## Configuración básica

### Estructura de directorios

```
/etc/nginx/
├── nginx.conf            # Config principal
├── conf-available/       # Configs disponibles
├── conf-enabled/         # Configs activas
├── sites-available/      # Server blocks disponibles
├── sites-enabled/        # Server blocks activos
└── modules-available/    # Módulos disponibles

/var/www/html/            # Raíz por defecto
/var/log/nginx/
    ├── access.log
    └── error.log
```

### Probar sintaxis

```bash
sudo nginx -t
```

### Comandos de gestión

```bash
sudo systemctl reload nginx   # Recargar
sudo systemctl restart nginx  # Reiniciar
sudo systemctl stop nginx     # Detener
sudo systemctl start nginx    # Iniciar
```

---

## Sitios virtuales

### Crear sitio virtual

**Paso 1:** Directorio

```bash
sudo mkdir -p /var/www/midominio.com/public_html
```

**Paso 2:** Permisos

```bash
sudo chown -R $USER:$USER /var/www/midominio.com/public_html
sudo chmod -R 755 /var/www
```

**Paso 3:** Página de prueba

```bash
nano /var/www/midominio.com/public_html/index.html
```

```html
<!DOCTYPE html>
<html>
<head><title>midominio.com</title></head>
<body>
    <h1>Sitio Nginx funcionando</h1>
</body>
</html>
```

**Paso 4:** Configuración del server block

```bash
sudo nano /etc/nginx/sites-available/midominio.com
```

```nginx
server {
    listen 80;
    listen [::]:80;

    root /var/www/midominio.com/public_html;
    index index.html index.htm index.php;

    server_name midominio.com www.midominio.com;

    access_log /var/log/nginx/midominio.com.access.log;
    error_log /var/log/nginx/midominio.com.error.log;

    location / {
        try_files $uri $uri/ =404;
    }

    # Bloquear archivos ocultos
    location ~ /\. {
        deny all;
    }

    # PHP (si se usa)
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }

    # Cache para archivos estáticos
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

**Paso 5:** Activar sitio

```bash
# Eliminar sitio por defecto
sudo rm -f /etc/nginx/sites-enabled/default

# Enlazar sitio
sudo ln -s /etc/nginx/sites-available/midominio.com /etc/nginx/sites-enabled/

# Probar y recargar
sudo nginx -t
sudo systemctl reload nginx
```

**Paso 6:** Probar localmente

```bash
sudo nano /etc/hosts
```

Agregar:
```
127.0.0.1   midominio.com
```

Navegador: `http://midominio.com`

---

## Proxy inverso

### Ejemplo: Aplicación Node.js en puerto 3000

```bash
sudo nano /etc/nginx/sites-available/app-proxy
```

```nginx
server {
    listen 80;
    server_name app.midominio.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Bloquear archivos ocultos
    location ~ /\. {
        deny all;
    }
}
```

Activar:
```bash
sudo ln -s /etc/nginx/sites-available/app-proxy /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

---

## Optimización

### Configuración óptima de `nginx.conf`

Editar `/etc/nginx/nginx.conf`:

```nginx
user www-data;
worker_processes auto;  # CPUs disponibles
pid /run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;  # Ocultar versión

    # Compresión gzip
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    include /etc/nginx/sites-enabled/*;
}
```

Ver módulos instalados:
```bash
nginx -V 2>&1 | grep --color=auto '--add-module'
```

---

## Seguridad

### Ocultar información del servidor

```nginx
server_tokens off;
```

En `http` o en cada `server` block.

### Bloquear archivos sensibles

```nginx
location ~ /\.(?!well-known) {
    deny all;
    log_not_found off;
}

location ~ ~$ {
    deny all;
    log_not_found off;
}
```

### Limitar tamaño de upload

```nginx
client_max_body_size 10M;
```

### Restringir métodos HTTP

```nginx
if ($request_method !~ ^(GET|POST|HEAD)$ ) {
    return 403;
}
```

### Rate limiting

En `http` de `nginx.conf`:
```nginx
limit_req_zone $binary_remote_addr zone=one:10m rate=10r/s;
```

En `server` block:
```nginx
location /login {
    limit_req zone=one burst=20 nodelay;
}
```

### Instalar Fail2ban

```bash
sudo apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

```ini
[nginx-http-auth]
enabled = true

[nginx-botsearch]
enabled = true
```

```bash
sudo systemctl restart fail2ban
```

---

## Mantenimiento y logs

### Leer logs

```bash
# Accesos en tiempo real
sudo tail -f /var/log/nginx/access.log

# Errores
sudo tail -f /var/log/nginx/error.log

# Top 10 IPs
sudo awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -10

# URLs más visitadas
sudo awk '{print $7}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -10

# Errores 404
sudo grep "404" /var/log/nginx/access.log | awk '{print $7}' | sort | uniq -c | sort -nr | head -10
```

### Rotación automática

Nginx incluye logrotate. Verificar:
```bash
cat /etc/logrotate.d/nginx
```

### Limpiar caché

```bash
sudo systemctl restart nginx

# Si usas FastCGI cache
sudo rm -rf /var/lib/nginx/fastcgi_cache/*
```

### Actualizar Nginx

```bash
sudo apt update
sudo apt upgrade nginx -y
sudo systemctl restart nginx
```

---

## Solución de problemas

### Nginx no inicia

```bash
sudo systemctl status nginx -l
sudo nginx -t
sudo ss -tlnp | grep :80
sudo lsof -i :80
```

### Error "Address already in use"

```bash
sudo fuser -k 80/tcp
sudo systemctl start nginx
```

### Error 502 Bad Gateway

```bash
# Verificar backend
systemctl status tu-servicio-backend
sudo netstat -tlnp | grep PUERTO_BACKEND

# Ver logs
sudo tail -20 /var/log/nginx/error.log
```

### Error 403 Forbidden

```bash
ls -la /var/www/midominio.com/public_html/
grep root /etc/nginx/sites-available/midominio.com
sudo aa-status  # AppArmor
```

### Error 404 Not Found

```bash
ls -la /var/www/midominio.com/public_html/
sudo nginx -T  # Ver toda la configuración
```

### Alto consumo de CPU/Memoria

```bash
ps aux | grep nginx
sudo nginx -T 2>&1 | grep -E "worker_processes|worker_connections"
```

Ajustar en `nginx.conf` según memoria disponible.

---

## Comandos rápidos

```bash
# Servicio
sudo systemctl status nginx
sudo systemctl restart nginx
sudo systemctl reload nginx

# Configuración
sudo nginx -t          # Probar sintaxis
sudo nginx -T          # Ver toda la configuración
sudo nginx -V          # Ver módulos compilados

# Logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Procesos y puertos
ps aux | grep nginx
sudo ss -tlnp | grep :80

# Sitios
ls -la /etc/nginx/sites-enabled/
ls -la /etc/nginx/sites-available/

# Corregir configuración rota
sudo rm -f /etc/nginx/sites-enabled/enabled-site.conf
sudo nginx -t && sudo systemctl reload nginx
```

---

## Referencias

- [Documentación Nginx](http://nginx.org/en/docs/)
- [Ubuntu Server Docs](https://ubuntu.com/server/docs/webserver-nginx)
- [DigitalOcean: Nginx](https://www.digitalocean.com/community/tutorials)

---

**Nota:** Tutorial para Debian/Ubuntu. En RHEL/CentOS: `yum install nginx` y `/etc/nginx/conf.d/`. En Arch: `pacman -S nginx`.
