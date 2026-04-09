class Product {
  final int? id;
  final int? negocioId;
  final String nome;
  final String? descricion;
  final double? prezo;
  final int? stock;
  final String? categoria;
  final String? duracionOferta;
  final String? imaxe;
  final String? estado;

  Product({
    this.id,
    this.negocioId,
    required this.nome,
    this.descricion,
    this.prezo,
    this.stock,
    this.categoria,
    this.duracionOferta,
    this.imaxe,
    this.estado,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.parse('${json['id']}') : null),
      negocioId: json['negocioId'] is int ? json['negocioId'] : (json['negocioId'] != null ? int.parse('${json['negocioId']}') : null),
      nome: json['nome'] ?? json['name'] ?? '',
      descricion: json['descricion'],
      prezo: json['prezo'] != null ? double.tryParse('${json['prezo']}') : null,
      stock: json['stock'] is int ? json['stock'] : (json['stock'] != null ? int.parse('${json['stock']}') : null),
      categoria: json['categoria'],
      duracionOferta: json['duracionOferta'],
      imaxe: json['imaxe'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (negocioId != null) 'negocioId': negocioId,
      'nome': nome,
      if (descricion != null) 'descricion': descricion,
      if (prezo != null) 'prezo': prezo,
      if (stock != null) 'stock': stock,
      if (categoria != null) 'categoria': categoria,
      if (duracionOferta != null) 'duracionOferta': duracionOferta,
      if (imaxe != null) 'imaxe': imaxe,
      if (estado != null) 'estado': estado,
    };
  }
}
