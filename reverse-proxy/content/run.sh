#!/usr/bin/env bash
set -e
set -x

mkdir -p /app/logs
nginx -c /app/config/nginx.conf
