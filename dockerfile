# --- ETAPA DE COMPILACIÓN ---
FROM python:3.12-slim-bookworm AS builder

WORKDIR /app

# Instalar curl para poder bajar uv
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

# Descargar e instalar uv usando el script oficial de Astral
RUN curl -LsSf https://astral.sh | sh

# Asegurar que el binario de uv esté disponible en el PATH para el builder
ENV PATH="/root/.local/bin:$PATH"
ENV UV_COMPILE_BYTECODE=1

# 1. Copiar primero las dependencias para aprovechar la cache de Docker
COPY pyproject.toml uv.lock ./

# 2. Instalar dependencias externas (sin tu código todavía)
RUN uv sync --frozen --no-dev --no-install-project

# 3. Copiar el resto del código
COPY . .
RUN uv sync --frozen --no-dev


# --- ETAPA DE PRODUCCIÓN ---
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copiamos el entorno virtual generado
COPY --from=builder /app/.venv /app/.venv
COPY . .

# Variables de entorno esenciales
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1

# === CORRECCIÓN AQUÍ ===
# Nos movemos a la subcarpeta exacta donde está tu archivo manage.py
WORKDIR /app/src/proyecto_django_enclase

# Ahora sí encontrará manage.py para compilar los estáticos
RUN python manage.py collectstatic --no-input

EXPOSE 10000

# Aseguramos que Gunicorn arranque desde la carpeta correcta buscando tu módulo proyecto_1
CMD ["gunicorn", "proyecto_1.wsgi:application", "--bind", "0.0.0.0:10000"]
