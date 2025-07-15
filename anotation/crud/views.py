# views.py
from rest_framework import status, generics
from rest_framework.permissions import AllowAny
from .serializers import UserSerializer

class UserCreateView(generics.CreateAPIView):
    """
    Endpoint para cadastro de usuários “normais”.
    Usa o UserSerializer.create() para fazer o hashing da senha.
    """
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
