from django.db import models

# Create your models here.
class Curso(models.Model):
    nombre=models.CharField(max_length=40)
    camada=models.IntegerField()

    def __str__(self):
        return f"Nombre: {self.nombre} Camada: {self.camada}"
class Estudiante(models.Model):
    nombre=models.CharField(max_length=40)
    apellido=models.CharField(max_length=40)
    email=models.EmailField()

class Profesor(models.Model):
    nombre=models.CharField(max_length=40)
    apellido=models.CharField(max_length=40)
    email=models.EmailField()
    profesion=models.CharField(max_length=40)
    
    class Meta:
        verbose_name_plural = "Profesores"

    def __str__(self) -> str:
        return f"{self.nombre} {self.apellido} - {self.profesion}"

class Entregable(models.Model):
    nombre=models.CharField(max_length=40)
    fecha_de_entrega=models.DateField()
    entregado=models.BooleanField()

    def __str__(self) -> str:
        return f"{self.nombre} {self.fecha_de_entrega} {self.entregado}"
from django.contrib.auth.models import User
from django.db import models


class Avatar(models.Model):
  # Relación uno a uno: Un usuario tiene un avatar, un avatar pertenece a un usuario
  user = models.OneToOneField(
      User, on_delete=models.CASCADE, related_name='avatar'
  )
  # Las imágenes se guardarán en una subcarpeta interna llamada 'avatares/'
  imagen = models.ImageField(upload_to='avatares', null=True, blank=True)

  def __str__(self):
    return f'Avatar de {self.user.username}'
