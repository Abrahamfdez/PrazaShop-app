class DetallePedido {
  final int? id;
  final int? pedidoId;
  final int? productoId;
  final int cantidad;
  final double? precio;

  DetallePedido({this.id, this.pedidoId, this.productoId, required this.cantidad, this.precio});

  factory DetallePedido.fromJson(Map<String, dynamic> json) => DetallePedido(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        pedidoId: json['pedidoId'] is int ? json['pedidoId'] : (json['pedidoId'] != null ? int.tryParse('${json['pedidoId']}') : null),
        productoId: json['productoId'] is int ? json['productoId'] : (json['productoId'] != null ? int.tryParse('${json['productoId']}') : null),
        cantidad: json['cantidad'] is int ? json['cantidad'] : int.tryParse('${json['cantidad']}') ?? 1,
        precio: json['precio'] != null ? double.tryParse('${json['precio']}') : null,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (pedidoId != null) 'pedidoId': pedidoId,
        if (productoId != null) 'productoId': productoId,
        'cantidad': cantidad,
        if (precio != null) 'precio': precio,
      };
}
