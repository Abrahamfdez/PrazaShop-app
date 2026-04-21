import 'package:flutter/material.dart';
import 'package:praza_shop/models/pedido_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/negocio_service.dart';
import 'package:praza_shop/services/pedido_service.dart';
import 'package:praza_shop/utils/api_utils.dart';

/// Página para ver todas las ventas (pedidos) del negocio
class VentasPage extends StatefulWidget {
  final ApiService api;

  const VentasPage({
    super.key,
    required this.api,
  });

  @override
  State<VentasPage> createState() => _VentasPageState();
}

class _VentasPageState extends State<VentasPage> {
  late NegocioService _negocioService;
  late PedidoService _pedidoService;

  List<PedidoDto> _pedidos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _negocioService = NegocioService(widget.api);
    _pedidoService = PedidoService(widget.api);
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    try {
      // Obtener usuario actual
      final usuario = await ApiUtils.getUserFromToken(widget.api, widget.api.token);

      // Obtener negocio del usuario
      final negocio = await _negocioService.getByUsuarioId(usuario.id!);

      // Obtener pedidos del negocio
      final pedidos = await _pedidoService.findByNegocioId(negocio.id!);

      if (!mounted) return;
      setState(() {
        _pedidos = pedidos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar pedidos: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String _getEstadoColor(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'pendiente':
        return '#FFA500'; // Naranja
      case 'confirmado':
        return '#4CAF50'; // Verde
      case 'entregado':
        return '#2196F3'; // Azul
      case 'cancelado':
        return '#F44336'; // Rojo
      default:
        return '#757575'; // Gris
    }
  }

  Color _getEstadoButtonColor(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'confirmado':
        return Colors.green;
      case 'entregado':
        return Colors.blue;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Vendas',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Non hai vendas aínda',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = _pedidos[index];
                    final estado = pedido.estado ?? 'Desconocido';
                    final total = pedido.total ?? 0.0;
                    final fecha = pedido.dataPedido ?? DateTime.now();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header con ID y estado
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pedido #${pedido.id}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getEstadoButtonColor(estado),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  estado,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getEstadoButtonColor(estado),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Fecha
                          Text(
                            'Data: ${fecha.day}/${fecha.month}/${fecha.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Cliente ID
                          Text(
                            'Cliente ID: ${pedido.clienteId ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${total.toStringAsFixed(2)}€',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
