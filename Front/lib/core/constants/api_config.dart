class ApiConfig {
  // URL base da API Django
  // Para desenvolvimento local, use: http://localhost:8000
  // Para produção, substitua pelo URL do seu servidor
  static const String baseUrl = 'http://localhost:8050';
  
  // Endpoints da API
  static const String usersEndpoint = '/crud/users/';
  static const String loginEndpoint = '/token/';
  
  // Timeout para requisições (em segundos)
  static const int timeoutDuration = 30;
  
  // Headers padrão
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
