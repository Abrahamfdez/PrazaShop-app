import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/producto_dto.dart';

class ProductoService {
  final ApiService api;
  ProductoService(this.api);

  Future<List<ProductoDto>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/productos');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => ProductoDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get productos failed: ${res.statusCode} ${res.body}');
  }

  Future<ProductoDto> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return ProductoDto.fromJson(json.decode(res.body));
    throw Exception('Get producto failed: ${res.statusCode} ${res.body}');
  }

  Future<ProductoDto> create(ProductoDto p) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return ProductoDto.fromJson(json.decode(res.body));
    throw Exception('Create producto failed: ${res.statusCode} ${res.body}');
  }

  Future<ProductoDto> update(int id, ProductoDto p) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200) return ProductoDto.fromJson(json.decode(res.body));
    throw Exception('Update producto failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete producto failed: ${res.statusCode} ${res.body}');
  }
  Future<List<ProductoDto>> getByNegocioId(int negocioId) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos/negocio/$negocioId');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => ProductoDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get productos by negocio failed: ${res.statusCode} ${res.body}');
  }

  /// Obtiene los detalles de un producto incluyendo info del negocio y estadísticas
  Future<Map<String, dynamic>> getProductoDetalles(int productoId) async {
    final uri = Uri.parse('${api.baseUrl}/api/productos/$productoId/detalles');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Get producto detalles failed: ${res.statusCode} ${res.body}');
  }

  // ===== NUEVOS ENDPOINTS USER-SCOPED (Fase 3) =====

  /// Crea un nuevo producto para el negocio del usuario autenticado
  Future<ProductoDto> crearProductoEnNegocio(ProductoDto p) async {
    final uri = Uri.parse('${api.baseUrl}/api/mi-negocio/productos');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) {
      return ProductoDto.fromJson(json.decode(res.body));
    }
    throw Exception('Create producto en negocio failed: ${res.statusCode} ${res.body}');
  }

  /// Actualiza un producto del negocio del usuario autenticado
  Future<ProductoDto> actualizarProductoEnNegocio(int id, ProductoDto p) async {
    final uri = Uri.parse('${api.baseUrl}/api/mi-negocio/productos/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200) {
      return ProductoDto.fromJson(json.decode(res.body));
    }
    throw Exception('Update producto en negocio failed: ${res.statusCode} ${res.body}');
  }

  /// Elimina un producto del negocio del usuario autenticado
  Future<void> eliminarProductoDelNegocio(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/mi-negocio/productos/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Delete producto del negocio failed: ${res.statusCode} ${res.body}');
    }
  }

  /// Obtiene todos los productos del negocio del usuario autenticado
  Future<List<ProductoDto>> misProductos({
    int pagina = 0,
    int tamano = 20,
  }) async {
    final params = <String, String>{
      'pagina': pagina.toString(),
      'tamaño': tamano.toString(),
    };

    final uri = Uri.parse('${api.baseUrl}/api/mi-negocio/productos').replace(queryParameters: params);
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => ProductoDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get mis productos failed: ${res.statusCode} ${res.body}');
  }
}
