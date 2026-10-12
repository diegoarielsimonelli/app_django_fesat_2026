from django.shortcuts import render,redirect
from django.views import View
from django.urls import reverse_lazy
from django.contrib.auth.mixins import LoginRequiredMixin 
from django.views.generic.edit import CreateView,UpdateView, DeleteView
from .models import Curso,Profesor,Entregable,Estudiante,Avatar
from .forms import CursoModelForm,ProfesorModelForm,EntregableModelForm,EstudianteModelForm,AvatarModelForm
from .forms import UserRegisterForm  # El formulario que corregimos antes
import os



class AgregarAvatarView(LoginRequiredMixin, CreateView):
    model = Avatar
    form_class = AvatarModelForm
    template_name = 'agregar_avatar.html'
    success_url = reverse_lazy('home')

    def form_valid(self, form):
        # 1. Buscamos si el usuario ya tenía un avatar guardado
        avatar_viejo = Avatar.objects.filter(user=self.request.user).first()
        
        if avatar_viejo:
            # Si tiene una imagen física asociada, la borramos del disco duro
            if avatar_viejo.imagen and os.path.isfile(avatar_viejo.imagen.path):
                os.remove(avatar_viejo.imagen.path)
            # Borramos el registro viejo de la base de datos
            avatar_viejo.delete()

        # 2. Guardamos el nuevo avatar vinculándolo al usuario logueado
        avatar = form.save(commit=False)
        avatar.user = self.request.user
        avatar.save()
        
        return redirect(self.success_url)
  
class RegistroView(CreateView):
  form_class = UserRegisterForm
  template_name = 'registro.html'  # El HTML de tu formulario
  success_url = reverse_lazy(
      'login'
  )


class HomeView(LoginRequiredMixin,View):
    def get(self,request):
        productos = [
    {"id": 1, "nombre": "Laptop Asus", "precio": 850.00, "categoria": "Tecnología"},
    {"id": 2, "nombre": "Teclado Mecánico", "precio": 45.50, "categoria": "Accesorios"},
    {"id": 3, "nombre": "Monitor 24' Dell", "precio": 180.00, "categoria": "Tecnología"},
    {"id": 4, "nombre": "Ratón Inalámbrico", "precio": 25.00, "categoria": "Accesorios"},
    {"id": 5, "nombre": "Auriculares Sony", "precio": 90.00, "categoria": "Audio"}
]
        contexto=dict(titulo="Home",mensaje="Esta es la pagina de inicio en Django",productos=productos)

        return render(request,"index.html",contexto)





class CursoCreateView(LoginRequiredMixin,CreateView):
    model = Curso
    form_class = CursoModelForm
    template_name = 'cursos.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('cursos')
class CursoUpdateView(LoginRequiredMixin,UpdateView):
    model = Curso
    form_class = CursoModelForm
    template_name = 'cursos.html' # Reutilizamos el mismo HTML del formulario inteligente
    success_url = reverse_lazy('cursos')

# === DELETE (Borrar) ===
class CursoDeleteView(LoginRequiredMixin,DeleteView):
    model = Curso
    template_name = 'curso_confirm_delete.html' # Este archivo lo crearemos ahora
    success_url = reverse_lazy('cursos')

class CursosView(LoginRequiredMixin,View):
    def get(self, request):
        contexto = dict(
            titulo="Cursos",
            mensaje="Esta es la pagina de inicio de los Cursos",
            cursos=Curso.objects.all()
        )
        return render(request, "lista_cursos.html", contexto) # ← AHORA 'lista_cursos.html' es para el Listado


class EstudiantesView(LoginRequiredMixin,View):
    def get(self,request):
        contexto=dict(titulo="Estudiantes",mensaje="Esta es la pagina de inicio de los Estudiantes",estudiantes=Estudiante.objects.all())

        return render(request,"lista_estudiantes.html",contexto)


class EstudiantesCreateView(LoginRequiredMixin,CreateView):
    model = Estudiante
    form_class = EstudianteModelForm
    template_name = 'estudiantes.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('estudiantes')
class EstudiantesUpdateView(LoginRequiredMixin,UpdateView):
    model = Estudiante
    form_class = EstudianteModelForm
    template_name = 'estudiantes.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('estudiantes')

# === DELETE (Borrar) ===
class EstudiantesDeleteView(LoginRequiredMixin,DeleteView):
    model = Estudiante
        
    template_name = 'estudiantes_confirm_delete.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('estudiantes')


class ProfesoresView(LoginRequiredMixin,View):
    def get(self,request):
        contexto=dict(titulo="Profesores",mensaje="Esta es la pagina de inicio de Profesores",profesores=Profesor.objects.all())

        return render(request,"lista_profesores.html",contexto)


class ProfesoresCreateView(LoginRequiredMixin,CreateView):
    model = Profesor
    form_class = ProfesorModelForm
    template_name = 'profesores.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('profesores')
class ProfesoresUpdateView(LoginRequiredMixin,UpdateView):
    model = Profesor
    form_class = ProfesorModelForm
    template_name = 'profesores.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('profesores')

# === DELETE (Borrar) ===
class ProfesoresDeleteView(LoginRequiredMixin,DeleteView):
    model = Profesor
    template_name = 'profesores_confirm_delete.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('profesores')

class EntregablesView(LoginRequiredMixin,View):
    def get(self,request):
        contexto=dict(titulo="Entregables",mensaje="Esta es la pagina de inicio de los Entregables",entregables=Entregable.objects.all())

        return render(request,"lista_entregables.html",contexto)


class EntregablesCreateView(LoginRequiredMixin,CreateView):
    model = Entregable
    form_class = EntregableModelForm
    template_name = 'entregables.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('entregables')
class EntregablesUpdateView(LoginRequiredMixin,UpdateView):
    model = Entregable
    form_class = EntregableModelForm
    template_name = 'entregables.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('entregables')

# === DELETE (Borrar) ===
class EntregablesDeleteView(LoginRequiredMixin,DeleteView):
    model = Entregable
    
    template_name = 'entregables_confirm_delete.html'        # ← AHORA 'cursos.html' es para el Formulario
    success_url = reverse_lazy('entregables')