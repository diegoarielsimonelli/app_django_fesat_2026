FROM python:3.14-slim-bookworm

# Instalar uv copiando los binarios directamente de la imagen oficial (más rápido y seguro que curl)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Variables de entorno clave para que uv no intente descargar otro Python
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_PREFERENCE=only-system

# 1. Copiar archivos de dependencias
COPY pyproject.toml uv.lock ./

# 2. Instalar dependencias del proyecto (omitiendo el paquete raíz)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project

# 3. Copiar el resto del código
COPY . .

# 4. Configurar variables de entorno para que Python y Django encuentren todo
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

EXPOSE 10000

# Comando unificado de arranque: Busca manage.py, entra a su carpeta, corre migraciones, collectstatic y levanta gunicorn
CMD MANAGE_PATH=$(find . -name "manage.py" | head -n 1) && \
    if [ -z "$MANAGE_PATH" ]; then echo "ERROR: No se encontro manage.py"; exit 1; fi && \
    cd $(dirname "$MANAGE_PATH") && \
    python manage.py migrate --no-input && \
    python manage.py collectstatic --no-input && \
    exec gunicorn proyecto_1.wsgi:application --bind 0.0.0.0:10000
