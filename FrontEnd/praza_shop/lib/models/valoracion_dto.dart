class ValoracionDto {
  final int? id;
  final int? clienteId;
  final int? negocioId;
  final int? puntuacion;
  final String? comentario;
  final DateTime? dataValoracion;

  ValoracionDto({this.id, this.clienteId, this.negocioId, this.puntuacion, this.comentario, this.dataValoracion});

  factory ValoracionDto.fromJson(Map<String, dynamic> json) => ValoracionDto(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        clienteId: json['clienteId'] is int ? json['clienteId'] : (json['clienteId'] != null ? int.tryParse('${json['clienteId']}') : null),
        negocioId: json['negocioId'] is int ? json['negocioId'] : (json['negocioId'] != null ? int.tryParse('${json['negocioId']}') : null),
        puntuacion: json['puntuacion'] is int ? json['puntuacion'] : (json['puntuacion'] != null ? int.tryParse('${json['puntuacion']}') : null),
        comentario: json['comentario'],
        dataValoracion: json['dataValoracion'] != null ? DateTime.tryParse(json['dataValoracion'].toString()) : null,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (clienteId != null) 'clienteId': clienteId,
        if (negocioId != null) 'negocioId': negocioId,
        if (puntuacion != null) 'puntuacion': puntuacion,
        if (comentario != null) 'comentario': comentario,
        if (dataValoracion != null) 'dataValoracion': dataValoracion!.toIso8601String(),
      };
}
