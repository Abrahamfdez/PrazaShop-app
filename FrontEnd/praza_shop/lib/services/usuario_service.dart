import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/usuario_dto.dart';

class UsuarioService {
  final ApiService api;
  UsuarioService(this.api);

  Future<List<UsuarioDto>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/usuarios');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => UsuarioDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get usuarios failed: ${res.statusCode} ${res.body}');
  }

  Future<UsuarioDto> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/usuarios/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return UsuarioDto.fromJson(json.decode(res.body));
    throw Exception('Get usuario failed: ${res.statusCode} ${res.body}');
  }

  Future<UsuarioDto> create(UsuarioDto u) async {
    final uri = Uri.parse('${api.baseUrl}/api/usuarios');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(u.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return UsuarioDto.fromJson(json.decode(res.body));
    throw Exception('Create usuario failed: ${res.statusCode} ${res.body}');
  }

  Future<UsuarioDto> update(int id, UsuarioDto u) async {
    final uri = Uri.parse('${api.baseUrl}/api/usuarios/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(u.toJson()));
    if (res.statusCode == 200) return UsuarioDto.fromJson(json.decode(res.body));
    throw Exception('Update usuario failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/usuarios/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete usuario failed: ${res.statusCode} ${res.body}');
  }
}
