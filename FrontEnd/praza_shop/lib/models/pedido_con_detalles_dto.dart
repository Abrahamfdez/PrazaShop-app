import 'detalle_pedido_con_producto_dto.dart';

class PedidoConDetallesDto {
  final int? idPedido;
  final int? clienteId;
  final int? negocioId;
  final DateTime? dataPedido;
  final DateTime? dataConfirmacion;
  final DateTime? dataEntrega;
  final DateTime? dataCancelacion;
  final String? estado;
  final double? total;
  final List<DetallePedidoConProductoDto>? detalles;

  PedidoConDetallesDto({
    this.idPedido,
    this.clienteId,
    this.negocioId,
    this.dataPedido,
    this.dataConfirmacion,
    this.dataEntrega,
    this.dataCancelacion,
    this.estado,
    this.total,
    this.detalles,
  });

  factory PedidoConDetallesDto.fromJson(Map<String, dynamic> json) {
    // Debug: print del JSON para diagnosticar
    print('PedidoConDetallesDto.fromJson: $json');
    
    return PedidoConDetallesDto(
      idPedido: _parseIntValue(json['idPedido'] ?? json['id']),
      clienteId: _parseIntValue(json['clienteId'] ?? json['cliente_id']),
      negocioId: _parseIntValue(json['negocioId'] ?? json['negocio_id']),
      dataPedido: _parseDateTimeValue(json['dataPedido'] ?? json['data_pedido']),
      dataConfirmacion: _parseDateTimeValue(json['dataConfirmacion'] ?? json['data_confirmacion']),
      dataEntrega: _parseDateTimeValue(json['dataEntrega'] ?? json['data_entrega']),
      dataCancelacion: _parseDateTimeValue(json['dataCancelacion'] ?? json['data_cancelacion']),
      estado: (json['estado'] ?? json['estado'])?.toString(),
      total: _parseDoubleValue(json['total']),
      detalles: (json['detalles'] as List<dynamic>?)
          ?.map((e) => DetallePedidoConProductoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Parsea un valor a int, maneja int, String, double, null
  static int? _parseIntValue(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Parsea un valor a double, maneja int, String, double, null
  static double? _parseDoubleValue(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Parsea un valor a DateTime
  static DateTime? _parseDateTimeValue(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
        if (idPedido != null) 'idPedido': idPedido,
        if (clienteId != null) 'clienteId': clienteId,
        if (negocioId != null) 'negocioId': negocioId,
        if (dataPedido != null) 'dataPedido': dataPedido!.toIso8601String(),
        if (dataConfirmacion != null) 'dataConfirmacion': dataConfirmacion!.toIso8601String(),
        if (dataEntrega != null) 'dataEntrega': dataEntrega!.toIso8601String(),
        if (dataCancelacion != null) 'dataCancelacion': dataCancelacion!.toIso8601String(),
        if (estado != null) 'estado': estado,
        if (total != null) 'total': total,
        if (detalles != null) 'detalles': detalles!.map((d) => d.toJson()).toList(),
      };
}
