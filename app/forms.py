from django import forms
from .models import Curso,Profesor,Entregable,Estudiante,Avatar
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm



class UserRegisterForm(UserCreationForm):
    email = forms.EmailField(label="Correo Electrónico")
    password1 = forms.CharField(label="Contraseña", widget=forms.PasswordInput)
    password2 = forms.CharField(label="Repetir contraseña", widget=forms.PasswordInput)

    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2']


class CursoModelForm(forms.ModelForm):
    class Meta:
        model = Curso # Vinculación explícita con el modelo físico
        fields = ['nombre', 'camada'] # Columnas expuestas en la interfaz
        # Sobreescritura visual y adición de clases de diseño (Bootstrap)
        labels = {
        'nombre': 'Nombre del Curso',
        'camada': 'Número de Camada'
        }
        widgets = {
    'nombre': forms.TextInput(attrs={'placeholder': 'Ej: Python'}),
    'camada': forms.NumberInput(attrs={'placeholder': 'Ej: 121212'}),
    }

class AvatarModelForm(forms.ModelForm):

  class Meta:
    model = Avatar
    fields = ['imagen']
    labels = {'imagen': 'Selecciona tu foto de perfil'}


class ProfesorModelForm(forms.ModelForm):

  class Meta:
    model = Profesor  # 1. Vinculación explícita con tu modelo físico Profesor
    fields = [
        'nombre',
        'apellido',
        'email',
        'profesion',
    ]  # 2. Expone todas las columnas requeridas

    # 3. Sobreescritura visual de las etiquetas en la interfaz (opcional)
    labels = {
        'nombre': 'Nombre del Profesor',
        'apellido': 'Apellido',
        'email': 'Correo Electrónico',
        'profesion': 'Profesión / Especialidad',
    }

    # 4. Asignación de widgets específicos para el renderizado HTML
    widgets = {
        'nombre': forms.TextInput(attrs={'placeholder': 'Ej: Carlos'}),
        'apellido': forms.TextInput(attrs={'placeholder': 'Ej: Gómez'}),
        'email': forms.EmailInput(
            attrs={'placeholder': 'ejemplo@correo.com'}
        ),  # EmailInput fuerza el tipo html compatible
        'profesion': forms.TextInput(
            attrs={'placeholder': 'Ej: Ingeniero en Sistemas'}
        ),
    }
class EntregableModelForm(forms.ModelForm):

  class Meta:
    model = Entregable  # 1. Vinculación con el modelo de tu imagen
    fields = [
        'nombre',
        'fecha_de_entrega',
        'entregado',
    ]  # 2. Las tres columnas expuestas

    # 3. Etiquetas legibles para la interfaz de usuario
    labels = {
        'nombre': 'Nombre del Entregable',
        'fecha_de_entrega': 'Fecha de Entrega',
        'entregado': '¿Ya fue entregado?',
    }

    # 4. Widgets específicos para optimizar la carga de datos en HTML
    widgets = {
        'nombre': forms.TextInput(
            attrs={'placeholder': 'Ej: Tarea 1 - Django, Trabajo Práctico'}
        ),
        'fecha_de_entrega': forms.DateInput(
            attrs={
                'type': 'date'
            }  # ← ESTO FORZARÁ EL CALENDARIO NATIVO DEL NAVEGADOR HTML5
        ),
        'entregado': forms.CheckboxInput(
            attrs={'class': 'form-check-input'}  # Renderiza un cuadro de tilde
        ),
    }

class EstudianteModelForm(forms.ModelForm):

  class Meta:
    model = Estudiante  # 1. Vinculación explícita con el modelo de tu imagen
    fields = [
        'nombre',
        'apellido',
        'email',
    ]  # 2. Las tres columnas expuestas en la interfaz

    # 3. Etiquetas legibles y limpias para el usuario final
    labels = {
        'nombre': 'Nombre del Estudiante',
        'apellido': 'Apellido',
        'email': 'Correo Electrónico',
    }

    # 4. Configuración de los componentes HTML (Widgets) con marcas de ayuda
    widgets = {
        'nombre': forms.TextInput(attrs={'placeholder': 'Ej: Juan'}),
        'apellido': forms.TextInput(attrs={'placeholder': 'Ej: Pérez'}),
        'email': forms.EmailInput(
            attrs={'placeholder': 'juan.perez@ejemplo.com'}
        ),  # EmailInput fuerza el formato correcto en el navegador
    }