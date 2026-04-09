import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/detalle_pedido.dart';

class DetallePedidoService {
  final ApiService api;
  DetallePedidoService(this.api);

  Future<List<DetallePedido>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/detalles-pedidos');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => DetallePedido.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get detalles-pedidos failed: ${res.statusCode} ${res.body}');
  }

  Future<DetallePedido> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/detalles-pedidos/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return DetallePedido.fromJson(json.decode(res.body));
    throw Exception('Get detalle-pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<DetallePedido> create(DetallePedido d) async {
    final uri = Uri.parse('${api.baseUrl}/api/detalles-pedidos');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(d.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return DetallePedido.fromJson(json.decode(res.body));
    throw Exception('Create detalle-pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<DetallePedido> update(int id, DetallePedido d) async {
    final uri = Uri.parse('${api.baseUrl}/api/detalles-pedidos/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(d.toJson()));
    if (res.statusCode == 200) return DetallePedido.fromJson(json.decode(res.body));
    throw Exception('Update detalle-pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/detalles-pedidos/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete detalle-pedido failed: ${res.statusCode} ${res.body}');
  }
}
