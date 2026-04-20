import 'package:flutter/material.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/models/negocio_dto.dart';

/// Widget que muestra un producto en el carrito
class ProductoCarritoCard extends StatelessWidget {
  final ProductoDto producto;
  final NegocioDto? negocio;

  const ProductoCarritoCard({
    super.key,
    required this.producto,
    this.negocio,
  });

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF10A75A);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Imagen
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: producto.imaxe != null && producto.imaxe!.isNotEmpty
                ? Image.network(
                    producto.imaxe!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.image_not_supported),
                      );
                    },
                  )
                : const Center(
                    child: Icon(Icons.image_not_supported),
                  ),
          ),
          const SizedBox(width: 12),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nome ?? 'Sin nombre',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                if (negocio != null)
                  Text(
                    negocio!.nomeNegocio ?? 'Tienda',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  '${producto.prezo?.toStringAsFixed(2) ?? '0.00'}€/unidade',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
