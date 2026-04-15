class CompraRecorrenteDto {
  final int? id;
  final int? clienteId;
  final int? productoId;
  final int? cantidade;
  final String? frecuencia;
  final DateTime? dataInicio;
  final String? estado;

  CompraRecorrenteDto({this.id, this.clienteId, this.productoId, this.cantidade, this.frecuencia, this.dataInicio, this.estado});

  factory CompraRecorrenteDto.fromJson(Map<String, dynamic> json) => CompraRecorrenteDto(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        clienteId: json['clienteId'] is int ? json['clienteId'] : (json['clienteId'] != null ? int.tryParse('${json['clienteId']}') : null),
        productoId: json['productoId'] is int ? json['productoId'] : (json['productoId'] != null ? int.tryParse('${json['productoId']}') : null),
        cantidade: json['cantidade'] is int ? json['cantidade'] : (json['cantidade'] != null ? int.tryParse('${json['cantidade']}') : null),
        frecuencia: json['frecuencia'],
        dataInicio: json['dataInicio'] != null ? DateTime.tryParse(json['dataInicio'].toString()) : null,
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (clienteId != null) 'clienteId': clienteId,
        if (productoId != null) 'productoId': productoId,
        if (cantidade != null) 'cantidade': cantidade,
        if (frecuencia != null) 'frecuencia': frecuencia,
        if (dataInicio != null) 'dataInicio': dataInicio!.toIso8601String(),
        if (estado != null) 'estado': estado,
      };
}
