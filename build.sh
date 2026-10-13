#!/usr/bin/env bash
# Salir inmediatamente si ocurre un error
set -o errexit

# Sincronizar las dependencias usando uv.lock de manera exacta
uv sync --frozen

# Compilar archivos estáticos y ejecutar migraciones usando el entorno virtual de uv
uv run python manage.py collectstatic --no-input
uv run python manage.py migrate
