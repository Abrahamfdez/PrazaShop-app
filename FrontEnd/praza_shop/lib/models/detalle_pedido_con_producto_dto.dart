class DetallePedidoConProductoDto {
  final int? idDetalle;
  final int? pedidoId;
  final int? productoId;
  final String? nombreProducto;
  final int? cantidade;
  final double? prezoUnitario;
  final double? subtotal;

  DetallePedidoConProductoDto({
    this.idDetalle,
    this.pedidoId,
    this.productoId,
    this.nombreProducto,
    this.cantidade,
    this.prezoUnitario,
    this.subtotal,
  });

  factory DetallePedidoConProductoDto.fromJson(Map<String, dynamic> json) {
    return DetallePedidoConProductoDto(
      idDetalle: json['idDetalle'] is int
          ? json['idDetalle']
          : (json['idDetalle'] != null ? int.tryParse('${json['idDetalle']}') : null),
      pedidoId: json['pedidoId'] is int
          ? json['pedidoId']
          : (json['pedidoId'] != null ? int.tryParse('${json['pedidoId']}') : null),
      productoId: json['productoId'] is int
          ? json['productoId']
          : (json['productoId'] != null ? int.tryParse('${json['productoId']}') : null),
      nombreProducto: json['nombreProducto'],
      cantidade: json['cantidade'] is int
          ? json['cantidade']
          : (json['cantidade'] != null ? int.tryParse('${json['cantidade']}') : null),
      prezoUnitario: json['prezoUnitario'] is double
          ? json['prezoUnitario']
          : (json['prezoUnitario'] != null ? double.tryParse('${json['prezoUnitario']}') : null),
      subtotal: json['subtotal'] is double
          ? json['subtotal']
          : (json['subtotal'] != null ? double.tryParse('${json['subtotal']}') : null),
    );
  }

  Map<String, dynamic> toJson() => {
        if (idDetalle != null) 'idDetalle': idDetalle,
        if (pedidoId != null) 'pedidoId': pedidoId,
        if (productoId != null) 'productoId': productoId,
        if (nombreProducto != null) 'nombreProducto': nombreProducto,
        if (cantidade != null) 'cantidade': cantidade,
        if (prezoUnitario != null) 'prezoUnitario': prezoUnitario,
        if (subtotal != null) 'subtotal': subtotal,
      };
}
