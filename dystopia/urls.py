from django.urls import path
from . import views
urlpatterns=[
	path('hellodystopia', views.hellodystopia)
]

urlpatterns.append(path('', views.index))
