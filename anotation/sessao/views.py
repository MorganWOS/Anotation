from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework_simplejwt.authentication import JWTAuthentication
from django.contrib.auth import get_user_model
from .models import Sessao
from .serializers import SessaoSerializer

# Create your views here.
class SessaoListCreateView(APIView):
    # Configuração de autenticação JWT para proteger os endpoints
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # Filtra as sessões apenas do usuário logado
        # request.user contém o usuário autenticado via JWT
        sessao = Sessao.objects.filter(id_user=request.user.id)
        serializer = SessaoSerializer(sessao, many=True)
        return Response(serializer.data)

    def post(self, request):
        # Cria uma nova sessão associada ao usuário logado
        serializer = SessaoSerializer(data=request.data)
        if serializer.is_valid():
            # Automaticamente associa a sessão ao usuário logado
            # Isso garante que toda nova sessão tenha o id_user correto
            serializer.save(id_user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class SessaoDetailView(APIView):
    # Configuração de autenticação JWT para proteger os endpoints
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def get_object(self, pk, user):
        try:
            # Filtra por ID da sessão E pelo usuário logado
            # Isso garante que usuários só acessem suas próprias sessões
            return Sessao.objects.get(pk=pk, id_user=user.id)
        except Sessao.DoesNotExist:
            return None

    def get(self, request, pk):
        # Busca a sessão específica do usuário logado
        sessao = self.get_object(pk, request.user)
        if sessao is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = SessaoSerializer(sessao)
        return Response(serializer.data)

    def put(self, request, pk):
        # Atualiza uma sessão específica do usuário logado
        sessao = self.get_object(pk, request.user)
        if sessao is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = SessaoSerializer(sessao, data=request.data)
        if serializer.is_valid():
            # Mantém a associação com o usuário original
            serializer.save(id_user=request.user)
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        # Remove uma sessão específica do usuário logado
        sessao = self.get_object(pk, request.user)
        if sessao is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        sessao.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
