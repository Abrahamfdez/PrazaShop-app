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
}
