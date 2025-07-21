from django.urls import path
from .views import MessageView

app_name = 'message'

urlpatterns = [

    # Usuario endpoints
    path('message/', MessageView.as_view(), name='message-list'),
    path('message/<int:pk>/', MessageView.as_view(), name='message-detail'),

]
