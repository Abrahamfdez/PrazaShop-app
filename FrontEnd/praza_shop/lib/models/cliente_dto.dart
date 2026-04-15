class ClienteDto {
  final int? id;
  final int? usuarioId;
  final String? direccionEnvio;

  ClienteDto({this.id, this.usuarioId, this.direccionEnvio});

  factory ClienteDto.fromJson(Map<String, dynamic> json) => ClienteDto(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        usuarioId: json['usuarioId'] is int ? json['usuarioId'] : (json['usuarioId'] != null ? int.tryParse('${json['usuarioId']}') : null),
        direccionEnvio: json['direccionEnvio'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (usuarioId != null) 'usuarioId': usuarioId,
        if (direccionEnvio != null) 'direccionEnvio': direccionEnvio,
      };
}
