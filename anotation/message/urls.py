from django.urls import path
from .views import MessageListCreateView, MessageDetailView, MessageSessionView

urlpatterns = [
    path('messages/', MessageListCreateView.as_view(), name='message-list'),
    path('messages/<int:pk>/', MessageDetailView.as_view(), name='message-detail'),

    path('messages/session/<int:id_sessao>/', MessageSessionView.as_view(), name='message_session-list')
]
