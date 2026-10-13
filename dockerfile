# Usamos la imagen oficial de uv provista por Astral para compilar de forma eficiente
FROM astralsh/uv:python3.12-bookworm-slim AS builder

# Configurar el directorio de trabajo dentro del contenedor
WORKDIR /app

# Habilitar la optimización de bytecode (compila los archivos .py a .pyc para mayor velocidad)
ENV UV_COMPILE_BYTECODE=1

# Copiar únicamente los archivos de dependencias para aprovechar la caché de Docker
COPY pyproject.toml uv.lock ./

# Instalar las dependencias usando el modo congelado y omitiendo las de desarrollo (--no-dev)
# Agregamos --no-install-project para saltarnos el error del __init__.py que venías teniendo
RUN uv sync --frozen --no-dev --no-install-project


# --- ETAPA DE PRODUCCIÓN ---
# Usamos una imagen limpia de Python para mantener el contenedor final liviano
FROM python:3.12-slim-bookworm

WORKDIR /app

# Copiamos el entorno virtual (.venv) generado en la etapa anterior con todas las librerías
COPY --from=builder /app/.venv /app/.venv

# Copiamos todo el resto del código del repositorio a la imagen
COPY . .

# Aseguramos que el sistema use el entorno virtual de uv por defecto
ENV PATH="/app/.venv/bin:$PATH"

# Ejecutamos collectstatic durante la construcción de la imagen
RUN python manage.py collectstatic --no-input

# Exponemos el puerto por defecto en el que Render escucha las aplicaciones
EXPOSE 10000

# Comando de arranque usando Gunicorn
CMD ["gunicorn", "proyecto_1.wsgi:application", "--bind", "0.0.0.0:10000"]
