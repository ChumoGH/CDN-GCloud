#!/usr/bin/env bash
set -euo pipefail

# Cloud Run siempre inyecta esta variable
: "${PORT:?La variable PORT debe estar definida por Cloud Run}"
# Solo pedimos una variable: el destino al que proxyar
: "${PROXY_UPSTREAM:?Define PROXY_UPSTREAM (ej: api.example.com:8080 o 10.0.0.5:8000)}"

# Generamos el archivo de configuración de Nginx dinámicamente
cat >/etc/nginx/conf.d/default.conf <<NGINX
server {
    listen ${PORT} default_server;
    listen [::]:${PORT} default_server;

    location / {
        proxy_pass http://${PROXY_UPSTREAM};

        # Headers comunes para Cloud Run
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # Timeouts razonables
        proxy_connect_timeout 10s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;

        # WebSocket / HTTP 1.1
        proxy_http_version 1.1;
        proxy_set_header Connection "";

        # No interceptar errores del backend
        proxy_intercept_errors off;
    }
}
NGINX

echo "[entrypoint] Nginx escuchando en :${PORT} -> ${PROXY_UPSTREAM}"
exec nginx -g 'daemon off;'
