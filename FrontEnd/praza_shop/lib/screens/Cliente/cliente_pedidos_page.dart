import 'package:flutter/material.dart';
import 'package:praza_shop/models/pedido_dto.dart';
import 'package:praza_shop/models/usuario_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/cliente_service.dart';
import 'package:praza_shop/services/pedido_service.dart';

/// Página que muestra el historial de pedidos realizados por un cliente
class ClientePedidosPage extends StatefulWidget {
  final ApiService api;
  final UsuarioDto usuario;

  const ClientePedidosPage({
    super.key,
    required this.api,
    required this.usuario,
  });

  @override
  State<ClientePedidosPage> createState() => _ClientePedidosPageState();
}

class _ClientePedidosPageState extends State<ClientePedidosPage> {
  late Future<List<PedidoDto>> _pedidosFuture;
  late PedidoService _pedidoService;

  @override
  void initState() {
    super.initState();
    _pedidoService = PedidoService(widget.api);
    _pedidosFuture = _cargarPedidos();
  }

  /// Carga los pedidos del cliente desde la API
  Future<List<PedidoDto>> _cargarPedidos() async {
    try {
      var cliente=await ClienteService(widget.api).getByUsuarioId(widget.usuario.id!);
      final allPedidos = await _pedidoService.getAll();
      // Filtrar pedidos del cliente actual
      return allPedidos
          .where((pedido) => pedido.clienteId == cliente.id)
          .toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ao cargar pedidos: $e')),
      );
      return [];
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF10A75A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mis Pedidos',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<PedidoDto>>(
        future: _pedidosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pedidosFuture = _cargarPedidos();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final pedidos = snapshot.data ?? [];

          if (pedidos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aín non tes pedidos',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Os teus pedidos aparecerán aquí',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
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
                                  'Pedido #${pedido.id}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Negocio ID: ${pedido.negocioId}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
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
            },
          );
        },
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
