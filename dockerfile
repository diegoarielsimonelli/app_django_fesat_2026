# --- ETAPA 1: COMPILACIÓN (BUILDER) ---
FROM python:3.12-slim-bookworm AS builder

# Instalar uv copiando los binarios de la imagen oficial (GHCR)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# 1. Copiar archivos de dependencias para aprovechar la caché de Docker
COPY pyproject.toml uv.lock ./

# 2. Instalar dependencias externas iniciales
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev --no-install-project

# 3. Copiar todo el código y HACER LA SINCRONIZACIÓN FINAL (Sin la bandera)
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev


# --- ETAPA 2: PRODUCCIÓN ---
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copiamos el entorno virtual compilado correctamente en la etapa anterior
COPY --from=builder /app/.venv /app/.venv

# Copiamos todo el código fuente del proyecto
COPY . .

# Forzamos a que el sistema use el entorno virtual donde está instalado Django
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH="/app/src/proyecto_django_enclase"

# Nos paramos de forma exacta en la carpeta donde está tu archivo manage.py
WORKDIR /app/src/proyecto_django_enclase

# Ahora sí ejecutará collectstatic porque Django estará disponible en el entorno virtual
RUN python manage.py collectstatic --no-input

EXPOSE 10000

# Iniciamos el servidor con Gunicorn
CMD ["gunicorn", "proyecto_1.wsgi:application", "--bind", "0.0.0.0:10000"]
