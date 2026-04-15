class ProductoDto {
  final int? id;
  final int? negocioId;
  final String? nome;
  final String? descricion;
  final double? prezo;
  final int? stock;
  final String? categoria;
  final String? duracionOferta;
  final String? imaxe;
  final String? estado;

  ProductoDto({this.id, this.negocioId, this.nome, this.descricion, this.prezo, this.stock, this.categoria, this.duracionOferta, this.imaxe, this.estado});

  factory ProductoDto.fromJson(Map<String, dynamic> json) => ProductoDto(
        id: json['id'] is int ? json['id'] : (json['id'] != null ? int.tryParse('${json['id']}') : null),
        negocioId: json['negocioId'] is int ? json['negocioId'] : (json['negocioId'] != null ? int.tryParse('${json['negocioId']}') : null),
        nome: json['nome'],
        descricion: json['descricion'],
        prezo: json['prezo'] is double ? json['prezo'] : (json['prezo'] != null ? double.tryParse('${json['prezo']}') : null),
        stock: json['stock'] is int ? json['stock'] : (json['stock'] != null ? int.tryParse('${json['stock']}') : null),
        categoria: json['categoria'],
        duracionOferta: json['duracionOferta'],
        imaxe: json['imaxe'],
        estado: json['estado'],
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (negocioId != null) 'negocioId': negocioId,
        if (nome != null) 'nome': nome,
        if (descricion != null) 'descricion': descricion,
        if (prezo != null) 'prezo': prezo,
        if (stock != null) 'stock': stock,
        if (categoria != null) 'categoria': categoria,
        if (duracionOferta != null) 'duracionOferta': duracionOferta,
        if (imaxe != null) 'imaxe': imaxe,
        if (estado != null) 'estado': estado,
      };
}
