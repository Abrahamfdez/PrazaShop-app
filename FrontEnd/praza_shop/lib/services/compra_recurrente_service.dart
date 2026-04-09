import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/compra_recurrente.dart';

class CompraRecurrenteService {
  final ApiService api;
  CompraRecurrenteService(this.api);

  Future<List<CompraRecurrente>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recurrentes');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => CompraRecurrente.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get compras-recurrentes failed: ${res.statusCode} ${res.body}');
  }

  Future<CompraRecurrente> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recurrentes/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return CompraRecurrente.fromJson(json.decode(res.body));
    throw Exception('Get compra-recurrente failed: ${res.statusCode} ${res.body}');
  }

  Future<CompraRecurrente> create(CompraRecurrente c) async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recurrentes');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(c.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return CompraRecurrente.fromJson(json.decode(res.body));
    throw Exception('Create compra-recurrente failed: ${res.statusCode} ${res.body}');
  }

  Future<CompraRecurrente> update(int id, CompraRecurrente c) async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recurrentes/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(c.toJson()));
    if (res.statusCode == 200) return CompraRecurrente.fromJson(json.decode(res.body));
    throw Exception('Update compra-recurrente failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recurrentes/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete compra-recurrente failed: ${res.statusCode} ${res.body}');
  }
}
