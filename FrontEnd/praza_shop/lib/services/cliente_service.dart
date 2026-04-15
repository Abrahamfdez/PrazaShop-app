import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/cliente_dto.dart';

class ClienteService {
  final ApiService api;
  ClienteService(this.api);

  Future<List<ClienteDto>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => ClienteDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get clientes failed: ${res.statusCode} ${res.body}');
  }

  Future<ClienteDto> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return ClienteDto.fromJson(json.decode(res.body));
    throw Exception('Get cliente failed: ${res.statusCode} ${res.body}');
  }

  Future<ClienteDto> getByUsuarioId(int usuarioId) async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes/usuario/$usuarioId');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return ClienteDto.fromJson(json.decode(res.body));
    if (res.statusCode == 404) throw Exception('Cliente no encontrado para usuarioId: $usuarioId');
    throw Exception('Get cliente by usuarioId failed: ${res.statusCode} ${res.body}');
  }

  Future<ClienteDto> create(ClienteDto c) async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(c.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return ClienteDto.fromJson(json.decode(res.body));
    throw Exception('Create cliente failed: ${res.statusCode} ${res.body}');
  }

  Future<ClienteDto> update(int id, ClienteDto c) async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(c.toJson()));
    if (res.statusCode == 200) return ClienteDto.fromJson(json.decode(res.body));
    throw Exception('Update cliente failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/clientes/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete cliente failed: ${res.statusCode} ${res.body}');
  }
}
