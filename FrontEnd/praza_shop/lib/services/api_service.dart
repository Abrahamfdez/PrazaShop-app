import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';

/// Excepción lanzada cuando la API responde con un código distinto de 2xx.
class ApiException implements Exception {
  final int statusCode;
  final String body;
  final String? message;
  ApiException(this.statusCode, this.body, [this.message]);

  @override
  String toString() => 'ApiException: $statusCode ${message ?? body}';
}

class ApiService {
  final String baseUrl;
  String? _accessToken;
  String? _refreshToken;

  ApiService(this.baseUrl);

  void setTokens({String? accessToken, String? refreshToken}) {
    if (accessToken != null) _accessToken = accessToken;
    if (refreshToken != null) _refreshToken = refreshToken;
  }

  Map<String, String> _defaultHeaders({bool jsonBody = true}) {
    final headers = <String, String>{};
    if (jsonBody) headers['Content-Type'] = 'application/json';
    if (_accessToken != null) headers['Authorization'] = 'Bearer $_accessToken';
    return headers;
  }

  /// Public accessor for default headers so other services can reuse auth header.
  Map<String, String> headers({bool jsonBody = true}) => _defaultHeaders(jsonBody: jsonBody);

  Future<AuthResponse> register(Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');
    try {
      final res = await http.post(uri, headers: _defaultHeaders(), body: json.encode(body));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = json.decode(res.body);
        final auth = AuthResponse.fromJson(data);
        setTokens(accessToken: auth.accessToken, refreshToken: auth.refreshToken);
        return auth;
      }
      // Intentar parsear el cuerpo de error JSON para proporcionar información útil
      String? parsedMessage;
      try {
        final map = json.decode(res.body);
        if (map is Map && map['message'] != null) parsedMessage = map['message'].toString();
      } catch (_) {
        parsedMessage = null;
      }
      throw ApiException(res.statusCode, res.body, parsedMessage);
    } on SocketException catch (e) {
      throw Exception('Network error (register): ${e.message}');
    } catch (e) {
      throw Exception('Register error: $e');
    }
  }

  Future<AuthResponse> login(String email, String contrasinal) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');
    try {
      final res = await http.post(uri,
          headers: _defaultHeaders(), body: json.encode({'email': email, 'contrasinal': contrasinal}));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final auth = AuthResponse.fromJson(data);
        setTokens(accessToken: auth.accessToken, refreshToken: auth.refreshToken);
        return auth;
      }
      throw Exception('Login failed: ${res.statusCode} ${res.body}');
    } on SocketException catch (e) {
      throw Exception('Network error (login): ${e.message}');
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<AuthResponse> refresh() async {
    if (_refreshToken == null) throw Exception('No refresh token available');
    final uri = Uri.parse('$baseUrl/api/auth/refresh');
    try {
      final res = await http.post(uri,
          headers: _defaultHeaders(), body: json.encode({'refreshToken': _refreshToken}));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final auth = AuthResponse.fromJson(data);
        setTokens(accessToken: auth.accessToken, refreshToken: auth.refreshToken);
        return auth;
      }
      throw Exception('Refresh failed: ${res.statusCode} ${res.body}');
    } on SocketException catch (e) {
      throw Exception('Network error (refresh): ${e.message}');
    } catch (e) {
      throw Exception('Refresh error: $e');
    }
  }
}
