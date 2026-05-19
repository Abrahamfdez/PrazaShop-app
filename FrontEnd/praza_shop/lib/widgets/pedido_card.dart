import 'package:flutter/material.dart';
import 'package:praza_shop/models/pedido_con_detalles_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/negocio_service.dart';

/// Widget que representa una tarjeta de pedido con todos sus detalles
class PedidoCard extends StatelessWidget {
  final PedidoConDetallesDto pedido;
  final Color green;
  final ApiService api;

  const PedidoCard({
    super.key,
    required this.pedido,
    required this.green,
    required this.api,
  });

  /// Retorna el color según el estado del pedido
  Color _getColorEstado(String? estado) {
    switch (estado?.toUpperCase()) {
      case 'PENDIENTE':
        return Colors.orange;
      case 'CONFIRMADO':
        return Colors.blue;
      case 'ENTREGADO':
        return Colors.green;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Retorna un icono según el estado del pedido
  IconData _getIconoEstado(String? estado) {
    switch (estado?.toUpperCase()) {
      case 'PENDIENTE':
        return Icons.schedule;
      case 'CONFIRMADO':
        return Icons.check_circle;
      case 'ENTREGADO':
        return Icons.done_all;
      case 'CANCELADO':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  /// Obtiene el nombre del negocio
  Future<String> _nomeNegocio(int negocioId) async {
    try {
      final negocio = await NegocioService(api).getById(negocioId);
      return negocio.nomeNegocio.toString();
    } catch (e) {
      return 'Negocio descoñecido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = pedido.estado ?? 'DESCONOCIDO';
    final colorEstado = _getColorEstado(estado);
    final iconoEstado = _getIconoEstado(estado);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con ID y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido #${pedido.idPedido}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FutureBuilder<String>(
                        future: _nomeNegocio(pedido.negocioId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text(
                              'Cargando negocio...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          }
                          return Text(
                            'Negocio: ${snapshot.data ?? 'Negocio descoñecido'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorEstado.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorEstado),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          iconoEstado,
                          size: 16,
                          color: colorEstado,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          estado,
                          style: TextStyle(
                            color: colorEstado,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              // Detalles del pedido
              if (pedido.detalles != null && pedido.detalles!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Produtos:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...pedido.detalles!.map((detalle) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detalle.nombreProducto ?? 'Produto sen nome',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Cant: ${detalle.cantidade}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '€${detalle.subtotal?.toStringAsFixed(2) ?? '0.00'}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: green,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 12),
              ],
              // Información de fechas
              _buildFechaInfo(
                'Data do pedido',
                pedido.dataPedido,
                Icons.calendar_today,
                green,
              ),
              if (pedido.dataConfirmacion != null) ...[
                const SizedBox(height: 8),
                _buildFechaInfo(
                  'Data de confirmación',
                  pedido.dataConfirmacion,
                  Icons.check_circle,
                  Colors.blue,
                ),
              ],
              if (pedido.dataEntrega != null) ...[
                const SizedBox(height: 8),
                _buildFechaInfo(
                  'Data de entrega',
                  pedido.dataEntrega,
                  Icons.local_shipping,
                  Colors.green,
                ),
              ],
              if (pedido.dataCancelacion != null) ...[
                const SizedBox(height: 8),
                _buildFechaInfo(
                  'Data de cancelación',
                  pedido.dataCancelacion,
                  Icons.cancel,
                  Colors.red,
                ),
              ],
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              // Total del pedido
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '€${pedido.total?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget auxiliar para mostrar información de fechas
  Widget _buildFechaInfo(
    String label,
    DateTime? fecha,
    IconData icono,
    Color color,
  ) {
    if (fecha == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(icono, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${fecha.day}/${fecha.month}/${fecha.year}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
