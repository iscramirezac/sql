# Instalación y Configuración de Apache2

## Guía Funcional para Debian/Ubuntu

---

## Índice
1. [Requisitos previos](#requisitos-previos)
2. [Instalación de Apache2](#instalación-de-apache2)
3. [Configuración básica](#configuración-básica)
4. [Sitios virtuales](#sitios-virtuales)
5. [Módulos comunes](#módulos-comunes)
6. [Seguridad básica](#seguridad-básica)
7. [Mantenimiento y logs](#mantenimiento-y-logs)
8. [Solución de problemas](#solución-de-problemas)
9. [Comandos rápidos](#comandos-rápidos)

---

## Requisitos previos

```bash
# Actualizar sistema
sudo apt update

# Verificar espacio en disco
df -h

# Verificar conectividad
ping -c 3 google.com
```

---

## Instalación de Apache2

### Paso 1: Instalar Apache

```bash
sudo apt install apache2 -y
```

### Paso 2: Verificar instalación

```bash
# Estado del servicio
sudo systemctl status apache2

# Versión instalada
apache2 -v

# Verificar puerto 80
sudo ss -tlnp | grep :80
```

### Paso 3: Habilitar autoinicio

```bash
sudo systemctl enable apache2
```

### Paso 4: Probar servidor

```bash
# Obtener IP local
ip addr show

# En navegador: http://TU_IP_LOCAL
# Ver página por defecto de Apache
```

---

## Configuración básica

### Estructura de directorios

```
/etc/apache2/
├── apache2.conf           # Configuración principal
├── ports.conf             # Puertos (80, 443)
├── conf-available/        # Configs disponibles
├── conf-enabled/          # Configs activas
├── sites-available/       # Virtual hosts disponibles
├── sites-enabled/         # Virtual hosts activos
└── mods-available/        # Módulos disponibles
    └── mods-enabled/      # Módulos activados

/var/www/html/             # Raíz por defecto
/var/log/apache2/
    ├── access.log         # Accesos
    └── error.log          # Errores
```

### Probar sintaxis

```bash
sudo apache2ctl configtest
# Salida esperada: Syntax OK
```

### Comandos de gestión

```bash
sudo systemctl reload apache2   # Recargar (sin corte)
sudo systemctl restart apache2  # Reiniciar
sudo systemctl stop apache2     # Detener
sudo systemctl start apache2    # Iniciar
```

---

## Sitios virtuales

### Crear sitio virtual

**Paso 1:** Crear directorio

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

Contenido:
```html
<!DOCTYPE html>
<html>
<head><title>midominio.com</title></head>
<body>
    <h1>Sitio virtual funcionando</h1>
</body>
</html>
```

**Paso 4:** Configuración del virtual host

```bash
sudo nano /etc/apache2/sites-available/midominio.com.conf
```

```apache
<VirtualHost *:80>
    ServerName midominio.com
    ServerAlias www.midominio.com
    ServerAdmin webmaster@midominio.com

    DocumentRoot /var/www/midominio.com/public_html
    DirectoryIndex index.html index.php

    ErrorLog ${APACHE_LOG_DIR}/midominio.com_error.log
    CustomLog ${APACHE_LOG_DIR}/midominio.com_access.log combined

    <Directory /var/www/midominio.com/public_html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

**Paso 5:** Activar sitio

```bash
# Desactivar sitio por defecto
sudo a2dissite 000-default.conf

# Activar nuevo sitio
sudo a2ensite midominio.com.conf

# Recargar Apache
sudo systemctl reload apache2
```

**Paso 6:** Probar localmente

Editar `/etc/hosts`:
```
127.0.0.1   midominio.com
```

Navegador: `http://midominio.com`

---

## Módulos comunes

### Listar módulos activos

```bash
apache2ctl -M
```

### Habilitar módulos

```bash
# Reescritura de URLs
sudo a2enmod rewrite

# Compresión gzip
sudo a2enmod deflate

# Headers (seguridad)
sudo a2enmod headers

# Proxy (reverse proxy)
sudo a2enmod proxy
sudo a2enmod proxy_http

# PHP (requiere PHP instalado)
sudo a2enmod php7.4  # Ajustar versión

# Aplicar cambios
sudo systemctl restart apache2
```

### Deshabilitar módulos

```bash
sudo a2dismod modulo_no_deseado
sudo systemctl restart apache2
```

---

## Seguridad básica

### Ocultar información de versión

```bash
sudo nano /etc/apache2/conf-available/security.conf
```

```apache
ServerTokens Prod
ServerSignature Off
```

```bash
sudo a2enconf security
sudo systemctl reload apache2
```

### Deshabilitar listado de directorios

En el virtual host:
```apache
<Directory /var/www/midominio.com/public_html>
    Options -Indexes
    AllowOverride All
    Require all granted
</Directory>
```

### Bloquear archivos sensibles

Crear `/var/www/midominio.com/public_html/.htaccess`:
```
<Files ~ "\.(env|git|log|md|sql)$">
    Order allow,deny
    Deny from all
</Files>
```

### Limitar tamaño de upload

Editar `/etc/apache2/conf-available/apache2.conf`:
```apache
<Directory /var/www/>
    AllowOverride All
    LimitRequestBody 10485760  # 10 MB
</Directory>
```

---

## Mantenimiento y logs

### Leer logs de acceso

```bash
# En tiempo real
sudo tail -f /var/log/apache2/access.log

# Últimas 100 líneas
sudo tail -100 /var/log/apache2/access.log

# Top 10 IPs visitantes
sudo awk '{print $1}' /var/log/apache2/access.log | sort | uniq -c | sort -nr | head -10

# URLs más solicitadas
sudo awk '{print $7}' /var/log/apache2/access.log | sort | uniq -c | sort -nr | head -10

# Errores 404
sudo grep "404" /var/log/apache2/access.log | awk '{print $7}' | sort | uniq -c | sort -nr | head -10
```

### Leer logs de errores

```bash
sudo tail -f /var/log/apache2/error.log

# Buscar errores específicos
sudo grep "500" /var/log/apache2/error.log

# Ver últimos errores
sudo tail -50 /var/log/apache2/error.log
```

### Rotación automática de logs

Apache incluye logrotate. Verificar:
```bash
cat /etc/logrotate.d/apache2
```

### Actualizar Apache

```bash
sudo apt update
sudo apt upgrade apache2 -y
sudo systemctl restart apache2
```

---

## Solución de problemas

### Apache no inicia

```bash
# Ver estado detallado
sudo systemctl status apache2 -l

# Probar configuración
sudo apache2ctl configtest

# Verificar puerto en uso
sudo lsof -i :80
sudo lsof -i :443

# Iniciar manualmente para ver errores
sudo apache2ctl start
```

### Error 403 Forbidden

```bash
# Verificar permisos
ls -la /var/www/midominio.com/public_html/

# Cambiar propietario
sudo chown -R www-data:www-data /var/www/midominio.com/public_html

# Verificar configuración <Directory>
cat /etc/apache2/sites-available/midominio.com.conf | grep -A 5 "<Directory"
```

### Error 404 Not Found

```bash
# Verificar que archivo existe
ls -la /var/www/midominio.com/public_html/index.html

# Verificar DocumentRoot
grep DocumentRoot /etc/apache2/sites-available/midominio.com.conf

# Verificar DirectoryIndex
grep DirectoryIndex /etc/apache2/apache2.conf
```

### Alto consumo de memoria

```bash
# Ver procesos Apache
ps aux | grep apache2

# Ajustar workers (prefork)
sudo nano /etc/apache2/mods-available/mpm_prefork.conf
# MaxRequestWorkers por defecto: 150
# Reducir si hay poca RAM

sudo systemctl restart apache2
```

### Problemas con módulo PHP

```bash
# Verificar PHP habilitado
apache2ctl -M | grep php

# Versión PHP
php -v

# Errores PHP en日志
sudo tail -f /var/log/apache2/error.log
```

---

## Comandos rápidos

```bash
# Servicio
sudo systemctl status apache2
sudo systemctl restart apache2
sudo systemctl reload apache2

# Configuración
sudo apache2ctl configtest
ls /etc/apache2/sites-enabled/
apache2ctl -M

# Red y procesos
sudo ss -tlnp | grep :80
ps aux | grep apache2

# Logs
sudo tail -f /var/log/apache2/access.log
sudo tail -f /var/log/apache2/error.log
```

---

## Referencias

- [Documentación Apache](https://httpd.apache.org/docs/)
- [Ubuntu Server Docs](https://ubuntu.com/server/docs/web-servers-apache)
- [DigitalOcean: Apache](https://www.digitalocean.com/community/tutorials/how-to-set-up-apache-virtual-hosts-on-ubuntu-20-04)

---

**Nota:** Tutorial para Debian/Ubuntu. En RHEL/CentOS usar `yum install httpd` y `/etc/httpd/conf/`. En Arch: `pacman -S apache` y `/etc/httpd/conf/`.
