import 'package:flutter/material.dart';
import 'package:praza_shop/models/pedido_con_detalles_dto.dart';
import 'package:praza_shop/models/usuario_dto.dart';
import 'package:praza_shop/models/compra_recorrente_dto.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/pedido_service.dart';
import 'package:praza_shop/services/compra_recorrente_service.dart';
import 'package:praza_shop/services/producto_service.dart';
import 'package:praza_shop/widgets/pedido_card.dart';

/// Página de perfil del cliente que muestra pedidos y compras recurrentes
class ClientePerfilPage extends StatefulWidget {
  final ApiService api;
  final UsuarioDto usuario;

  const ClientePerfilPage({
    super.key,
    required this.api,
    required this.usuario,
  });

  @override
  State<ClientePerfilPage> createState() => _ClientePerfilPageState();
}

class _ClientePerfilPageState extends State<ClientePerfilPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PedidoService _pedidoService;
  late CompraRecorrenteService _compraRecorrenteService;
  late ProductoService _productoService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pedidoService = PedidoService(widget.api);
    _compraRecorrenteService = CompraRecorrenteService(widget.api);
    _productoService = ProductoService(widget.api);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Carga los pedidos del cliente usando el endpoint /api/mi-compra/pedidos
  Future<List<PedidoConDetallesDto>> _cargarPedidos() async {
    try {
      final resultado = await _pedidoService.misPedidos(
        pagina: 0,
        tamano: 100,
      );

      final content = resultado['content'] as List<dynamic>? ?? [];
      final pedidos = content
          .map((p) => PedidoConDetallesDto.fromJson(p as Map<String, dynamic>))
          .toList();

      return pedidos;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ao cargar pedidos: $e')),
      );
      return [];
    }
  }

  /// Carga las compras recurrentes del cliente (endpoint user-scoped)
  Future<List<Map<String, dynamic>>> _cargarComprasRecurrentes() async {
    try {
      // Usar el nuevo endpoint user-scoped que auto-resuelve el clienteId
      final compras = await _compraRecorrenteService.misComprasRecurrentes();

      // Enriquecer con información del producto
      final comprasConProducto = <Map<String, dynamic>>[];
      for (final compra in compras) {
        try {
          final producto = await _productoService.getById(compra.productoId ?? 0);
          await Future.delayed(const Duration(milliseconds: 100)); // Pequeña pausa para evitar saturar el backend
          comprasConProducto.add({
            'compra': compra,
            'producto': producto,
          });
        } catch (e) {
          // Si falla obtener el producto, agregar sin él
          comprasConProducto.add({
            'compra': compra,
            'producto': null,
          });
        }
      }

      return comprasConProducto;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ao cargar compras recurrentes: $e')),
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
          'Mi Perfil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Información del usuario
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: green,
                    radius: 30,
                    child: const Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.usuario.nome ?? 'Usuario',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.usuario.email ?? 'sin email',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tabs para Pedidos y Compras Recurrentes
          TabBar(
            controller: _tabController,
            labelColor: green,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: green,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag, size: 20),
                    SizedBox(width: 8),
                    Text('Pedidos'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.repeat, size: 20),
                    SizedBox(width: 8),
                    Text('Recurrentes'),
                  ],
                ),
              ),
            ],
          ),

          // Contenido de los tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Pedidos
                FutureBuilder<List<PedidoConDetallesDto>>(
                  future: _cargarPedidos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text('Error: ${snapshot.error}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
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
                            Icon(Icons.shopping_bag_outlined,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            const Text('Non hai pedidos todavía'),
                            const SizedBox(height: 8),
                            Text(
                              'Comeza a comprar agora',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: pedidos.length,
                      itemBuilder: (context, index) {
                         return PedidoCard(
                          pedido: pedidos[index],
                          green: green,  
                          api: widget.api,  
                        );
                      },
                    );
                  },
                ),

                // Tab 2: Compras Recurrentes
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _cargarComprasRecurrentes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text('Error: ${snapshot.error}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }

                    final compras = snapshot.data ?? [];

                    if (compras.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.repeat_outlined,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            const Text('Non hai compras recurrentes'),
                            const SizedBox(height: 8),
                            Text(
                              'Configura compras automáticas',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: compras.length,
                      itemBuilder: (context, index) {
                        final item = compras[index];
                        final compra =
                            item['compra'] as CompraRecorrenteDto;
                        final producto =
                            item['producto'] as ProductoDto?;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            producto?.nome ??
                                                'Producto ${compra.productoId}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: green
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(4),
                                            ),
                                            child: Text(
                                              compra.estado ??
                                                  'Activo',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w500,
                                                color: green,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        final confirm =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (context) =>
                                              AlertDialog(
                                            title: const Text(
                                                'Eliminar compra'),
                                            content: const Text(
                                              '¿Estás seguro de que quieres cancelar esta compra recurrente?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context,
                                                        false),
                                                child: const Text(
                                                    'Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context,
                                                        true),
                                                child: const Text(
                                                  'Eliminar',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true &&
                                            compra.id != null) {
                                          try {
                                            await _compraRecorrenteService
                                                .delete(compra.id!);
                                            if (mounted) {
                                              ScaffoldMessenger.of(
                                                      context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Compra recurrente eliminada',
                                                  ),
                                                ),
                                              );
                                              setState(() {});
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(
                                                      context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Error: $e',
                                                  ),
                                                  backgroundColor:
                                                    Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cantidad',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          '${compra.cantidade} unid.',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Frecuencia',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          compra.frecuencia ??
                                              'Semanal',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Inicio',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          compra.dataInicio != null
                                              ? '${compra.dataInicio!.day}/${compra.dataInicio!.month}/${compra.dataInicio!.year}'
                                              : 'N/A',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
