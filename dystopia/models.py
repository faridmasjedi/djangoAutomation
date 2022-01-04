from django.db import models

# Create your models here.


class Art(models.Model):
	name = models.CharField(max_length = 125)
	desc = models.CharField(max_length = 1255)
