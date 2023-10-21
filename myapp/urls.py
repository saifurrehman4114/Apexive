from django.urls import path
from . import views

urlpatterns = [
    path('add-person/', views.add_person, name='add_person'),
    path('list-people/', views.list_people, name='list_people'),
]
