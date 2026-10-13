#!/usr/bin/env bash
# Salir inmediatamente si un comando falla
set -o errexit

# 1. Instalar uv de forma local en el entorno de Render
curl -LsSf https://astral.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# 2. Sincronizar las dependencias del proyecto usando uv
uv sync --frozen --no-dev --no-install-project

# 3. Buscar dónde está manage.py y ejecutar collectstatic
MANAGE_PATH=$(find . -name "manage.py" | head -n 1)
cd $(dirname "$MANAGE_PATH")

# Activar el entorno virtual generado por uv
source ../../.venv/bin/activate

# Ejecutar migraciones y recolectar estáticos
python manage.py collectstatic --no-input
python manage.py migrate
