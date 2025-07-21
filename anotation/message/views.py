"""Arrumar todos esses imports e verificar quais são irrelevantes"""
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.db import connection, IntegrityError, DatabaseError
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from django.http import JsonResponse
import json
import requests
from .models import Message
from .serializers import MessageSerializer

# Create your views here.
class MessageView(APIView):
    pass
