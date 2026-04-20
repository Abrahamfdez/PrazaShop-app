class ValoracionEstadisticasDto {
  final int? negocioId;
  final int? cantidadValoraciones;
  final double? mediaPuntuacion;

  ValoracionEstadisticasDto({
    this.negocioId,
    this.cantidadValoraciones,
    this.mediaPuntuacion,
  });

  factory ValoracionEstadisticasDto.fromJson(Map<String, dynamic> json) =>
      ValoracionEstadisticasDto(
        negocioId: json['negocioId'] is int
            ? json['negocioId']
            : (json['negocioId'] != null
                ? int.tryParse('${json['negocioId']}')
                : null),
        cantidadValoraciones: json['cantidadValoraciones'] is int
            ? json['cantidadValoraciones']
            : (json['cantidadValoraciones'] != null
                ? int.tryParse('${json['cantidadValoraciones']}')
                : null),
        mediaPuntuacion: json['mediaPuntuacion'] is double
            ? json['mediaPuntuacion']
            : (json['mediaPuntuacion'] != null
                ? double.tryParse('${json['mediaPuntuacion']}')
                : null),
      );

  Map<String, dynamic> toJson() => {
        if (negocioId != null) 'negocioId': negocioId,
        if (cantidadValoraciones != null)
          'cantidadValoraciones': cantidadValoraciones,
        if (mediaPuntuacion != null) 'mediaPuntuacion': mediaPuntuacion,
      };
}
