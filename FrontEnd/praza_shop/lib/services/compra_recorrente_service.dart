import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/compra_recorrente_dto.dart';

class CompraRecorrenteService {
  final ApiService api;
  CompraRecorrenteService(this.api);

  Future<List<CompraRecorrenteDto>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recorrentes');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => CompraRecorrenteDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get compras-recorrentes failed: ${res.statusCode} ${res.body}');
  }

  Future<CompraRecorrenteDto> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recorrentes/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return CompraRecorrenteDto.fromJson(json.decode(res.body));
    throw Exception('Get compra-recorrente failed: ${res.statusCode} ${res.body}');
  }

  Future<CompraRecorrenteDto> create(CompraRecorrenteDto c) async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recorrentes');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(c.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return CompraRecorrenteDto.fromJson(json.decode(res.body));
    throw Exception('Create compra-recorrente failed: ${res.statusCode} ${res.body}');
  }

  Future<CompraRecorrenteDto> update(int id, CompraRecorrenteDto c) async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recorrentes/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(c.toJson()));
    if (res.statusCode == 200) return CompraRecorrenteDto.fromJson(json.decode(res.body));
    throw Exception('Update compra-recorrente failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/compras-recorrentes/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete compra-recorrente failed: ${res.statusCode} ${res.body}');
  }

  /// ===== NUEVOS ENDPOINTS USER-SCOPED (Fase 3) =====

  /// Obtiene las compras recurrentes del cliente autenticado
  Future<List<CompraRecorrenteDto>> misComprasRecurrentes() async {
    final uri = Uri.parse('${api.baseUrl}/api/mis-compras-recurrentes');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => CompraRecorrenteDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get mis compras recurrentes failed: ${res.statusCode} ${res.body}');
  }
}
