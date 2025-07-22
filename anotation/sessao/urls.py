from django.urls import path
from .views import SessaoListCreateView, SessaoDetailView


urlpatterns = [
    path('sessao/', SessaoListCreateView.as_view(), name='sessao-list'),
    path('sessao/<int:pk>/', SessaoDetailView.as_view(), name='sessao-detail'),
]
