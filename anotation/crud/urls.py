from django.urls import path
from .views import UserView

app_name = 'crud'

urlpatterns = [

    # Usuario endpoints
    path('users/', UserView.as_view(), name='user-list'),
    path('users/<int:pk>/', UserView.as_view(), name='user-detail'),

]
