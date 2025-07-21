from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Message
from .serializers import MessageSerializer

class MessageListCreateView(APIView):
    def get(self, request):
        message = Message.objects.all()
        serializer = MessageSerializer(message, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = MessageSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class MessageDetailView(APIView):
    def get_object(self, pk):
        try:
            return Message.objects.get(pk=pk)
        except Message.DoesNotExist:
            return None

    def get(self, request, pk):
        message = self.get_object(pk)
        if message is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = MessageSerializer(message)
        return Response(serializer.data)

    def put(self, request, pk):
        message = self.get_object(pk)
        if message is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        serializer = MessageSerializer(message, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        message = self.get_object(pk)
        if message is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        message.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

class MessageSessionView(APIView):
    def get(self, request, id_sessao):
        # Filtra as mensagens pelo id_sessao (usando filter em vez de get)
        messages = Message.objects.filter(id_sessao=id_sessao)

        # Verifica se existem mensagens para esse id_sessao
        if not messages.exists():
            return Response(
                {"detail": "Nenhuma mensagem encontrada para esta sessão."},
                status=status.HTTP_404_NOT_FOUND
            )

        # Serializa múltiplos objetos (many=True)
        serializer = MessageSerializer(messages, many=True)
        return Response(serializer.data)
