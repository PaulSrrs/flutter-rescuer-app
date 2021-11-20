from copy import copy
from django.http import JsonResponse
from datetime import datetime
from rest_framework import status
from rest_framework.views import APIView, Response
from .serializers import ListRescueSerializer, CreateReadFullRescueSerializer
from .models import Rescue
from rest_framework.pagination import LimitOffsetPagination


class ListRescuesView(APIView, LimitOffsetPagination):
    """
    This view class, lists all the rescues registered in the database and permits to create a new rescue

    Route /rescues/
    """
    def get(self, request):
        """
        This get method lists all the rescues registered and return it with pagination

        :param request: Django HTTP request
        :return:
        """
        results = self.paginate_queryset(Rescue.objects.all().order_by("-alert_date", "-alert_time"), request, view=self)
        serializer = ListRescueSerializer(results, many=True)
        return self.get_paginated_response(serializer.data)  # , status=status.HTTP_200_OK)

    def post(self, request):
        """
        This post method creates a new rescue in the database and set defaults for date and time fields

        :param request: Django HTTP request
        :return:
        """
        data = copy(request.data)
        print(data, data.keys())
        data["alert_date"] = request.data["alert_date"] if "alert_date" in data.keys() else datetime.now().strftime("%Y-%m-%d")
        data["alert_time"] = request.data["alert_time"] if "alert_time" in data.keys() else datetime.now().strftime("%H:%M")
        data["accident_date"] = request.data["accident_date"] if "accident_date" in data.keys() else datetime.now().strftime("%Y-%m-%d")
        data["accident_time"] = request.data["accident_time"] if "accident_time" in data.keys() else datetime.now().strftime("%H:%M")
        print(data)
        serializer = CreateReadFullRescueSerializer(data=data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class RescueView(APIView):
    """
    This view class, manage the data relative to a specific rescue event

    Route /rescue/{rescue uuid}/
    """
    def get(self, request, uuid):
        """
        This get method gives the detail of a rescue event

        :param request: Django HTTP Request
        :param uuid: Rescue uuid to get
        :return:
        """
        try:
            serializer = CreateReadFullRescueSerializer(Rescue.objects.get(uuid=uuid), many=False)
        except Rescue.DoesNotExist:
            return Response("Rescue not found", status=status.HTTP_404_NOT_FOUND)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def put(self, request, uuid):
        """
        This put method updates rescue data from the HTTP request data

        :param request: Django HTTP Request
        :param uuid: Rescue uuid to update
        :return:
        """
        try:
            rescue = Rescue.objects.get(uuid=uuid)
        except Rescue.DoesNotExist:
            return Response("Rescue not found", status=status.HTTP_404_NOT_FOUND)
        serializer = CreateReadFullRescueSerializer(rescue, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, uuid):
        """
        This delete method delete a rescue

        :param request: Django HTTP Request
        :param uuid: Rescue uuid to delete
        :return:
        """
        try:
            rescue = Rescue.objects.get(uuid=uuid)
            serializer = CreateReadFullRescueSerializer(rescue, many=False)
        except Rescue.DoesNotExist:
            return Response("Rescue not found", status=status.HTTP_404_NOT_FOUND)
        data = serializer.data
        rescue.delete()
        return Response(data, status=status.HTTP_200_OK)


def custom404(request, exception=None):
    """
    Custom 404 error (override HTML Django format to JSON response)
    """
    return JsonResponse({
        "status_code": 404,
        "error": "Not found"
    })


def custom500(request, exception=None):
    """
    Custom 500 error (override HTML Django format to JSON response)
    """
    return JsonResponse({
        "status_code": 500,
        "error": "Server error"
    })
