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
    return PedidoConDetallesDto(
      idPedido: json['idPedido'] is int
          ? json['idPedido']
          : (json['idPedido'] != null ? int.tryParse('${json['idPedido']}') : null),
      clienteId: json['clienteId'] is int
          ? json['clienteId']
          : (json['clienteId'] != null ? int.tryParse('${json['clienteId']}') : null),
      negocioId: json['negocioId'] is int
          ? json['negocioId']
          : (json['negocioId'] != null ? int.tryParse('${json['negocioId']}') : null),
      dataPedido: json['dataPedido'] != null ? DateTime.tryParse(json['dataPedido'].toString()) : null,
      dataConfirmacion: json['dataConfirmacion'] != null ? DateTime.tryParse(json['dataConfirmacion'].toString()) : null,
      dataEntrega: json['dataEntrega'] != null ? DateTime.tryParse(json['dataEntrega'].toString()) : null,
      dataCancelacion: json['dataCancelacion'] != null ? DateTime.tryParse(json['dataCancelacion'].toString()) : null,
      estado: json['estado'],
      total: json['total'] is double
          ? json['total']
          : (json['total'] != null ? double.tryParse('${json['total']}') : null),
      detalles: (json['detalles'] as List<dynamic>?)
          ?.map((e) => DetallePedidoConProductoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
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
