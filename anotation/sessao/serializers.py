from rest_framework import serializers
from .models import Sessao

class SessaoSerializer(serializers.ModelSerializer):
    # Campo read-only para evitar que o frontend altere o usuário da sessão
    # O id_user é sempre definido automaticamente pela view baseado no token JWT
    id_user = serializers.PrimaryKeyRelatedField(read_only=True)
    
    class Meta:
        model = Sessao
        fields = '__all__'
        # Campos obrigatórios que devem ser fornecidos pelo frontend
        # id_user é excluído pois é definido automaticamente
        extra_kwargs = {
            'name': {'required': True},  # Nome da sessão é obrigatório
        }
