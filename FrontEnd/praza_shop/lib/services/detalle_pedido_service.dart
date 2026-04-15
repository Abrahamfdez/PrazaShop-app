import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/detalle_pedido_dto.dart';

class DetallePedidoService {
  final ApiService api;
  DetallePedidoService(this.api);

  Future<List<DetallePedidoDto>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/detalle-pedidos');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => DetallePedidoDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get detalle-pedidos failed: ${res.statusCode} ${res.body}');
  }

  Future<DetallePedidoDto> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/detalle-pedidos/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return DetallePedidoDto.fromJson(json.decode(res.body));
    throw Exception('Get detalle-pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<DetallePedidoDto> create(DetallePedidoDto d) async {
    final uri = Uri.parse('${api.baseUrl}/api/detalle-pedidos');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(d.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return DetallePedidoDto.fromJson(json.decode(res.body));
    throw Exception('Create detalle-pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<DetallePedidoDto> update(int id, DetallePedidoDto d) async {
    final uri = Uri.parse('${api.baseUrl}/api/detalle-pedidos/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(d.toJson()));
    if (res.statusCode == 200) return DetallePedidoDto.fromJson(json.decode(res.body));
    throw Exception('Update detalle-pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/detalle-pedidos/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete detalle-pedido failed: ${res.statusCode} ${res.body}');
  }
}
