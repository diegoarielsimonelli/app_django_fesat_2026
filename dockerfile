# --- ETAPA 2: PRODUCCIÓN ---
FROM python:3.12-slim-bookworm

# Nos paramos directamente en la raíz de la aplicación
WORKDIR /app

# Copiamos el entorno virtual compilado desde el builder
COPY --from=builder /app/.venv /app/.venv

# Copiamos TODOS los archivos directamente a /app
COPY . .

# Variables de entorno esenciales (simplificamos el PYTHONPATH)
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH="/app"

# Ejecutamos collectstatic indicándole explícitamente dónde está el archivo manage.py
RUN python src/proyecto_django_enclase/manage.py collectstatic --no-input

EXPOSE 10000

# Iniciamos Gunicorn apuntando al módulo wsgi correcto usando la ruta completa
CMD ["gunicorn", "--chdir", "src/proyecto_django_enclase", "proyecto_1.wsgi:application", "--bind", "0.0.0.0:10000"]
