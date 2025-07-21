// Placeholder para ApiConfig
class ApiConfig {
  static const String baseUrl = 'https://api.myapp.com';
  static const String usersEndpoint = '/users';
  static const String loginEndpoint = '/login';
  static const int timeoutDuration = 30;

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
