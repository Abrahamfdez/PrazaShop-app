class NegocioDto {
  final int? id;
  final int? usuarioId;
  final String? nomeNegocio;
  final String? direccion;
  final String? descricion;

  NegocioDto({this.id, this.usuarioId, this.nomeNegocio, this.direccion, this.descricion});

  factory NegocioDto.fromJson(Map<String, dynamic> json) => NegocioDto(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        usuarioId: json['usuarioId'] is int ? json['usuarioId'] : (json['usuarioId'] != null ? int.tryParse('${json['usuarioId']}') : null),
        nomeNegocio: json['nomeNegocio'],
        direccion: json['direccion'],
        descricion: json['descricion'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (usuarioId != null) 'usuarioId': usuarioId,
        if (nomeNegocio != null) 'nomeNegocio': nomeNegocio,
        if (direccion != null) 'direccion': direccion,
        if (descricion != null) 'descricion': descricion,
      };
}
