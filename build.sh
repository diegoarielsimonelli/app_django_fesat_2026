#!/usr/bin/env bash
# Salir inmediatamente si ocurre un error
set -o errexit
#!/usr/bin/env bash
# Salir inmediatamente si ocurre un error
set -o errexit

# Ejecutar las migraciones en la base de datos de Render usando el entorno del contenedor
python manage.py migrate
