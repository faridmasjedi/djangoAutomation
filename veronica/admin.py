from django.contrib import admin

# Register your models here.


from .models import Art

class ArtAdmin(admin.ModelAdmin):
	list_display = (
'price','name','writer')


admin.site.register(Art,ArtAdmin)
