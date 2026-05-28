import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/pedido_dto.dart';
import '../models/pedido_con_detalles_dto.dart';

class PedidoService {
  final ApiService api;
  PedidoService(this.api);

  Future<List<PedidoDto>> getAll() async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => PedidoDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get pedidos failed: ${res.statusCode} ${res.body}');
  }

  Future<PedidoDto> getById(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/$id');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) return PedidoDto.fromJson(json.decode(res.body));
    throw Exception('Get pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<PedidoDto> create(PedidoDto p) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos');
    final res = await http.post(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return PedidoDto.fromJson(json.decode(res.body));
    throw Exception('Create pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<PedidoDto> update(int id, PedidoDto p) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/$id');
    final res = await http.put(uri, headers: api.headers(), body: json.encode(p.toJson()));
    if (res.statusCode == 200) return PedidoDto.fromJson(json.decode(res.body));
    throw Exception('Update pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<void> delete(int id) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/$id');
    final res = await http.delete(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode != 200 && res.statusCode != 204) throw Exception('Delete pedido failed: ${res.statusCode} ${res.body}');
  }

  Future<List<PedidoDto>> findByNegocioId(int negocioId) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/negocio/$negocioId');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => PedidoDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get pedidos by negocio failed: ${res.statusCode} ${res.body}');
  }

  Future<List<PedidoDto>> findByClienteId(int clienteId) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/cliente/$clienteId');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => PedidoDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get pedidos by cliente failed: ${res.statusCode} ${res.body}');
  }

  Future<List<PedidoConDetallesDto>> findByClienteIdConDetalles(int clienteId) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/cliente/$clienteId/detalles');
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List<dynamic>;
      return data.map((e) => PedidoConDetallesDto.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Get pedidos with details by cliente failed: ${res.statusCode} ${res.body}');
  }

  /// Crea un pedido completo con detalles en una sola llamada atómica
  Future<PedidoConDetallesDto> crearPedidoCompleto({
    required int clienteId,
    required int negocioId,
    required List<Map<String, dynamic>> detalles, // [{productoId, cantidad}, ...]
  }) async {
    final uri = Uri.parse('${api.baseUrl}/api/pedidos/crear-completo');
    final body = json.encode({
      'clienteId': clienteId,
      'negocioId': negocioId,
      'detalles': detalles,
    });
    final res = await http.post(uri, headers: api.headers(), body: body);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return PedidoConDetallesDto.fromJson(json.decode(res.body));
    }
    throw Exception('Crear pedido completo failed: ${res.statusCode} ${res.body}');
  }

  /// Busca pedidos con filtros y paginación
  Future<Map<String, dynamic>> buscarPedidos({
    String? estado,
    String? fechaDesde,
    String? fechaHasta,
    double? precioDesde,
    double? precioHasta,
    String ordenar = 'fecha_desc',
    int pagina = 0,
    int tamano = 10,
  }) async {
    final params = <String, String>{
      'ordenar': ordenar,
      'pagina': pagina.toString(),
      'tamano': tamano.toString(),
    };

    if (estado != null) params['estado'] = estado;
    if (fechaDesde != null) params['fechaDesde'] = fechaDesde;
    if (fechaHasta != null) params['fechaHasta'] = fechaHasta;
    if (precioDesde != null) params['precioDesde'] = precioDesde.toString();
    if (precioHasta != null) params['precioHasta'] = precioHasta.toString();

    final uri = Uri.parse('${api.baseUrl}/api/pedidos/buscar').replace(queryParameters: params);
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Buscar pedidos failed: ${res.statusCode} ${res.body}');
  }

  /// ===== NUEVOS ENDPOINTS USER-SCOPED (Fase 3) =====

  /// Obtiene los pedidos del cliente autenticado con paginación
  Future<Map<String, dynamic>> misPedidos({
    int pagina = 0,
    int tamano = 10,
  }) async {
    final params = <String, String>{
      'pagina': pagina.toString(),
      'tamaño': tamano.toString(),
    };

    final uri = Uri.parse('${api.baseUrl}/api/mi-compra/pedidos').replace(queryParameters: params);
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Get mis pedidos failed: ${res.statusCode} ${res.body}');
  }

  /// Obtiene las ventas del negocio autenticado con paginación
  Future<Map<String, dynamic>> misVentas({
    int pagina = 0,
    int tamano = 10,
  }) async {
    final params = <String, String>{
      'pagina': pagina.toString(),
      'tamaño': tamano.toString(),
    };

    final uri = Uri.parse('${api.baseUrl}/api/mi-negocio/ventas').replace(queryParameters: params);
    final res = await http.get(uri, headers: api.headers(jsonBody: false));
    if (res.statusCode == 200) {
      return json.decode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Get mis ventas failed: ${res.statusCode} ${res.body}');
  }

  /// Crea un pedido como cliente (auto-resuelve clienteId)
  Future<PedidoConDetallesDto> crearPedidoComoCliente({
    required int negocioId,
    required List<Map<String, dynamic>> detalles, // [{productoId, cantidad}, ...]
  }) async {
    final uri = Uri.parse('${api.baseUrl}/api/mi-compra/pedidos');
    final body = json.encode({
      'negocioId': negocioId,
      'detalles': detalles,
    });
    final res = await http.post(uri, headers: api.headers(), body: body);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return PedidoConDetallesDto.fromJson(json.decode(res.body));
    }
    throw Exception('Crear pedido como cliente failed: ${res.statusCode} ${res.body}');
  }

  /// Actualiza el estado de un pedido (solo propietario del negocio)
  Future<PedidoConDetallesDto> actualizarEstadoPedido({
    required int pedidoId,
    required String nuevoEstado,
  }) async {
    final uri = Uri.parse('${api.baseUrl}/api/mi-negocio/ventas/$pedidoId/estado');
    final bodyMap = {
      'nuevoEstado': nuevoEstado,
    };
    final body = json.encode(bodyMap);
    print('DEBUG: Actualizando estado - URI: $uri');
    print('DEBUG: Body enviado: $body');
    final res = await http.put(uri, headers: api.headers(), body: body);
    print('DEBUG: Response status: ${res.statusCode}');
    print('DEBUG: Response body: ${res.body}');
    if (res.statusCode == 200) {
      return PedidoConDetallesDto.fromJson(json.decode(res.body));
    }
    throw Exception('Actualizar estado pedido failed: ${res.statusCode} ${res.body}');
  }
}
