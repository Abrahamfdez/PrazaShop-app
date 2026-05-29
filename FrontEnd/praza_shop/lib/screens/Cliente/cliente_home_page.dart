import 'package:flutter/material.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/models/usuario_dto.dart';
import 'package:praza_shop/models/negocio_dto.dart';
import 'package:praza_shop/models/valoracion_estadisticas_dto.dart';
import 'package:praza_shop/models/categoria_enum.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/negocio_service.dart';
import 'package:praza_shop/services/valoracion_service.dart';
import 'package:praza_shop/widgets/producto_card.dart';
import 'cliente_perfil_page.dart';
import 'cliente_productos_negocio_page.dart';

/// Página principal para clientes que muestra negocios y productos
/// con dos apartados separados para mejor navegación.
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

class _ClienteHomePageState extends State<ClienteHomePage>
    with TickerProviderStateMixin {
  final _searchCtl = TextEditingController();
  late Future<List<ProductoDto>> _productosFuture;
  late Future<List<NegocioDto>> _negociosFuture;
  late NegocioService _negocioService;
  late TabController _tabController;
  
  List<ProductoDto> _todosProgramas = [];
  List<ProductoDto> _productosFiltered = [];
  List<NegocioDto> _todosNegocios = [];
  List<NegocioDto> _negociosFiltered = [];
  
  String _categoriaSeleccionada = 'Todos';
  
  // Cache de negocios para evitar múltiples llamadas a la API
  final Map<int, NegocioDto> _negociosCache = {};
  
  // Cache de valoraciones para evitar múltiples llamadas a la API
  final Map<int, ValoracionEstadisticasDto> _valoracionesCache = {};

  // Categorías disponibles (incluye 'Todos' más las del enum)
  late List<String> _categorias;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _negocioService = NegocioService(widget.api);
    _productosFuture = _cargarProductos();
    _negociosFuture = _cargarNegocios();
    _searchCtl.addListener(_filtrar);
    // Inicializar categorías con 'Todos' más todas las del enum
    _categorias = CategoriaProducto.getCategoriesWithTodos();
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Carga todos los negocios desde la API
  Future<List<NegocioDto>> _cargarNegocios() async {
    try {
      final response = await _negocioService.getAll();
      setState(() {
        _todosNegocios = response;
        _negociosFiltered = _todosNegocios;
      });
      return response;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ao cargar negocios: $e')),
      );
      return [];
    }
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

  /// Filtra productos y negocios según el tab activo
  void _filtrar() {
    if (_tabController.index == 0) {
      _filtrarNegocios();
    } else {
      _filtrarProductos();
    }
  }

  /// Filtra negocios por búsqueda
  void _filtrarNegocios() {
    final busqueda = _searchCtl.text.toLowerCase();

    setState(() {
      _negociosFiltered = _todosNegocios.where((n) {
        final coincibeBusqueda =
            n.nomeNegocio?.toLowerCase().contains(busqueda) ?? false;
        return coincibeBusqueda;
      }).toList();
    });
  }

  /// Normaliza cadenas removiendo acentos para comparación
  String _normalizarTexto(String texto) {
    // Primero limpiar caracteres inválidos UTF-8 comunes
    String result = texto;
    
    // Reemplazar errores comunes de encoding UTF-8 doble
    result = result.replaceAll('Ã­', 'í');
    result = result.replaceAll('Ã¡', 'á');
    result = result.replaceAll('Ã©', 'é');
    result = result.replaceAll('Ã³', 'ó');
    result = result.replaceAll('Ã©', 'é');
    result = result.replaceAll('Ã', 'a');
    
    // Convertir a minúsculas
    result = result.toLowerCase();
    
    // Convertir a minúsculas y remover acentos/caracteres especiales
    const Map<String, String> accents = {
      'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u',
      'à': 'a', 'è': 'e', 'ì': 'i', 'ò': 'o', 'ù': 'u',
      'â': 'a', 'ê': 'e', 'î': 'i', 'ô': 'o', 'û': 'u',
      'ã': 'a', 'õ': 'o', 'ñ': 'n',
      'ä': 'a', 'ë': 'e', 'ï': 'i', 'ö': 'o', 'ü': 'u',
    };
    
    accents.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  /// Filtra productos por categoría y búsqueda
  void _filtrarProductos() {
    final busqueda = _searchCtl.text.toLowerCase();

    setState(() {
      print('\n=== DEBUG FILTRO HOME ===');
      print('_categoriaSeleccionada = "$_categoriaSeleccionada"');
      final categoriaNorm = _normalizarTexto(_categoriaSeleccionada);
      print('Categoría normalizada = "$categoriaNorm"');
      print('Total productos = ${_todosProgramas.length}');
      
      // Debug: mostrar todas las categorías únicas en los productos
      final categoriasUnicas = _todosProgramas
          .map((p) => p.categoria)
          .where((c) => c != null)
          .toSet()
          .toList();
      print('Categorías únicas en BD: $categoriasUnicas');
      
      for (var cat in categoriasUnicas) {
        final catNorm = _normalizarTexto(cat ?? '');
        print('  "$cat" → normalizada: "$catNorm" (coincide: ${catNorm == categoriaNorm})');
      }
      
      _productosFiltered = _todosProgramas.where((p) {
        bool coincibeCategoria;
        
        if (_categoriaSeleccionada == 'Todos') {
          coincibeCategoria = true;
        } else {
          // Normalizar ambas cadenas para comparación
          final productoCategoria = p.categoria?.trim() ?? '';
          final categoriaNormalizada = _normalizarTexto(productoCategoria);
          final categoriaSeleccionadaNormalizada = _normalizarTexto(_categoriaSeleccionada);
          
          coincibeCategoria = categoriaNormalizada == categoriaSeleccionadaNormalizada;
        }
        
        final coincibeBusqueda =
            p.nome?.toLowerCase().contains(busqueda) ?? false;
        return coincibeCategoria && coincibeBusqueda;
      }).toList();
      
      print('Filtro resultado: ${_productosFiltered.length} productos encontrados');
      print('===\n');
    });
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientePerfilPage(
                      api: widget.api,
                      usuario: widget.usuario,
                    ),
                  ),
                );
              },
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
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: green,
          unselectedLabelColor: Colors.grey,
          indicatorColor: green,
          indicatorWeight: 3,
          onTap: (_) {
            setState(() {
              _searchCtl.clear();
              if (_tabController.index == 0) {
                _negociosFiltered = _todosNegocios;
              } else {
                _categoriaSeleccionada = 'Todos';
                _productosFiltered = _todosProgramas;
              }
            });
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.store),
              text: 'Negocios',
            ),
            Tab(
              icon: Icon(Icons.shopping_bag),
              text: 'Productos',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Negocios
          _buildNegociosTab(green),
          // Tab 2: Productos
          _buildProductosTab(green),
        ],
      ),
    );
  }

  /// Construye el tab de negocios
  Widget _buildNegociosTab(Color green) {
    return FutureBuilder<List<NegocioDto>>(
      future: _negociosFuture,
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
                      _negociosFuture = _cargarNegocios();
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
                    hintText: 'Buscar negocios...',
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

                // Lista de negocios
                if (_negociosFiltered.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.store_outlined,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Ningún negocio encontrado',
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _negociosFiltered.length,
                    itemBuilder: (context, index) {
                      final negocio = _negociosFiltered[index];
                      return _buildNegocioCard(negocio, green, context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Widget para tarjeta de negocio
  Widget _buildNegocioCard(
      NegocioDto negocio, Color green, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClienteProductosNegocioPage(
              api: widget.api,
              usuario: widget.usuario,
              negocio: negocio,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Logo del negocio
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.store,
                  color: green,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              // Info del negocio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      negocio.nomeNegocio ?? 'Negocio',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (negocio.descricion != null)
                      Text(
                        negocio.descricion ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            negocio.direccion ?? 'Ubicación no disponible',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<ValoracionEstadisticasDto>(
                      future: _getValoracionNegocio(negocio.id ?? 0),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final valoracion = snapshot.data;
                          final puntuacion = valoracion?.mediaPuntuacion ?? 0.0;
                          final cantidad = valoracion?.cantidadValoraciones ?? 0;
                          final estrellas = (puntuacion / 1).round().clamp(0, 5);
                          
                          return Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    Icons.star,
                                    color: index < estrellas
                                        ? Colors.amber
                                        : Colors.grey[300],
                                    size: 14,
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${puntuacion.toStringAsFixed(1)} ⭐ ($cantidad)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  color: Colors.grey[300],
                                  size: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Cargando...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Flecha
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Obtiene las estadísticas de valoración de un negocio
  Future<ValoracionEstadisticasDto> _getValoracionNegocio(int negocioId) async {
    if (_valoracionesCache.containsKey(negocioId)) {
      return _valoracionesCache[negocioId]!;
    }
    
    try {
      final valoracionService = ValoracionService(widget.api);
      final stats = await valoracionService.getEstadisticasByNegocioId(negocioId);
      _valoracionesCache[negocioId] = stats;
      return stats;
    } catch (e) {
      // Retornar valores por defecto en caso de error
      return ValoracionEstadisticasDto(
        negocioId: negocioId,
        cantidadValoraciones: 0,
        mediaPuntuacion: 0.0,
      );
    }
  }

  /// Construye el tab de productos
  Widget _buildProductosTab(Color green) {
    return FutureBuilder<List<ProductoDto>>(
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
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _categorias.map((categoria) {
                    final isSelected = categoria == _categoriaSeleccionada;
                    return FilterChip(
                      label: Text(
                        categoria,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          fontSize: 13,
                          color: isSelected ? Colors.white : Colors.grey[800],
                        ),
                      ),
                      selected: isSelected,
                      backgroundColor: isSelected ? green : Colors.white,
                      side: BorderSide(
                        color: isSelected ? green : Colors.grey[300]!,
                        width: 1.5,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _categoriaSeleccionada = categoria;
                        });
                        _filtrarProductos();
                      },
                    );
                  }).toList(),
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
    );
  }
}

