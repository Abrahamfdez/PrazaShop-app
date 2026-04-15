class DetallePedidoDto {
  final int? id;
  final int? pedidoId;
  final int? productoId;
  final int? cantidade;
  final double? prezoUnitario;

  DetallePedidoDto({this.id, this.pedidoId, this.productoId, this.cantidade, this.prezoUnitario});

  factory DetallePedidoDto.fromJson(Map<String, dynamic> json) => DetallePedidoDto(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        pedidoId: json['pedidoId'] is int ? json['pedidoId'] : (json['pedidoId'] != null ? int.tryParse('${json['pedidoId']}') : null),
        productoId: json['productoId'] is int ? json['productoId'] : (json['productoId'] != null ? int.tryParse('${json['productoId']}') : null),
        cantidade: json['cantidade'] is int ? json['cantidade'] : (json['cantidade'] != null ? int.tryParse('${json['cantidade']}') : null),
        prezoUnitario: json['prezoUnitario'] is double ? json['prezoUnitario'] : (json['prezoUnitario'] != null ? double.tryParse('${json['prezoUnitario']}') : null),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (pedidoId != null) 'pedidoId': pedidoId,
        if (productoId != null) 'productoId': productoId,
        if (cantidade != null) 'cantidade': cantidade,
        if (prezoUnitario != null) 'prezoUnitario': prezoUnitario,
      };
}
