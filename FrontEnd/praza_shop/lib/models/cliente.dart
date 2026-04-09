class Cliente {
  final int? id;
  final String nome;
  final String? email;
  final String? telefono;
  final String? direccion;

  Cliente({this.id, required this.nome, this.email, this.telefono, this.direccion});

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        nome: json['nome'] ?? json['name'] ?? '',
        email: json['email'],
        telefono: json['telefono'],
        direccion: json['direccion'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nome': nome,
        if (email != null) 'email': email,
        if (telefono != null) 'telefono': telefono,
        if (direccion != null) 'direccion': direccion,
      };
}
