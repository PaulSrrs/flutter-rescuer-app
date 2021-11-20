from rest_framework import serializers
from .models import Rescue


class ListRescueSerializer(serializers.ModelSerializer):
    """
    This serializer converts the data from the database to json format for the request GET on the route /rescues/
    """
    alert_date = serializers.DateField(format="%Y-%m-%d", required=False)
    alert_time = serializers.TimeField(format="%H:%M", required=False)

    class Meta:
        model = Rescue
        fields = ["uuid", "timestamp", "alert_date", "alert_time", "total_victims"]
        read_only_fields = ["uuid"]


class CreateReadFullRescueSerializer(serializers.ModelSerializer):
    """
    This serializer converts the data from the request to the data base for the requests POST on the route /rescues/, PUT on the route /rescue/{rescue uuid}/
    This serializer converts the data from the database to json format for the request GET on the route /rescue/{rescue uuid}/
    """
    alert_date = serializers.DateField(format="%Y-%m-%d", input_formats=["%Y-%m-%d"], required=False)
    alert_time = serializers.TimeField(format="%H:%M", input_formats=["%H:%M"], required=False)
    accident_date = serializers.DateField(format="%Y-%m-%d", input_formats=["%Y-%m-%d"], required=False)
    accident_time = serializers.TimeField(format="%H:%M", input_formats=["%H:%M"], required=False)

    class Meta:
        model = Rescue
        fields = ["uuid", "alert_date", "alert_time", "total_victims", "accident_date", "accident_time", "resources", "place", "circumstances"]
        read_only_fields = ["uuid"]
