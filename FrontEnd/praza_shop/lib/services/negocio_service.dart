import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/negocio_dto.dart';

class NegocioService {
  final ApiService api;
  NegocioService(this.api);

  Future<List<NegocioDto>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => NegocioDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get negocios failed: ${res.statusCode} ${res.body}');
  }

  Future<NegocioDto> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return NegocioDto.fromJson(json.decode(res.body));
    throw Exception('Get negocio failed: ${res.statusCode} ${res.body}');
  }

  Future<NegocioDto> getByUsuarioId(int usuarioId) async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios/usuario/$usuarioId');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return NegocioDto.fromJson(json.decode(res.body));
    if (res.statusCode == 404) throw Exception('Negocio no encontrado para usuarioId: $usuarioId');
    throw Exception('Get negocio by usuarioId failed: ${res.statusCode} ${res.body}');
  }

  Future<NegocioDto> create(NegocioDto n) async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(n.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return NegocioDto.fromJson(json.decode(res.body));
    throw Exception('Create negocio failed: ${res.statusCode} ${res.body}');
  }

  Future<NegocioDto> update(int id, NegocioDto n) async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(n.toJson()));
    if (res.statusCode == 200) return NegocioDto.fromJson(json.decode(res.body));
    throw Exception('Update negocio failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/negocios/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete negocio failed: ${res.statusCode} ${res.body}');
  }
}
