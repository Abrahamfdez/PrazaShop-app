import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/pedido.dart';

class PedidoService {
  final ApiService api;
  PedidoService(this.api);

  Future<List<Pedido>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => Pedido.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get pedidos failed: ${res.statusCode} ${res.body}');
  }

  Future<Pedido> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return Pedido.fromJson(json.decode(res.body));
    throw Exception('Get pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<Pedido> create(Pedido p) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return Pedido.fromJson(json.decode(res.body));
    throw Exception('Create pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<Pedido> update(int id, Pedido p) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200) return Pedido.fromJson(json.decode(res.body));
    throw Exception('Update pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete pedido failed: ${res.statusCode} ${res.body}');
  }
}
