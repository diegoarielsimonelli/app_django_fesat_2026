# --- ETAPA 1: COMPILACIÓN (BUILDER) ---
FROM python:3.12-slim-bookworm AS builder

# Instalar uv copiando los binarios directamente de la imagen oficial
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Variables de entorno para optimizar la compilación de uv
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# 1. Copiar archivos de dependencias para aprovechar la caché de Docker
COPY pyproject.toml uv.lock ./

# 2. Instalar dependencias externas
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project

# 3. Copiar todo el código para terminar la instalación
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project


# --- ETAPA 2: PRODUCCIÓN ---
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copiamos el entorno virtual compilado desde el builder
COPY --from=builder /app/.venv /app/.venv

# Copiamos TODOS los archivos directamente a /app
COPY . .

# Variables de entorno esenciales
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH="/app"

# COMANDO DINÁMICO: Busca dónde quedó manage.py y ejecuta collectstatic desde ahí
RUN MANAGE_PATH=$(find . -name "manage.py" | head -n 1) && \
    if [ -z "$MANAGE_PATH" ]; then echo "ERROR: No se encontró manage.py en ningún lado"; exit 1; fi && \
    cd $(dirname "$MANAGE_PATH") && \
    python manage.py collectstatic --no-input

EXPOSE 10000

# Iniciamos Gunicorn buscando automáticamente la carpeta raíz del proyecto Django
CMD MANAGE_PATH=$(find . -name "manage.py" | head -n 1) && \
    cd $(dirname "$MANAGE_PATH") && \
    exec gunicorn --chdir . proyecto_1.wsgi:application --bind 0.0.0.0:10000
