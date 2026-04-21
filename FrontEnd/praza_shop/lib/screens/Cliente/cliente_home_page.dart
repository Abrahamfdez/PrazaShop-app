import 'package:flutter/material.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/models/usuario_dto.dart';
import 'package:praza_shop/models/negocio_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/negocio_service.dart';
import 'package:praza_shop/widgets/producto_card.dart';

/// Página principal para clientes que muestra productos disponibles
/// y permite buscar y filtrar por categorías.
class ClienteHomePage extends StatefulWidget {
  final ApiService api;
  final UsuarioDto usuario;

  const ClienteHomePage({
    super.key,
    required this.api,
    required this.usuario,
  });

  @override
  State<ClienteHomePage> createState() => _ClienteHomePageState();
}

class _ClienteHomePageState extends State<ClienteHomePage> {
  final _searchCtl = TextEditingController();
  late Future<List<ProductoDto>> _productosFuture;
  late NegocioService _negocioService;
  List<ProductoDto> _todosProgramas = [];
  List<ProductoDto> _productosFiltered = [];
  String _categoriaSeleccionada = 'Todos';
  
  // Cache de negocios para evitar múltiples llamadas a la API
  final Map<int, NegocioDto> _negociosCache = {};

  // Categorías disponibles
  final List<String> _categorias = [
    'Todos',
    'Froitas',
    'Verduras',
    'Peixe',
  ];

  @override
  void initState() {
    super.initState();
    _negocioService = NegocioService(widget.api);
    _productosFuture = _cargarProductos();
    _searchCtl.addListener(_filtrarProductos);
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  /// Carga todos los productos desde la API
  Future<List<ProductoDto>> _cargarProductos() async {
    try {
      final response = await widget.api.getProductos();
      setState(() {
        _todosProgramas = response;
        _productosFiltered = response;
      });
      return response.where((p) => p.estado != null && p.estado=="ACTIVO").toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ao cargar productos: $e')),
      );
      return [];
    }
  }

  /// Filtra productos por categoría y búsqueda
  void _filtrarProductos() {
    final busqueda = _searchCtl.text.toLowerCase();

    setState(() {
      _productosFiltered = _todosProgramas.where((p) {
        final coincibeCategoria = _categoriaSeleccionada == 'Todos' ||
            p.categoria?.toLowerCase() == _categoriaSeleccionada.toLowerCase();
        final coincibeBusqueda =
            p.nome?.toLowerCase().contains(busqueda) ?? false;
        return coincibeCategoria && coincibeBusqueda;
      }).toList();
    });
  }

  /// Cambia la categoría seleccionada
  void _cambiarCategoria(String categoria) {
    setState(() {
      _categoriaSeleccionada = categoria;
    });
    _filtrarProductos();
  }

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF10A75A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.eco, color: Colors.white),
          ),
        ),
        title: const Text(
          'PrazaShop',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Text(
                  'Hola ${widget.usuario.nome ?? 'Usuario'}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<ProductoDto>>(
        future: _productosFuture,
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
                        _productosFuture = _cargarProductos();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra de búsqueda
                  TextField(
                    controller: _searchCtl,
                    decoration: InputDecoration(
                      hintText: 'Buscar productos...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.tune),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Filtro de categorías
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categorias.map((categoria) {
                        final isSelected = categoria == _categoriaSeleccionada;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(categoria),
                            selected: isSelected,
                            backgroundColor: Colors.grey[200],
                            selectedColor: green,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            onSelected: (selected) {
                              _cambiarCategoria(categoria);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Grid de productos
                  if (_productosFiltered.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.shopping_bag_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Ningún producto encontrado',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _productosFiltered.length,
                      itemBuilder: (context, index) {
                        final producto = _productosFiltered[index];
                        return ProductoCard(
                          producto: producto,
                          green: green,
                          negocioService: _negocioService,
                          negociosCache: _negociosCache,
                          api: widget.api,
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  }

