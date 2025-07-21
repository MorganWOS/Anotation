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

class Message(models.Model):
    id = models.AutoField(primary_key=True)
    id_sessao = models.ForeignKey('Sessao', models.DO_NOTHING, db_column='id_sessao', blank=True, null=True)
    key_id = models.IntegerField()
    tex = models.TextField(blank=True, null=True)
    timestap = models.DateTimeField(auto_now_add=True)
    media_url = models.TextField(blank=True, null=True)
    media_type = models.TextField(blank=True, null=True)
    media_size = models.IntegerField(blank=True, null=True)
    media_name = models.TextField(blank=True, null=True)
    media_duration = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'messages'
