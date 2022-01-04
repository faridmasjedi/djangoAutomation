from django.db import models

# Create your models here.


class Art(models.Model):
	name = models.CharField(max_length = 555)
	price = models.FloatField()
	writer = models.CharField(max_length = 125)
