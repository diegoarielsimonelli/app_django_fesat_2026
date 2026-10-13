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

# Variables de entorno esenciales (se fuerza la inclusión de /app en las búsquedas de Python)
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH="/app:/app/.venv/lib/python3.12/site-packages"

# COMANDO DINÁMICO: Encuentra manage.py, configura el PYTHONPATH local y ejecuta collectstatic
RUN MANAGE_PATH=$(find . -name "manage.py" | head -n 1) && \
    if [ -z "$MANAGE_PATH" ]; then echo "ERROR: No se encontró manage.py"; exit 1; fi && \
    cd $(dirname "$MANAGE_PATH") && \
    export PYTHONPATH="/app:$(pwd):$PYTHONPATH" && \
    python manage.py collectstatic --no-input

EXPOSE 10000

# Iniciamos Gunicorn configurando de igual manera las rutas en tiempo de ejecución
CMD MANAGE_PATH=$(find . -name "manage.py" | head -n 1) && \
    cd $(dirname "$MANAGE_PATH") && \
    export PYTHONPATH="/app:$(pwd):$PYTHONPATH" && \
    exec gunicorn proyecto_1.wsgi:application --bind 0.0.0.0:10000
