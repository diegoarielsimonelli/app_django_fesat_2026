#!/usr/bin/env bash
# Salir inmediatamente si ocurre un error
set -o errexit

# Instalar 'uv' de forma autónoma en el entorno de Render
curl -LsSf https://astral.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Sincronizar las dependencias usando uv.lock de manera exacta y limpia
uv sync --frozen

# Compilar archivos estáticos y ejecutar migraciones usando el entorno virtual de uv
uv run python manage.py collectstatic --no-input
uv run python manage.py migrate
