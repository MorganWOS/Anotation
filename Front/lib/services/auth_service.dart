import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/datasources/api_service.dart';

class AuthService {
  static const String _jwtTokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  // Verificar se o usuário está autenticado
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_jwtTokenKey);
    return token != null && token.isNotEmpty;
  }
  
  // Obter token JWT
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jwtTokenKey);
  }
  
  // Obter refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }
  
  // Obter dados do usuário
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }
  
  // Salvar dados de autenticação
  Future<void> saveAuthData({
    required String token,
    String? refreshToken,
    Map<String, dynamic>? userData,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString(_jwtTokenKey, token);
    
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
    
    if (userData != null) {
      await prefs.setString(_userDataKey, jsonEncode(userData));
    }
  }
  
  // Fazer logout (limpar dados)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jwtTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userDataKey);
  }
  
  // Fazer login
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final result = await ApiService.loginUser(
      username: username,
      password: password,
    );
    
    if (result['success'] && result['data'] != null) {
      final data = result['data'];
      
      // Salvar token JWT
      if (data.containsKey('access')) {
        await saveAuthData(
          token: data['access'],
          refreshToken: data['refresh'],
          userData: data['user'],
        );
      }
    }
    
    return result;
  }
  
  // Obter headers com autenticação
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  // Verificar se o token está expirado (básico)
  Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) return true;
    
    // Aqui você pode implementar a lógica para verificar se o token JWT está expirado
    // Por exemplo, decodificar o token e verificar o campo 'exp'
    // Por enquanto, vamos assumir que o token é válido se existir
    return false;
  }
  
  // Atualizar token usando refresh token
  Future<bool> refreshToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;
    
    // Aqui você implementaria a lógica para atualizar o token usando o refresh token
    // Por enquanto, vamos retornar false
    return false;
  }
}
