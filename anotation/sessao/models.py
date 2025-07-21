from django.db import models

# Create your models here.
class User(models.Model):
    class Meta:
        managed = False
        db_table = 'crud_user'

class Sessao(models.Model):
    id_sessao = models.AutoField(primary_key=True)
    name = models.CharField(max_length=30)
    id_user = models.ForeignKey('User', models.DO_NOTHING, db_column='id_user', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'sessao'

    def __str__(self):
        return self.name
