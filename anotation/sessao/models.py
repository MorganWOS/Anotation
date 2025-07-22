from django.db import models
from django.conf import settings

# Create your models here.

class Sessao(models.Model):
    # Chave primária da sessão, auto-incremento
    id_sessao = models.AutoField(primary_key=True)
    
    # Nome da sessão fornecido pelo usuário
    name = models.CharField(max_length=30)
    
    # Chave estrangeira para o usuário proprietário da sessão
    # models.DO_NOTHING: não excluir sessões se o usuário for removido
    # blank=True, null=True: permite valores vazios (temporário para compatibilidade)
    id_user = models.ForeignKey(settings.AUTH_USER_MODEL, models.DO_NOTHING, db_column='id_user', blank=True, null=True)

    class Meta:
        # managed=False: Django não gerencia esta tabela (pode existir previamente)
        managed = False
        db_table = 'sessao'  # Nome da tabela real no banco de dados

    def __str__(self):
        # Representação em string da sessão para o admin e debug
        return self.name
