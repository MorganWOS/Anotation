from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.db import connection, IntegrityError, DatabaseError
from django.views.decorators.csrf import csrf_exempt
from rest_framework.views import APIView
from django.http import JsonResponse
import json
import requests


from .serializers import UserSerializer

# Utility function for handling database errors
def handle_db_error(error):
    """Handle database errors and return appropriate responses"""
    if isinstance(error, IntegrityError):
        return Response(
            {"error": "Database integrity error, check your data and try again."},
            status=status.HTTP_400_BAD_REQUEST
        )
    else:
        return Response(
            {"error": f"Database error: {str(error)}"},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )




# Usuario Views
class UserView(APIView):
    def post(self, request):
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            try:
                password = serializer.validated_data['password']
                last_login = serializer.validated_data['last_login']
                is_superuser = serializer.validated_data['is_superuser']
                username = serializer.validated_data['username']
                first_name = serializer.validated_data['first_name']
                last_name = serializer.validated_data['last_name']
                email = serializer.validated_data['email']
                is_staff = serializer.validated_data['is_staff']
                is_active = serializer.validated_data['is_active']
                date_joined = serializer.validated_data['date_joined']
                dtnascimento = serializer.validated_data['dtnascimento']

                with connection.cursor() as cursor:
                    cursor.execute(
                        'CALL setuser(null, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)',
                        [last_name, password, last_login, is_superuser, username, first_name, email, is_staff, is_active, date_joined, dtnascimento]
                    )

                return Response(serializer.data, status=status.HTTP_201_CREATED)
            except Exception as e:
                return handle_db_error(e)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
