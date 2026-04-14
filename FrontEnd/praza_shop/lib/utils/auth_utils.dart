import 'dart:convert';

import '../services/api_service.dart';
import '../services/usuario_service.dart';

/// Enum con los posibles tipos de usuario reconocidos por la app.
///
/// Valores: `CLIENTE`, `NEGOCIO`, `ADMIN`, `DESCONOCIDO`.
enum UserRole { CLIENTE, NEGOCIO, ADMIN, DESCONOCIDO }

/// Utilidades relacionadas con la autenticación y manejo de JWT.
class AuthUtils {

  /// Decodifica el payload de un JWT y devuelve el mapa con sus campos.
  ///
  /// Lanza una [Exception] si el token no tiene el formato correcto o si
  /// el payload no puede convertirse a `Map<String, dynamic>`.
  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Token inválido');
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final map = json.decode(decoded);
    if (map is! Map<String, dynamic>) throw Exception('Payload inválido');
    return map;
  }

  /// Realiza el proceso de autenticación y devuelve el rol identificado.
  ///
  /// - Llama a `api.login` y almacena los tokens en `api`.
  /// - Intenta extraer el ID de usuario desde el JWT y obtener los
  ///   detalles del usuario para determinar su `UserRole`.
  /// - Devuelve `UserRole.DESCONOCIDO` si no se puede determinar el rol.
  static Future<UserRole> performLoginAndGetInfo(ApiService api, String email, String password) async {
    final auth = await api.login(email.trim(), password);
    api.setTokens(accessToken: auth.accessToken, refreshToken: auth.refreshToken);

    int? userId;
    try {
      final payload = parseJwt(auth.accessToken);
      final idVal = payload['jti'] ?? payload['id'];
      if (idVal != null) userId = int.tryParse(idVal.toString());
    } catch (_) {
      userId = null;
    }

    // Por defecto, desconocido.
    UserRole role = UserRole.DESCONOCIDO;
    if (userId != null) {
      try {
        final usuario = await UsuarioService(api).getById(userId).timeout(const Duration(seconds: 20));
        final tipo = usuario.tipoUsuario?.toString().toLowerCase();
        if (tipo == 'cliente' || tipo == 'CLIENTE'.toLowerCase()) {
          role = UserRole.CLIENTE;
        } else if (tipo == 'negocio' || tipo == 'NEGOCIO'.toLowerCase()) {
          role = UserRole.NEGOCIO;
        } else if (tipo == 'admin' || tipo == 'ADMIN'.toLowerCase()) {
          role = UserRole.ADMIN;
        } else {
          role = UserRole.DESCONOCIDO;
        }
      } catch (e) {
        role = UserRole.DESCONOCIDO;
      }
    }

    return role;
  }

  /// Registra un nuevo usuario (cliente o negocio) y devuelve el `UserRole`.
  ///
  /// El `body` debe contener los campos esperados por el endpoint `/api/auth/register`.
  /// Tras un registro exitoso `ApiService.register` devuelve un `AuthResponse`
  /// y almacena los tokens en `api`. Aquí extraemos el `accessToken`, decodificamos
  /// para obtener el id de usuario y consultamos `UsuarioService` para determinar
  /// el rol real del usuario.
  static Future<UserRole> registerAndGetRole(ApiService api, Map<String, dynamic> body) async {
    final auth = await api.register(body);
    api.setTokens(accessToken: auth.accessToken, refreshToken: auth.refreshToken);

    int? userId;
    try {
      final payload = parseJwt(auth.accessToken);
      final idVal = payload['jti'] ?? payload['id'];
      if (idVal != null) userId = int.tryParse(idVal.toString());
    } catch (_) {
      userId = null;
    }

    UserRole role = UserRole.DESCONOCIDO;
    if (userId != null) {
      try {
        final usuario = await UsuarioService(api).getById(userId).timeout(const Duration(seconds: 20));
        final tipo = usuario.tipoUsuario?.toString().toLowerCase();
        if (tipo == 'cliente') {
          role = UserRole.CLIENTE;
        } else if (tipo == 'negocio') {
          role = UserRole.NEGOCIO;
        } else if (tipo == 'admin') {
          role = UserRole.ADMIN;
        } else {
          role = UserRole.DESCONOCIDO;
        }
      } catch (e) {
        role = UserRole.DESCONOCIDO;
      }
    }

    return role;
  }
}
