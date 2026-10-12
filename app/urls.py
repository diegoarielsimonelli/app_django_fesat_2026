from django.urls import path
from django.contrib.auth.views import LoginView,LogoutView
from .views import( 
    HomeView,
    CursosView,
    EntregablesView,
    EstudiantesView,
    ProfesoresView,
    CursoCreateView,
    CursoDeleteView,
    CursoUpdateView,
    ProfesoresCreateView,
    ProfesoresDeleteView,
    ProfesoresUpdateView,
    EntregablesCreateView,
    EntregablesDeleteView,
    EntregablesUpdateView,
    EstudiantesCreateView,
    EstudiantesDeleteView,
    EstudiantesUpdateView,
    RegistroView,
    AgregarAvatarView)


urlpatterns = [
    path('', HomeView.as_view(),name="home"),
    path('cursos/', CursosView.as_view(),name='cursos'),
    path('profesores/', ProfesoresView.as_view(),name="profesores"),
    path('entregables/', EntregablesView.as_view(),name="entregables"),
    path('estudiantes/', EstudiantesView.as_view(),name="estudiantes"),
     path('registro/', RegistroView.as_view(), name='registro'),
   path('logout/', LogoutView.as_view(), name='logout'), 
    path(
        'login/',
        LoginView.as_view(template_name='login.html'),
        name='login',
    ),
    path('agregar-avatar/', AgregarAvatarView.as_view(), name='agregar_avatar'),
    # Ruta del formulario inteligente
    path('cursos/editar/<int:pk>/', CursoUpdateView.as_view(), name='editar_curso'),
    path('cursos/borrar/<int:pk>/', CursoDeleteView.as_view(), name='borrar_curso'),
    path('cursos/crear/', CursoCreateView.as_view(), name='crear_curso'),
    path('profesores/editar/<int:pk>/', ProfesoresUpdateView.as_view(), name='editar_profesor'),
    path('profesores/borrar/<int:pk>/', ProfesoresDeleteView.as_view(), name='borrar_profesor'),
    path('profesores/crear/', ProfesoresCreateView.as_view(), name='crear_profesor'),
    path('entregables/editar/<int:pk>/', EntregablesUpdateView.as_view(), name='editar_entregable'),
    path('entregables/borrar/<int:pk>/', EntregablesDeleteView.as_view(), name='borrar_entregable'),
    path('entregables/crear/', EntregablesCreateView.as_view(), name='crear_entregable'),
    path('estudiantes/editar/<int:pk>/', EstudiantesUpdateView.as_view(), name='editar_estudiante'),
    path('estudiantes/borrar/<int:pk>/', EstudiantesDeleteView.as_view(), name='borrar_estudiante'),
    path('estudiantes/crear/', EstudiantesCreateView.as_view(), name='crear_estudiante'),
]
