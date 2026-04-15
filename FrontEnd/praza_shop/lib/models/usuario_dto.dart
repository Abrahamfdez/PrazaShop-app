class UsuarioDto {
  final int? id;
  final String? nome;
  final String? email;
  final String? contrasinal;
  final String? telefono;
  final String? tipoUsuario;

  UsuarioDto({this.id, this.nome, this.email, this.contrasinal, this.telefono, this.tipoUsuario});

  factory UsuarioDto.fromJson(Map<String, dynamic> json) => UsuarioDto(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        nome: json['nome'],
        email: json['email'],
        contrasinal: json['contrasinal'],
        telefono: json['telefono'],
        tipoUsuario: json['tipoUsuario']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (nome != null) 'nome': nome,
        if (email != null) 'email': email,
        if (contrasinal != null) 'contrasinal': contrasinal,
        if (telefono != null) 'telefono': telefono,
        if (tipoUsuario != null) 'tipoUsuario': tipoUsuario,
      };
}
