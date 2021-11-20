from django.db import models
from uuid import uuid4


class Rescue(models.Model):
    """
    Rescue model definition for the database
    """
    uuid = models.UUIDField(default=uuid4, primary_key=True)
    timestamp = models.DateTimeField(auto_now=True)
    alert_date = models.DateField()
    alert_time = models.TimeField()
    total_victims = models.IntegerField(default=0)
    accident_date = models.DateField()
    accident_time = models.TimeField()
    resources = models.CharField(default="", blank=True, max_length=2048)
    place = models.CharField(default="", blank=True, max_length=2048)
    circumstances = models.CharField(default="", blank=True, max_length=2048)
