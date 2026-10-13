#!/usr/bin/env bash
# Salir inmediatamente si ocurre un error
set -o errexit

# Forzar a uv a tratar el proyecto como una app sin buscar empaquetarlo
export UV_PROJECT_ENVIRONMENT=1

# Sincronizar las dependencias de forma limpia
uv sync --frozen --no-install-project

# Compilar archivos estáticos y ejecutar migraciones usando el entorno virtual de uv
uv run python manage.py collectstatic --no-input
uv run python manage.py migrate
