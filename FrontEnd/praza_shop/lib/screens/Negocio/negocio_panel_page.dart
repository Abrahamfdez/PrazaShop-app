import 'package:flutter/material.dart';
import 'package:praza_shop/models/negocio_dto.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/negocio_service.dart';
import 'package:praza_shop/services/producto_service.dart';
import 'package:praza_shop/utils/api_utils.dart';
import 'package:praza_shop/screens/Negocio/crear_producto_page.dart';
import 'package:praza_shop/screens/Negocio/editar_producto_page.dart';
import 'package:praza_shop/screens/Negocio/ventas_page.dart';

/// Página del panel de negocio
class NegocioPanelPage extends StatefulWidget {
  final ApiService api;

  const NegocioPanelPage({
    super.key,
    required this.api,
  });

  @override
  State<NegocioPanelPage> createState() => _NegocioPanelPageState();
}

class _NegocioPanelPageState extends State<NegocioPanelPage> {
  late NegocioService _negocioService;
  late ProductoService _productoService;

  NegocioDto? _negocio;
  List<ProductoDto> _productos = [];
  bool _isLoading = true;
  int _totalVendas = 0;
  double _mediaValoracion = 0.0;

  @override
  void initState() {
    super.initState();
    _negocioService = NegocioService(widget.api);
    _productoService = ProductoService(widget.api);
    _cargarDatos();
  }

  /// Carga todos los datos del negocio usando el nuevo endpoint consolidado
  Future<void> _cargarDatos() async {
    try {
      // Obtener usuario actual
      final usuario = await ApiUtils.getUserFromToken(widget.api, widget.api.token);

      // Obtener negocio del usuario
      final negocio = await _negocioService.getByUsuarioId(usuario.id!);

      // Obtener dashboard completo (negocio, productos, pedidos y stats en una sola llamada)
      final dashboard = await _negocioService.getDashboard(negocio.id!);
      
      final negocioData = dashboard['negocio'] as Map<String, dynamic>?
          ?? {'id': negocio.id, 'nomeNegocio': negocio.nomeNegocio};
      final productosData = (dashboard['productos'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
      final statsData = dashboard['stats'] as Map<String, dynamic>? ?? {};
      
      // Convertir datos a DTOs
      final negocioFromDash = NegocioDto(
        id: negocioData['id'],
        nomeNegocio: negocioData['nomeNegocio'],
        direccion: negocioData['direccion'],
        descricion: negocioData['descricion'],
        usuarioId: negocioData['usuarioId'],
      );
      
      final productosFromDash = productosData
          .map((p) => ProductoDto.fromJson(p))
          .toList();
      
      final totalVendas = statsData['totalVentasCount'] as int? ?? 0;
      final mediaVal = (statsData['ratingPromedio'] as num? ?? 0.0).toDouble();

      setState(() {
        _negocio = negocioFromDash;
        _productos = productosFromDash;
        _totalVendas = totalVendas;
        _mediaValoracion = mediaVal;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar datos del negocio: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// Elimina un producto usando el nuevo endpoint user-scoped
  Future<void> _eliminarProducto(int productoId) async {
    try {
      await _productoService.eliminarProductoDelNegocio(productoId);
      setState(() {
        _productos.removeWhere((p) => p.id == productoId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
    } catch (e) {
      print('Error al eliminar producto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
      
        title: const Text(
          'Panel de Negocio',
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
          : SingleChildScrollView(
              child: _negocio == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No se pudo cargar el negocio',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header del negocio
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.store,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _negocio!.nomeNegocio ??
                                                'Sin nombre',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          if (_negocio!.direccion != null)
                                            Text(
                                              _negocio!.direccion!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Estadísticas
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _buildStatCardContent(
                                      'Productos',
                                      _productos.length.toString(),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => VentasPage(api: widget.api),
                                          ),
                                        );
                                      },
                                      child: _buildStatCardContent(
                                        'Vendas',
                                        _totalVendas.toString(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatCardContent(
                                      'Valoración',
                                      _mediaValoracion.toStringAsFixed(1),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Botón añadir producto
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () async {
                                    final result = await Navigator.of(context).push<bool>(
                                      MaterialPageRoute(
                                        builder: (_) => CrearProductoPage(api: widget.api),
                                      ),
                                    );
                                    if (result == true) {
                                      _cargarDatos();
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.add, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Engadir producto',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Título de productos
                              const Text(
                                'Os meus productos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Lista de productos
                              if (_productos.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Text(
                                      'Non hai productos',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemCount: _productos.length,
                                  itemBuilder: (context, index) {
                                    final producto = _productos[index];
                                    final isLowStock =
                                        (producto.stock ?? 0) < 5;

                                    return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          // Imagen
                                          Container(
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: producto.imaxe != null &&
                                                    producto.imaxe!
                                                        .isNotEmpty
                                                ? Image.network(
                                                    producto.imaxe!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Center(
                                                        child: Icon(
                                                          Icons
                                                              .image_not_supported,
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : const Center(
                                                    child: Icon(
                                                      Icons
                                                          .image_not_supported,
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Información
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  producto.nome ?? 'Sin nombre',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${producto.prezo?.toStringAsFixed(2) ?? '0.00'}€/${producto.categoria ?? 'unidade'}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: green,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: isLowStock
                                                        ? Colors.orange[50]
                                                        : Colors.green[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    isLowStock
                                                        ? 'Baixo stock'
                                                        : 'En stock',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: isLowStock
                                                          ? Colors.orange[700]
                                                          : Colors.green[700],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Botones de acción
                                          Column(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                onPressed: () async {
                                                  final result = await Navigator.of(context).push<bool>(
                                                    MaterialPageRoute(
                                                      builder: (_) => EditarProductoPage(
                                                        api: widget.api,
                                                        producto: producto,
                                                      ),
                                                    ),
                                                  );
                                                  if (result == true) {
                                                    _cargarDatos();
                                                  }
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          'Eliminar producto',
                                                        ),
                                                        content: const Text(
                                                          '¿Estás seguro de que deseas eliminar este producto?',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                              context,
                                                            ).pop(),
                                                            child: const Text(
                                                              'Cancelar',
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                              _eliminarProducto(
                                                                producto.id!,
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Eliminar',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  /// Widget para mostrar estadísticas (solo el contenedor sin Expanded)
  Widget _buildStatCardContent(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF10A75A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget para mostrar estadísticas
  Widget _buildStatCard(String label, String value, {bool isClickable = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF10A75A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
