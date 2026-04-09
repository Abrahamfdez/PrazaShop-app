class Valoracion {
  final int? id;
  final int? productoId;
  final int? usuarioId;
  final int puntuacion; 
  final String? comentario;
  final String? fecha;

  Valoracion({this.id, this.productoId, this.usuarioId, required this.puntuacion, this.comentario, this.fecha});

  factory Valoracion.fromJson(Map<String, dynamic> json) => Valoracion(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        productoId: json['productoId'] is int ? json['productoId'] : (json['productoId'] != null ? int.tryParse('${json['productoId']}') : null),
        usuarioId: json['usuarioId'] is int ? json['usuarioId'] : (json['usuarioId'] != null ? int.tryParse('${json['usuarioId']}') : null),
        puntuacion: json['puntuacion'] is int ? json['puntuacion'] : int.tryParse('${json['puntuacion']}') ?? 0,
        comentario: json['comentario'],
        fecha: json['fecha'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (productoId != null) 'productoId': productoId,
        if (usuarioId != null) 'usuarioId': usuarioId,
        'puntuacion': puntuacion,
        if (comentario != null) 'comentario': comentario,
        if (fecha != null) 'fecha': fecha,
      };
}
