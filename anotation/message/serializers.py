from rest_framework import serializers
from .models import Message

class MessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = ['id_sessao', 'key_id', 'tex', 'media_url', 'media_type', 'media_size', 'media_name', 'media_duration']
        read_only_fields = ['id', 'timestap']
