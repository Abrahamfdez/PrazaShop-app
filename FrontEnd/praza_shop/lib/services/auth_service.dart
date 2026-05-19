import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AuthService {
  final ApiService api;
  AuthService(this.api);

  /// Registra un nuevo vendedor (usuario + negocio) en transaccion atomica
  /// Retorna un mapa con usuario, negocio, token y refreshToken
  Future<Map<String, dynamic>> registrarVendedor({
    required String email,
    required String contrasena,
    required String nombreNegocio,
    String? descripcion,
  }) async {
    final uri = Uri.parse('${api.baseUrl}/api/auth/register-vendedor');
    final body = json.encode({
      'email': email,
      'contrasena': contrasena,
      'nombreNegocio': nombreNegocio,
      'descripcion': descripcion ?? '',
    });
    
    final res = await http.post(uri, headers: api.headers(), body: body);
    
    if (res.statusCode == 200 || res.statusCode == 201) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Registrar vendedor failed: ${res.statusCode} ${res.body}');
  }

  /// Login de usuario (retorna token y refreshToken)
  Future<Map<String, dynamic>> login({
    required String email,
    required String contrasena,
  }) async {
    final uri = Uri.parse('${api.baseUrl}/api/auth/login');
    final body = json.encode({
      'email': email,
      'contrasena': contrasena,
    });
    
    final res = await http.post(uri, headers: api.headers(), body: body);
    
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Login failed: ${res.statusCode} ${res.body}');
  }

  /// Refresh de access token usando refresh token
  Future<Map<String, dynamic>> refreshToken({required String refreshToken}) async {
    final uri = Uri.parse('${api.baseUrl}/api/auth/refresh');
    final body = json.encode({'refreshToken': refreshToken});
    
    final res = await http.post(uri, headers: api.headers(), body: body);
    
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Refresh token failed: ${res.statusCode} ${res.body}');
  }
}
