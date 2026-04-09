import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/valoracion.dart';

class ValoracionService {
  final ApiService api;
  ValoracionService(this.api);

  Future<List<Valoracion>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => Valoracion.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get valoraciones failed: ${res.statusCode} ${res.body}');
  }

  Future<Valoracion> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return Valoracion.fromJson(json.decode(res.body));
    throw Exception('Get valoracion failed: ${res.statusCode} ${res.body}');
  }

  Future<Valoracion> create(Valoracion v) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(v.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return Valoracion.fromJson(json.decode(res.body));
    throw Exception('Create valoracion failed: ${res.statusCode} ${res.body}');
  }

  Future<Valoracion> update(int id, Valoracion v) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(v.toJson()));
    if (res.statusCode == 200) return Valoracion.fromJson(json.decode(res.body));
    throw Exception('Update valoracion failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/valoraciones/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete valoracion failed: ${res.statusCode} ${res.body}');
  }
}
