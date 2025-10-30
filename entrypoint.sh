#!/usr/bin/env bash
set -euo pipefail

: "${PORT:?La variable PORT debe estar definida por Cloud Run}"
: "${PROXY_UPSTREAM:?Define PROXY_UPSTREAM (ej: api.example.com:8080 o 10.0.0.5:8000)}"

cat >/etc/nginx/conf.d/default.conf <<NGINX
server {
    listen ${
