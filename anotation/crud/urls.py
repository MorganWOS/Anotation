from django.urls import path
from .views import UserCreateView

app_name = 'crud'

urlpatterns = [

    # Usuario endpoints
    path('users/', UserCreateView.as_view(), name='user-list'),
    path('users/<int:pk>/', UserCreateView.as_view(), name='user-detail'),

]
