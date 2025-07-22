import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/media_content.dart';

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
        if (responseData.containsKey('access')) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', responseData['access']);
          
          // Salva também o refresh token se disponível
          if (responseData.containsKey('refresh')) {
            await prefs.setString('refresh_token', responseData['refresh']);
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
  
  // Método para criar uma nova sessão na API
  // Automaticamente associa a sessão ao usuário logado via token JWT
  static Future<Map<String, dynamic>> createSession({
    required String sessionName,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.sessionEndpoint}');
    
    try {
      // Obtém headers com token de autenticação
      final headers = await getAuthHeaders();
      
      // Dados da nova sessão - apenas o nome é necessário
      // O id_user é definido automaticamente pela API baseado no token JWT
      final Map<String, dynamic> body = {
        'name': sessionName,
      };
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: ApiConfig.timeoutDuration));
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Sessão criada com sucesso!',
          'data': responseData, // Contém os dados da sessão criada, incluindo ID
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
  
  // Método para buscar todas as sessões do usuário logado
  static Future<Map<String, dynamic>> fetchUserSessions() async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.sessionEndpoint}');
    
    try {
      final headers = await getAuthHeaders();
      
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(Duration(seconds: ApiConfig.timeoutDuration));
      
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        
        // Converte os dados da API para o formato Session local
        List<Map<String, dynamic>> sessions = [];
        
        for (var item in responseData) {
          try {
            // Mapeia os dados da API para o formato esperado pelo modelo Session
            sessions.add({
              'id': item['id_sessao']?.toString() ?? item['id']?.toString() ?? '',
              'title': item['name']?.toString() ?? 'Sessão sem nome',
              'createdAt': DateTime.now().toIso8601String(), // Como não há timestamp na API, usa o atual
              'lastModified': DateTime.now().toIso8601String(),
              'contents': [], // Conteúdos serão carregados separadamente
              'description': null,
            });
          } catch (e) {
            print('Erro ao processar sessão da API: $e');
            // Não adiciona sessão inválida - apenas registra o erro
          }
        }
        
        return {
          'success': true,
          'message': 'Sessões carregadas com sucesso!',
          'data': sessions,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': _getErrorMessage(errorData),
          'data': <Map<String, dynamic>>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
        'data': <Map<String, dynamic>>[],
      };
    }
  }
  
  // Método para buscar mensagens de uma sessão
  static Future<Map<String, dynamic>> fetchSessionMessages(String sessionId) async {
    final url = Uri.parse('http://localhost:8050/message/messages/session/$sessionId/');
    
    try {
      final headers = await getAuthHeaders();
      
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(Duration(seconds: ApiConfig.timeoutDuration));
      
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        
        // Converte os dados da API para MediaContent
        List<MediaContent> messages = [];
        
        for (var item in responseData) {
          try {
            // Adapta os dados da API para o formato MediaContent
            MediaContent? content;

            // Verifica se é texto ou mídia baseado nos campos disponíveis
            if (item['tex'] != null && item['tex'].toString().isNotEmpty) {
              // Parseia o timestamp da API
              DateTime createdAt;
              try {
                createdAt = DateTime.parse(item['timestap'].toString());
              } catch (e) {
                createdAt = DateTime.now(); // Fallback se não conseguir parsear
              }
              
              content = MediaContent(
                id: item['key_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
                type: MediaType.text,
                content: item['tex'].toString(),
                createdAt: createdAt,
              );
            } else if (item['media_url'] != null) {
              // Determina o tipo de mídia baseado na extensão ou campo
              MediaType? mediaType;
              String mediaPath = item['media_url'].toString();

              if (item['media_type'] != null) {
                switch (item['media_type'].toString().toLowerCase()) {
                  case 'image':
                    mediaType = MediaType.image;
                    break;
                  case 'video':
                    mediaType = MediaType.video;
                    break;
                  case 'audio':
                    mediaType = MediaType.audio;
                    break;
                }
              } else {
                // Tenta determinar pelo nome do arquivo
                String extension = mediaPath.split('.').last.toLowerCase();
                if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
                  mediaType = MediaType.image;
                } else if (['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].contains(extension)) {
                  mediaType = MediaType.video;
                } else if (['mp3', 'aac', 'wav', 'ogg', 'm4a'].contains(extension)) {
                  mediaType = MediaType.audio;
                }
              }

              if (mediaType != null) {
                // Parseia o timestamp da API
                DateTime createdAt;
                try {
                  createdAt = DateTime.parse(item['timestap'].toString());
                } catch (e) {
                  createdAt = DateTime.now(); // Fallback se não conseguir parsear
                }
                
                content = MediaContent(
                  id: item['key_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  type: mediaType,
                  content: mediaPath,
                  createdAt: createdAt,
                  fileName: mediaPath.split('/').last,
                );
              }
            }

            if (content != null) {
              messages.add(content);
            }
          } catch (e) {
            print('Erro ao processar item da API: $e');
            // Não adiciona conteúdo inválido - apenas registra o erro
          }
        }
        
        return {
          'success': true,
          'message': 'Mensagens carregadas com sucesso!',
          'data': messages,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': _getErrorMessage(errorData),
          'data': <MediaContent>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erro de conexão: ${e.toString()}',
        'data': <MediaContent>[],
      };
    }
  }
  
  // Método para salvar uma nova mensagem na API
  static Future<Map<String, dynamic>> saveMessage({
    required String sessionId,
    int? keyId,
    String? text,
    String? mediaUrl,
    String? mediaType,
    int? mediaSize,
    String? mediaName,
    int? mediaDuration,
  }) async {
    final url = Uri.parse('http://localhost:8050/message/messages/');

    try {
      final headers = await getAuthHeaders();
      
      final Map<String, dynamic> body = {
        'id_sessao': sessionId,
        'key_id': keyId,
        'tex': text,
        'media_url': mediaUrl,
        'media_type': mediaType,
        'media_size': mediaSize,
        'media_name': mediaName,
        'media_duration': mediaDuration,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: ApiConfig.timeoutDuration));

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Mensagem salva com sucesso!',
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
