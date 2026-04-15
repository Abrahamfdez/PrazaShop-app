import 'dart:convert';

import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/usuario_service.dart';
import 'package:praza_shop/models/usuario_dto.dart';

/// Utilidades relacionadas con la API.
///
/// Incluye un helper para extraer el `UsuarioDto` a partir de un JWT (`accessToken`).
class ApiUtils {
  /// Extrae el `UsuarioDto` usando el `accessToken` (JWT).
  ///
  /// - Parsea el JWT para obtener el id de usuario (busca `jti`, `id`, `sub`, `usuarioId`, `userId`).
  /// - Llama a `UsuarioService.getById` para recuperar el `UsuarioDto` desde la API.
  /// Lanza `FormatException` o `Exception` si no se puede obtener el id o el usuario.
  static Future<UsuarioDto> getUserFromToken(ApiService api, String accessToken) async {
    if (accessToken.isEmpty) throw Exception('Access token vacío');

    final payload = _parseJwt(accessToken);
    final idVal = payload['jti'] ?? payload['id'] ?? payload['sub'] ?? payload['usuarioId'] ?? payload['userId'];
    if (idVal == null) throw Exception('No se encontró el id de usuario en el token');

    final userId = int.tryParse(idVal.toString());
    if (userId == null) throw Exception('Id de usuario inválido en el token');

    return await UsuarioService(api).getById(userId);
  }

  static Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw FormatException('Token no es un JWT válido');

    var payload = parts[1];
    // Normaliza el payload para base64URL
    payload = base64Url.normalize(payload);
    final payloadBytes = base64Url.decode(payload);
    final payloadMap = json.decode(utf8.decode(payloadBytes));
    if (payloadMap is! Map<String, dynamic>) throw FormatException('Payload JWT no es JSON');
    return payloadMap as Map<String, dynamic>;
  }
}
