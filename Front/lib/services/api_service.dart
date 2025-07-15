import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  
  // Método para cadastrar usuário
  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String username,
    DateTime? birthDate,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersEndpoint}');
    
    try {
      final Map<String, dynamic> body = {
        'username': username,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'is_staff': false,
        'is_active': true,
        'is_superuser': false,
        'last_login': DateTime.now().toIso8601String(), // Providing a fixed last_login value
        'date_joined': DateTime.now().toIso8601String(),
      };
      
      // Adiciona data de nascimento se fornecida
      if (birthDate != null) {
        body['dtnascimento'] = birthDate.toIso8601String().split('T')[0];
      }
      
      final response = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: ApiConfig.timeoutDuration));
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Usuário cadastrado com sucesso!',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': _getErrorMessage(responseData),
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
        'data': null,
      };
    }
  }
  
  // Método para fazer login do usuário
  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}');
    
    try {
      final Map<String, dynamic> body = {
        'username': username,
        'password': password,
      };
      
      final response = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: ApiConfig.timeoutDuration));
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Salva o token JWT no SharedPreferences
        if (responseData.containsKey('access_token')) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', responseData['access_token']);
          
          // Salva também o refresh token se disponível
          if (responseData.containsKey('refresh_token')) {
            await prefs.setString('refresh_token', responseData['refresh_token']);
          }
          
          // Salva informações do usuário se disponíveis
          if (responseData.containsKey('user')) {
            await prefs.setString('user_data', jsonEncode(responseData['user']));
          }
        }
        
        return {
          'success': true,
          'message': 'Login realizado com sucesso!',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': _getErrorMessage(responseData),
          'data': responseData,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
        'data': null,
      };
    }
  }
  
  // Método para obter o token JWT salvo
  static Future<String?> getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }
  
  // Método para verificar se o usuário está logado
  static Future<bool> isLoggedIn() async {
    final token = await getJwtToken();
    return token != null && token.isNotEmpty;
  }
  
  // Método para fazer logout (remover tokens)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');
  }
  
  // Método para obter headers com autenticação
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getJwtToken();
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  // Método auxiliar para extrair mensagens de erro
  static String _getErrorMessage(Map<String, dynamic> errorData) {
    if (errorData.containsKey('error')) {
      return errorData['error'];
    }
    
    // Se há erros de validação específicos
    List<String> errors = [];
    errorData.forEach((key, value) {
      if (value is List) {
        for (var error in value) {
          errors.add('$key: $error');
        }
      } else {
        errors.add('$key: $value');
      }
    });
    
    if (errors.isNotEmpty) {
      return errors.join(', ');
    }
    
    return 'Erro desconhecido';
  }
}
