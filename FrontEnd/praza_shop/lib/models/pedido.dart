class Pedido {
  final int? id;
  final int? clienteId;
  final double? total;
  final String? fecha; // ISO string
  final String? estado;

  Pedido({this.id, this.clienteId, this.total, this.fecha, this.estado});

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        clienteId: json['clienteId'] is int ? json['clienteId'] : (json['clienteId'] != null ? int.tryParse('${json['clienteId']}') : null),
        total: json['total'] != null ? double.tryParse('${json['total']}') : null,
        fecha: json['fecha'] ?? json['createdAt'],
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (clienteId != null) 'clienteId': clienteId,
        if (total != null) 'total': total,
        if (fecha != null) 'fecha': fecha,
        if (estado != null) 'estado': estado,
      };
}
