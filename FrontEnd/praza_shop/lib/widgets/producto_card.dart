import 'package:flutter/material.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/services/negocio_service.dart';
import 'package:praza_shop/screens/producto_detail_page.dart';
import 'package:praza_shop/services/api_service.dart';

/// Widget que construye una tarjeta de producto con imagen, nombre, negocio, precio y botón de compra
class ProductoCard extends StatelessWidget {
  final ProductoDto producto;
  final Color green;
  final NegocioService negocioService;
  final Map<int, dynamic> negociosCache;
  final ApiService api;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.green,
    required this.negocioService,
    required this.negociosCache,
    required this.api,
  });

  /// Obtiene el nombre del negocio por su ID, con caché
  Future<String> _obtenerNombreNegocio(int? negocioId) async {
    if (negocioId == null) return 'Desconocido';
    
    // Si ya está en caché, retornarlo
    if (negociosCache.containsKey(negocioId)) {
      return negociosCache[negocioId]?.nomeNegocio ?? 'Desconocido';
    }
    
    try {
      final negocio = await negocioService.getById(negocioId);
      negociosCache[negocioId] = negocio;
      return negocio.nomeNegocio ?? 'Desconocido';
    } catch (e) {
      print('Error al cargar negocio: $e');
      return 'Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página de detalles del producto
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductoDetailPage(
              producto: producto,
              api: api,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey[200],
              ),
              child: producto.imaxe != null && producto.imaxe!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(
                        producto.imaxe!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image_not_supported, size: 40),
                    ),
            ),

            // Detalles del producto
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del producto
                    Text(
                      producto.nome ?? 'Sin nombre',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Nombre del negocio
                    FutureBuilder<String>(
                      future: _obtenerNombreNegocio(producto.negocioId),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data ?? 'Cargando...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                      
                    const Spacer(),
                    

                    // Precio y botón añadir al carrito
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Precio
                        Text(
                          '${producto.prezo?.toStringAsFixed(2) ?? '0.00'}€',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: green,
                          ),
                        ),

                        // Botón añadir al carrito
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${producto.nome} añadido al carrito',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
