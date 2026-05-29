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

/// Página que muestra todos los productos de un negocio específico
class ClienteProductosNegocioPage extends StatefulWidget {
  final ApiService api;
  final UsuarioDto usuario;
  final NegocioDto negocio;

  const ClienteProductosNegocioPage({
    super.key,
    required this.api,
    required this.usuario,
    required this.negocio,
  });

  @override
  State<ClienteProductosNegocioPage> createState() =>
      _ClienteProductosNegocioPageState();
}

class _ClienteProductosNegocioPageState
    extends State<ClienteProductosNegocioPage> {
  final _searchCtl = TextEditingController();
  late Future<List<ProductoDto>> _productosFuture;
  late NegocioService _negocioService;
  
  List<ProductoDto> _todosProductos = [];
  List<ProductoDto> _productosFiltered = [];
  String _categoriaSeleccionada = 'Todos';

  // Cache de negocios
  final Map<int, NegocioDto> _negociosCache = {};

  // Cache de valoraciones
  final Map<int, ValoracionEstadisticasDto> _valoracionesCache = {};

  // Categorías disponibles (incluye 'Todos' más las del enum)
  late List<String> _categorias;

  @override
  void initState() {
    super.initState();
    _negocioService = NegocioService(widget.api);
    _productosFuture = _cargarProductos();
    _searchCtl.addListener(_filtrarProductos);
    // Pre-cargar el negocio en el cache
    _negociosCache[widget.negocio.id ?? 0] = widget.negocio;
    // Inicializar categorías con 'Todos' más todas las del enum
    _categorias = CategoriaProducto.getCategoriesWithTodos();
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  /// Carga todos los productos del negocio desde la API
  Future<List<ProductoDto>> _cargarProductos() async {
    try {
      // Obtener todos los productos y filtrar por negocio
      final response = await widget.api.getProductos();
      print('DEBUG: Total productos obtenidos: ${response.length}');
      print('DEBUG: Buscando productos para negocioId: ${widget.negocio.id}');
      
      // Debug: mostrar todos los productos
      for (var p in response) {
        print('DEBUG: Producto ${p.id}: negocioId=${p.negocioId}, estado=${p.estado}, nombre=${p.nome}');
      }
      
      final productosNegocio = response
          .where((p) =>
              p.negocioId == widget.negocio.id)
          .toList();
      
      print('DEBUG: Productos encontrados para este negocio: ${productosNegocio.length}');

      setState(() {
        _todosProductos = productosNegocio;
        _productosFiltered = productosNegocio;
      });
      return productosNegocio;
    } catch (e) {
      print('ERROR cargando productos: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error ao cargar productos: $e')),
        );
      }
      return [];
    }
  }

  /// Normaliza cadenas removiendo acentos para comparación
  String _normalizarTexto(String texto) {
    // Convertir a minúsculas y remover acentos/caracteres especiales
    const Map<String, String> accents = {
      'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u',
      'à': 'a', 'è': 'e', 'ì': 'i', 'ò': 'o', 'ù': 'u',
      'â': 'a', 'ê': 'e', 'î': 'i', 'ô': 'o', 'û': 'u',
      'ã': 'a', 'õ': 'o', 'ñ': 'n',
      'ä': 'a', 'ë': 'e', 'ï': 'i', 'ö': 'o', 'ü': 'u',
    };
    
    String result = texto.toLowerCase();
    accents.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  /// Filtra productos por categoría y búsqueda
  void _filtrarProductos() {
    final busqueda = _searchCtl.text.toLowerCase();

    setState(() {
      _productosFiltered = _todosProductos.where((p) {
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
      
      print('DEBUG: Filtro Negocio - Categoría: $_categoriaSeleccionada, Productos encontrados: ${_productosFiltered.length}');
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.negocio.nomeNegocio ?? 'Negocio',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  // Información del negocio
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.store,
                            color: green,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.negocio.nomeNegocio ?? 'Negocio',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (widget.negocio.descricion != null)
                                Text(
                                  widget.negocio.descricion ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.grey, size: 14),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      widget.negocio.direccion ?? 'Ubicación no disponible',
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
                                future: _getValoracionNegocio(widget.negocio.id ?? 0),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

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
                          negocioService: NegocioService(widget.api),
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
}
