class Negocio {
  final int? id;
  final String nome;
  final String? descricion;
  final String? direccion;
  final String? telefono;
  final int? propietarioId;
  final String? estado;

  Negocio({this.id, required this.nome, this.descricion, this.direccion, this.telefono, this.propietarioId, this.estado});

  factory Negocio.fromJson(Map<String, dynamic> json) => Negocio(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        nome: json['nome'] ?? json['name'] ?? '',
        descricion: json['descricion'],
        direccion: json['direccion'],
        telefono: json['telefono'],
        propietarioId: json['propietarioId'] is int ? json['propietarioId'] : (json['propietarioId'] != null ? int.tryParse('${json['propietarioId']}') : null),
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nome': nome,
        if (descricion != null) 'descricion': descricion,
        if (direccion != null) 'direccion': direccion,
        if (telefono != null) 'telefono': telefono,
        if (propietarioId != null) 'propietarioId': propietarioId,
        if (estado != null) 'estado': estado,
      };
}
