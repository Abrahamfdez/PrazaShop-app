class PedidoDto {
  final int? id;
  final int? clienteId;
  final int? negocioId;
  final DateTime? dataPedido;
  final DateTime? dataConfirmacion;
  final DateTime? dataEntrega;
  final DateTime? dataCancelacion;
  final String? estado;
  final double? total;

  PedidoDto({this.id, this.clienteId, this.negocioId, this.dataPedido, this.dataConfirmacion, this.dataEntrega, this.dataCancelacion, this.estado, this.total});

  factory PedidoDto.fromJson(Map<String, dynamic> json) => PedidoDto(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        clienteId: json['clienteId'] is int ? json['clienteId'] : (json['clienteId'] != null ? int.tryParse('${json['clienteId']}') : null),
        negocioId: json['negocioId'] is int ? json['negocioId'] : (json['negocioId'] != null ? int.tryParse('${json['negocioId']}') : null),
        dataPedido: json['dataPedido'] != null ? DateTime.tryParse(json['dataPedido'].toString()) : null,
        dataConfirmacion: json['dataConfirmacion'] != null ? DateTime.tryParse(json['dataConfirmacion'].toString()) : null,
        dataEntrega: json['dataEntrega'] != null ? DateTime.tryParse(json['dataEntrega'].toString()) : null,
        dataCancelacion: json['dataCancelacion'] != null ? DateTime.tryParse(json['dataCancelacion'].toString()) : null,
        estado: json['estado'],
        total: json['total'] is double ? json['total'] : (json['total'] != null ? double.tryParse('${json['total']}') : null),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (clienteId != null) 'clienteId': clienteId,
        if (negocioId != null) 'negocioId': negocioId,
        if (dataPedido != null) 'dataPedido': dataPedido!.toIso8601String(),
        if (dataConfirmacion != null) 'dataConfirmacion': dataConfirmacion!.toIso8601String(),
        if (dataEntrega != null) 'dataEntrega': dataEntrega!.toIso8601String(),
        if (dataCancelacion != null) 'dataCancelacion': dataCancelacion!.toIso8601String(),
        if (estado != null) 'estado': estado,
        if (total != null) 'total': total,
      };
}
