#!/usr/bin/env bash
# Salir inmediatamente si ocurre un error
set -o errexit

# Sincronizar las dependencias usando uv.lock de manera exacta
# Sincronizar las dependencias sin intentar instalar el proyecto actual como paquete
uv sync --frozen --no-install-project


# Compilar archivos estáticos y ejecutar migraciones usando el entorno virtual de uv
uv run python manage.py collectstatic --no-input
uv run python manage.py migrate
