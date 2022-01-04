from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse

def hellodystopia(req):
	return HttpResponse('Hello World!!!')

from .models import Art


def index(req):
	all = Art.objects.all()
	return render(req, 'index.html',{'all' : all})
