# --- ETAPA DE COMPILACIÓN ---
FROM python:3.12-slim-bookworm AS builder

WORKDIR /app

# Instalar curl para poder bajar uv
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

# Descargar e instalar uv usando el script oficial de Astral (URL corregida)
RUN curl -LsSf https://astral.sh | sh

# Asegurar que el binario de uv esté disponible en el PATH para el builder
ENV PATH="/root/.local/bin:$PATH"
ENV UV_COMPILE_BYTECODE=1

# 1. Copiar primero las dependencias para aprovechar la cache de Docker
COPY pyproject.toml uv.lock ./

# 2. Instalar dependencias externas (sin tu código todavía)
RUN uv sync --frozen --no-dev --no-install-project

# 3. Copiar el resto del código para que uv pueda instalar tu proyecto correctamente
COPY . .
RUN uv sync --frozen --no-dev


# --- ETAPA DE PRODUCCIÓN ---
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copiamos el entorno virtual con todo instalado (incluyendo tu proyecto)
COPY --from=builder /app/.venv /app/.venv

# Copiamos el código fuente limpio para producción
COPY . .

# Variables de entorno esenciales para Python y Render
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1

# Ejecutar collectstatic
RUN python manage.py collectstatic --no-input

EXPOSE 10000

CMD ["gunicorn", "proyecto_1.wsgi:application", "--bind", "0.0.0.0:10000"]
