from rest_framework import serializers
from django.contrib.auth import get_user_model

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    # define como write_only pra nunca expor no GET
    password = serializers.CharField(write_only=True, min_length=6)

    class Meta:
        model = User
        # liste só os campos que faz sentido o cliente setar
        fields = (
            "id",
            "username",  # ou "email", se for seu username_field
            "password",
            "first_name",
            "last_name",
            # não inclua is_superuser nem is_staff aqui!
        )
        read_only_fields = ("id",)

    def create(self, validated_data):
        # use o método create_user do seu manager, que já faz set_password e save()
        return User.objects.create_user(**validated_data)
