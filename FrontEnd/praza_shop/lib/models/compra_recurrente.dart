class CompraRecurrente {
  final int? id;
  final int? clienteId;
  final int? productoId;
  final String? frecuencia; // e.g., 'semanal', 'mensual'
  final String? nextDate; // ISO string
  final String? estado;

  CompraRecurrente({this.id, this.clienteId, this.productoId, this.frecuencia, this.nextDate, this.estado});

  factory CompraRecurrente.fromJson(Map<String, dynamic> json) => CompraRecurrente(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        clienteId: json['clienteId'] is int ? json['clienteId'] : (json['clienteId'] != null ? int.tryParse('${json['clienteId']}') : null),
        productoId: json['productoId'] is int ? json['productoId'] : (json['productoId'] != null ? int.tryParse('${json['productoId']}') : null),
        frecuencia: json['frecuencia'],
        nextDate: json['nextDate'],
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (clienteId != null) 'clienteId': clienteId,
        if (productoId != null) 'productoId': productoId,
        if (frecuencia != null) 'frecuencia': frecuencia,
        if (nextDate != null) 'nextDate': nextDate,
        if (estado != null) 'estado': estado,
      };
}
