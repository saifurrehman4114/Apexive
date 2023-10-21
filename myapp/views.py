from django.shortcuts import render, redirect
from .forms import PersonForm

from .models import *
def add_person(request):
    if request.method == 'POST':
        form = PersonForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('list_people')
    else:
        form = PersonForm()
    return render(request, 'add_person.html', {'form': form})

def list_people(request):
    people = Person.objects.all()
    return render(request, 'list_people.html', {'people': people})
