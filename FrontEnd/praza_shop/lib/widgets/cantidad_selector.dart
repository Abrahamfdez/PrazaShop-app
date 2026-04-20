import 'package:flutter/material.dart';

/// Widget para seleccionar cantidad con botones + y -
class CantidadSelector extends StatelessWidget {
  final int cantidad;
  final VoidCallback onIncrementar;
  final VoidCallback onDecrementar;
  final bool puedeIncrementar;

  const CantidadSelector({
    super.key,
    required this.cantidad,
    required this.onIncrementar,
    required this.onDecrementar,
    this.puedeIncrementar = true,
  });

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF10A75A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cantidad',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón menos
              GestureDetector(
                onTap: onDecrementar,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Icon(Icons.remove, size: 18),
                  ),
                ),
              ),
              // Cantidad
              Text(
                cantidad.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Botón más
              GestureDetector(
                onTap: puedeIncrementar ? onIncrementar : null,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: puedeIncrementar ? green : Colors.grey[300],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
