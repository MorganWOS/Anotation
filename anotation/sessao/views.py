from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Sessao
from .serializers import SessaoSerializer

# Create your views here.
class SessaoListCreateView(APIView):
    def get(self, request):
        sessao = Sessao.objects.all()
        serializer = SessaoSerializer(sessao, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = SessaoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class SessaoDetailView(APIView):
    def get_object(self, pk):
        try:
            return Sessao.objects.get(pk=pk)
        except Sessao.DoesNotExist:
            return None

    def get(self, request, pk):
        sessao = self.get_object(pk)
        if sessao is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = MessageSerializer(message)
        return Response(serializer.data)

    def put(self, request, pk):
        sessao = self.get_object(pk)
        if sessao is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = SessaoSerializer(sessao, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        sessao = self.get_object(pk)
        if sessao is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        sessao.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
