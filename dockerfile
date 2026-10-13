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

# 2. Instalar dependencias externas (con la bandera para no exigir el paquete raíz todavía)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project

# 3. Copiar todo el código para terminar la instalación
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project


# --- ETAPA 2: PRODUCCIÓN ---
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copiamos el entorno virtual que se armó en la Etapa 1 (builder)
COPY --from=builder /app/.venv /app/.venv

# Copiamos todo el código fuente de tu proyecto
COPY . .

# Variables de entorno esenciales para que Python encuentre Django y el entorno virtual
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH="/app/src/proyecto_django_enclase"

# Nos movemos a la subcarpeta interna donde está tu archivo manage.py
WORKDIR /app/src/proyecto_django_enclase

# Ejecutamos collectstatic de Django
RUN python manage.py collectstatic --no-input

EXPOSE 10000

# Iniciamos el servidor con Gunicorn apuntando a tu módulo de producción
CMD ["gunicorn", "proyecto_1.wsgi:application", "--bind", "0.0.0.0:10000"]
