# --- ETAPA DE COMPILACIÓN ---
FROM python:3.12-slim-bookworm AS builder

# Instalar uv copiando los binarios directamente de la imagen oficial
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Variables de entorno para optimizar la compilación de uv
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# 1. Copiar archivos de dependencias para aprovechar la caché de Docker
COPY pyproject.toml uv.lock ./

# 2. Instalar dependencias externas (sin tu código todavía)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project

# 3. Copiar el resto del código y terminar la instalación del proyecto
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev


# --- ETAPA DE PRODUCCIÓN ---
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copiamos el entorno virtual compilado desde la etapa anterior
COPY --from=builder /app/.venv /app/.venv

# Copiamos el código fuente limpio necesario para producción
COPY . .

# Variables de entorno esenciales para Python y Render
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Ejecutar el collectstatic de Django usando las dependencias del entorno virtual
RUN python manage.py collectstatic --no-input

EXPOSE 10000

CMD ["gunicorn", "proyecto_1.wsgi:application", "--bind", "0.0.0.0:10000"]
