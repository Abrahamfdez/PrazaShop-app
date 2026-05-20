import 'package:flutter/material.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/producto_service.dart';
import 'package:praza_shop/services/negocio_service.dart';
import 'package:praza_shop/utils/api_utils.dart';

/// Página para crear un nuevo producto
class CrearProductoPage extends StatefulWidget {
  final ApiService api;

  const CrearProductoPage({
    super.key,
    required this.api,
  });

  @override
  State<CrearProductoPage> createState() => _CrearProductoPageState();
}

class _CrearProductoPageState extends State<CrearProductoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtl = TextEditingController();
  final _descripcionCtl = TextEditingController();
  final _prezoCtl = TextEditingController();
  final _stockCtl = TextEditingController();
  final _imagenUrlCtl = TextEditingController();
  final _categoriaCtl = TextEditingController();

  late ProductoService _productoService;
  late NegocioService _negocioService;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _productoService = ProductoService(widget.api);
    _negocioService = NegocioService(widget.api);
    _imagenUrlCtl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nombreCtl.dispose();
    _descripcionCtl.dispose();
    _prezoCtl.dispose();
    _stockCtl.dispose();
    _imagenUrlCtl.dispose();
    _categoriaCtl.dispose();
    super.dispose();
  }

  /// Valida que el precio sea número válido
  String? _validarPrecio(String? value) {
    if (value == null || value.trim().isEmpty) return 'Introduce o prezo';
    if (double.tryParse(value) == null) return 'Prezo non válido';
    return null;
  }

  /// Valida que el stock sea número entero válido
  String? _validarStock(String? value) {
    if (value == null || value.trim().isEmpty) return 'Introduce o stock';
    if (int.tryParse(value) == null) return 'Stock non válido';
    return null;
  }

  /// Valida que un campo no esté vacío
  String? _validarNoVacio(String? value, String campo) {
    if (value == null || value.trim().isEmpty) return 'Introduce $campo';
    return null;
  }

  /// Crea el producto en el backend usando el nuevo endpoint user-scoped
  Future<void> _crearProducto() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      // El nuevo endpoint auto-resuelve el negocioId del usuario autenticado
      final producto = ProductoDto(
        nome: _nombreCtl.text.trim(),
        descricion: _descripcionCtl.text.trim(),
        prezo: double.parse(_prezoCtl.text),
        stock: int.parse(_stockCtl.text),
        imaxe: _imagenUrlCtl.text.trim(),
        categoria: _categoriaCtl.text.trim(),
        // No es necesario establecer negocioId, lo auto-resuelve el backend
      );

      await _productoService.crearProductoEnNegocio(producto);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto creado exitosamente')),
      );
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
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
          'Crear Producto',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview de imagen
              _buildImagePreview(),
              const SizedBox(height: 24),

              // URL de imagen
              _buildFormField(
                label: 'URL da imaxe',
                controller: _imagenUrlCtl,
                hint: 'https://example.com/imagen.jpg',
                validator: (v) => _validarNoVacio(v, 'a URL da imaxe'),
              ),
              const SizedBox(height: 24),

              // Nome
              _buildFormField(
                label: 'Nome do producto',
                controller: _nombreCtl,
                hint: 'Ej: Tomates Galegos',
                validator: (v) => _validarNoVacio(v, 'o nome do producto'),
              ),
              const SizedBox(height: 12),

              // Categoría
              _buildFormField(
                label: 'Categoría',
                controller: _categoriaCtl,
                hint: 'Ej: Frutas, Verduras',
                validator: (v) => _validarNoVacio(v, 'a categoría'),
              ),
              const SizedBox(height: 12),

              // Descripción
              _buildFormField(
                label: 'Descripción',
                controller: _descripcionCtl,
                hint: 'Describe o teu producto...',
                maxLines: 3,
                validator: (v) => _validarNoVacio(v, 'a descripción'),
              ),
              const SizedBox(height: 12),

              // Precio y Stock
              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      label: 'Prezo (€)',
                      controller: _prezoCtl,
                      hint: '0.00',
                      keyboardType: TextInputType.number,
                      validator: _validarPrecio,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormField(
                      label: 'Stock (unidades)',
                      controller: _stockCtl,
                      hint: '0',
                      keyboardType: TextInputType.number,
                      validator: _validarStock,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Botón crear
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _loading ? null : _crearProducto,
                  child: _loading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Crear Producto',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget auxiliar para mostrar preview de imagen
  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: _imagenUrlCtl.text.isEmpty
          ? const Center(
              child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _imagenUrlCtl.text,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image_not_supported, size: 48),
                  );
                },
              ),
            ),
    );
  }

  /// Widget auxiliar para campos de formulario reutilizables
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }
}
