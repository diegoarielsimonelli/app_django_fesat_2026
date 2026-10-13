# --- ETAPA DE PRODUCCIÓN ---
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copiamos el entorno virtual compilado desde la etapa anterior
COPY --from=builder /app/.venv /app/.venv

# Copiamos todo el código fuente
COPY . .

# Variables de entorno esenciales (Ajustamos el PATH para que use el entorno virtual)
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH="/app/src/proyecto_django_enclase"

# Cambiamos temporalmente el directorio de trabajo a donde está realmente manage.py
WORKDIR /app/src/proyecto_django_enclase

# Ahora sí ejecutamos collectstatic de forma segura
RUN python manage.py collectstatic --no-input

EXPOSE 10000

# Iniciamos Gunicorn apuntando al módulo wsgi correcto desde esa misma carpeta
CMD ["gunicorn", "proyecto_1.wsgi:application", "--bind", "0.0.0.0:10000"]
