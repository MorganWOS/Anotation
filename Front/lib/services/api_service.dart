import 'dart:convert';
import 'package:http/http.dart' as http;
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
  
  // Método auxiliar para extrair mensagens de erro
  static String _getErrorMessage(Map<String, dynamic> errorData) {
    if (errorData.containsKey('error')) {
      return errorData['error'];
    }
    
    // Se há erros de validação específicos
    if (errorData is Map) {
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
      return errors.join(', ');
    }
    
    return 'Erro desconhecido';
  }
}
