from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse

def helloveronica(req):
	return HttpResponse('Hello World!!!')

from .models import Art
