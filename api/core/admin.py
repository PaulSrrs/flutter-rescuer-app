from django.contrib import admin
from .models import Rescue


@admin.register(Rescue)
class AdminRescue(admin.ModelAdmin):
    list_display = ["uuid", "total_victims"]
    fields = ["uuid", "alert_date", "alert_time", "total_victims", "accident_date", "accident_time", "resources", "place", "circumstances"]
    readonly_fields = ["uuid", "alert_date", "alert_time", "accident_date", "accident_time"]
