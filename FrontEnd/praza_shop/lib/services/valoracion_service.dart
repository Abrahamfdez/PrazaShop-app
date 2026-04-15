import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/valoracion_dto.dart';

class ValoracionService {
  final ApiService api;
  ValoracionService(this.api);

  Future<List<ValoracionDto>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => ValoracionDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get valoraciones failed: ${res.statusCode} ${res.body}');
  }

  Future<ValoracionDto> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return ValoracionDto.fromJson(json.decode(res.body));
    throw Exception('Get valoracion failed: ${res.statusCode} ${res.body}');
  }

  Future<List<ValoracionDto>> getByNegocioId(int negocioId) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones/negocio/$negocioId');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => ValoracionDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get valoraciones by negocio failed: ${res.statusCode} ${res.body}');
  }

  Future<List<ValoracionDto>> getByClienteId(int clienteId) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones/cliente/$clienteId');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => ValoracionDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get valoraciones by cliente failed: ${res.statusCode} ${res.body}');
  }

  Future<ValoracionDto> create(ValoracionDto v) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(v.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return ValoracionDto.fromJson(json.decode(res.body));
    throw Exception('Create valoracion failed: ${res.statusCode} ${res.body}');
  }

  Future<ValoracionDto> update(int id, ValoracionDto v) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(v.toJson()));
    if (res.statusCode == 200) return ValoracionDto.fromJson(json.decode(res.body));
    throw Exception('Update valoracion failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete valoracion failed: ${res.statusCode} ${res.body}');
  }
}
