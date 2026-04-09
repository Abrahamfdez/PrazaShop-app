import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/negocio.dart';

class NegocioService {
  final ApiService api;
  NegocioService(this.api);

  Future<List<Negocio>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => Negocio.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get negocios failed: ${res.statusCode} ${res.body}');
  }

  Future<Negocio> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return Negocio.fromJson(json.decode(res.body));
    throw Exception('Get negocio failed: ${res.statusCode} ${res.body}');
  }

  Future<Negocio> create(Negocio n) async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(n.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return Negocio.fromJson(json.decode(res.body));
    throw Exception('Create negocio failed: ${res.statusCode} ${res.body}');
  }

  Future<Negocio> update(int id, Negocio n) async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(n.toJson()));
    if (res.statusCode == 200) return Negocio.fromJson(json.decode(res.body));
    throw Exception('Update negocio failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete negocio failed: ${res.statusCode} ${res.body}');
  }
}
