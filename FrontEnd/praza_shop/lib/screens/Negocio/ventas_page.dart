import 'package:flutter/material.dart';
import 'package:praza_shop/models/pedido_con_detalles_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/negocio_service.dart';
import 'package:praza_shop/services/pedido_service.dart';
import 'package:praza_shop/utils/api_utils.dart';

/// Página para ver todas las ventas (pedidos) del negocio con detalles
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

  List<PedidoConDetallesDto> _pedidos = [];
  bool _isLoading = true;
  String _filtroEstado = 'TODOS';
  int _paginaActual = 0;
  final int _tamanioPagina = 20;

  final List<String> _estadosDisponibles = ['TODOS', 'PENDIENTE', 'CONFIRMADO', 'ENTREGADO', 'CANCELADO'];

  @override
  void initState() {
    super.initState();
    _negocioService = NegocioService(widget.api);
    _pedidoService = PedidoService(widget.api);
    _cargarPedidos();
  }

  /// Carga los pedidos del negocio usando buscarPedidos con paginación
  Future<void> _cargarPedidos() async {
    try {
      setState(() => _isLoading = true);

      final usuario = await ApiUtils.getUserFromToken(widget.api, widget.api.token);
      final negocio = await _negocioService.getByUsuarioId(usuario.id!);

      // Usar buscarPedidos para obtener pedidos con detalles y paginación
      final resultado = await _pedidoService.buscarPedidos(
        estado: _filtroEstado == 'TODOS' ? null : _filtroEstado,
        ordenar: 'fecha_desc',
        pagina: _paginaActual,
        tamano: _tamanioPagina,
      );

      print('VENTAS_PAGE: Resultado completo = $resultado');
      
      final content = resultado['content'] as List<dynamic>? ?? [];
      print('VENTAS_PAGE: Content length = ${content.length}');
      if (content.isNotEmpty) {
        print('VENTAS_PAGE: First item = ${content.first}');
      }
      
      final pedidos = content
          .map((p) {
            print('VENTAS_PAGE: Parseando pedido: $p');
            return PedidoConDetallesDto.fromJson(p as Map<String, dynamic>);
          })
          .toList();
      
      print('VENTAS_PAGE: Pedidos parseados = ${pedidos.map((p) => 'ID: ${p.idPedido}, Estado: ${p.estado}').toList()}');

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

  /// Obtiene el color según el estado del pedido
  Color _obtenerColorEstado(String? estado) {
    switch (estado?.toUpperCase()) {
      case 'PENDIENTE':
        return Colors.orange;
      case 'CONFIRMADO':
        return Colors.green;
      case 'ENTREGADO':
        return Colors.blue;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Actualiza el estado de un pedido
  Future<void> _actualizarEstadoPedido(PedidoConDetallesDto pedido, String nuevoEstado) async {
    try {
      // Actualizar en backend
      await _pedidoService.update(pedido.idPedido!.toInt(), _crearPedidoDtoActualizado(pedido, nuevoEstado));

      // Recargar pedidos
      await _cargarPedidos();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estado actualizado a: $nuevoEstado'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Crea un PedidoDto con estado actualizado para enviar al backend
  dynamic _crearPedidoDtoActualizado(PedidoConDetallesDto pedido, String nuevoEstado) {
    return {
      'id': pedido.idPedido,
      'clienteId': pedido.clienteId,
      'negocioId': pedido.negocioId,
      'dataPedido': pedido.dataPedido?.toIso8601String(),
      'estado': nuevoEstado,
      'total': pedido.total,
    };
  }

  /// Muestra diálogo para cambiar estado
  void _mostrarDialogoEstado(PedidoConDetallesDto pedido) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cambiar estado del pedido #${pedido.idPedido}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Estado actual: ${pedido.estado}'),
              const SizedBox(height: 20),
              const Text('Selecciona el nuevo estado:'),
              const SizedBox(height: 16),
              ..._estadosDisponibles.where((e) => e != 'TODOS').map((estado) {
                final esEstadoActual = estado == pedido.estado?.toUpperCase();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: esEstadoActual ? _obtenerColorEstado(estado) : Colors.grey[300],
                        foregroundColor: esEstadoActual ? Colors.white : Colors.black,
                      ),
                      onPressed: !esEstadoActual
                          ? () {
                              Navigator.of(context).pop();
                              _actualizarEstadoPedido(pedido, estado);
                            }
                          : null,
                      child: Text(estado),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
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
      body: Column(
        children: [
          // Filtro de estados
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _estadosDisponibles.map((estado) {
                  final isSelected = _filtroEstado == estado;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(estado),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _filtroEstado = estado;
                          _paginaActual = 0;
                        });
                        _cargarPedidos();
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: green,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Lista de pedidos
          Expanded(
            child: _isLoading
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
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Pedido #${pedido.idPedido}',
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
                                      color: _obtenerColorEstado(estado),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      estado,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Total: ${total.toStringAsFixed(2)}€',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: green,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildInfoRow('Fecha', '${fecha.day}/${fecha.month}/${fecha.year}'),
                                      _buildInfoRow('Cliente ID', '${pedido.clienteId}'),
                                      _buildInfoRow('Estado', pedido.estado ?? 'N/A'),
                                      const SizedBox(height: 12),
                                      // Detalles del pedido
                                      if (pedido.detalles != null && pedido.detalles!.isNotEmpty) ...[
                                        const Text(
                                          'Detalles:',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...pedido.detalles!.map((detalle) {
                                          final subtotal = detalle.subtotal ?? 0.0;
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[50],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          detalle.nombreProducto ?? 'Producto',
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        Text(
                                                          'Cant: ${detalle.cantidade} × ${detalle.prezoUnitario?.toStringAsFixed(2)}€',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    '${subtotal.toStringAsFixed(2)}€',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _mostrarDialogoEstado(pedido),
                                          icon: const Icon(Icons.edit, size: 16),
                                          label: const Text('Cambiar estado'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  /// Widget auxiliar para mostrar información en filas
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
