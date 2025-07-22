// Placeholder para ApiConfig
class ApiConfig {
  static const String baseUrl = 'http://localhost:8050';
  static const String usersEndpoint = '/crud/users/';
  static const String loginEndpoint = '/token/';
  static const String sessionEndpoint = '/sessao/sessao/';
  static const int timeoutDuration = 30;

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
