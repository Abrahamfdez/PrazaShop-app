class Usuario {
  final int? id;
  final String nome;
  final String? email;
  final String? telefono;
  final String? tipoUsuario;

  Usuario({this.id, required this.nome, this.email, this.telefono, this.tipoUsuario});

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        nome: json['nome'] ?? json['name'] ?? '',
        email: json['email'],
        telefono: json['telefono'],
        tipoUsuario: json['tipoUsuario'] ?? json['role'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nome': nome,
        if (email != null) 'email': email,
        if (telefono != null) 'telefono': telefono,
        if (tipoUsuario != null) 'tipoUsuario': tipoUsuario,
      };
}
