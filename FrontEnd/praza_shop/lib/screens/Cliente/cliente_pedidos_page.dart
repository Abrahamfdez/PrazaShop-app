import 'package:flutter/material.dart';
import 'package:praza_shop/models/pedido_con_detalles_dto.dart';
import 'package:praza_shop/models/usuario_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/cliente_service.dart';
import 'package:praza_shop/services/pedido_service.dart';
import 'package:praza_shop/widgets/pedido_card.dart';

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
  late Future<List<PedidoConDetallesDto>> _pedidosFuture;
  late PedidoService _pedidoService;

  @override
  void initState() {
    super.initState();
    _pedidoService = PedidoService(widget.api);
    _pedidosFuture = _cargarPedidos();
  }

  /// Carga los pedidos del cliente desde la API
  Future<List<PedidoConDetallesDto>> _cargarPedidos() async {
    try {
      var cliente = await ClienteService(widget.api).getByUsuarioId(widget.usuario.id!);
      final pedidos = await _pedidoService.findByClienteIdConDetalles(cliente.id!);
      return pedidos;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ao cargar pedidos: $e')),
      );
      return [];
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
      body: FutureBuilder<List<PedidoConDetallesDto>>(
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
              return PedidoCard(
                pedido: pedido,
                green: green,
                api: widget.api,
              );
            },
          );
        },
      ),
    );
  }
}
