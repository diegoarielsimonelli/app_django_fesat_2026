FROM python:3.12-slim-bookworm

WORKDIR /app

# Instalar curl para el script de construcción
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/*

COPY . .

# Ejecutar el script de construcción dentro del contenedor
RUN chmod +x build.sh && ./build.sh

EXPOSE 10000

# Arrancar el servidor buscando dinámicamente tu módulo de Django
CMD MANAGE_PATH=$(find . -name "manage.py" | head -n 1) && \
    cd $(dirname "$MANAGE_PATH") && \
    source ../../.venv/bin/activate && \
    exec gunicorn proyecto_1.wsgi:application --bind 0.0.0.0:10000
