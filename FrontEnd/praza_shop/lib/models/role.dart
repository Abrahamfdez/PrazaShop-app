/// Enumeración de roles de usuario usada en los modelos y servicios.
enum Role { CLIENTE, NEGOCIO, ADMIN,DESCONOCIDO }

extension RoleExt on Role {
  String get nameValue {
    switch (this) {
      case Role.CLIENTE:
        return 'CLIENTE';
      case Role.NEGOCIO:
        return 'NEGOCIO';
      case Role.ADMIN:
        return 'ADMIN';
      case Role.DESCONOCIDO:
        return 'DESCONOCIDO';
    }
  }

  static Role? fromString(String? s) {
    if (s == null) return null;
    final v = s.toUpperCase();
    if (v == 'CLIENTE') return Role.CLIENTE;
    if (v == 'NEGOCIO') return Role.NEGOCIO;
    if (v == 'ADMIN') return Role.ADMIN;
    return null;
  }
}
