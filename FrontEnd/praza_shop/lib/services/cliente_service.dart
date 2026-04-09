import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/cliente.dart';

class ClienteService {
  final ApiService api;
  ClienteService(this.api);

  Future<List<Cliente>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => Cliente.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get clientes failed: ${res.statusCode} ${res.body}');
  }

  Future<Cliente> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return Cliente.fromJson(json.decode(res.body));
    throw Exception('Get cliente failed: ${res.statusCode} ${res.body}');
  }

  Future<Cliente> create(Cliente c) async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(c.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return Cliente.fromJson(json.decode(res.body));
    throw Exception('Create cliente failed: ${res.statusCode} ${res.body}');
  }

  Future<Cliente> update(int id, Cliente c) async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(c.toJson()));
    if (res.statusCode == 200) return Cliente.fromJson(json.decode(res.body));
    throw Exception('Update cliente failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete cliente failed: ${res.statusCode} ${res.body}');
  }
}
