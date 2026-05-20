import 'package:flutter/material.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/producto_service.dart';

/// Página para editar un producto existente
class EditarProductoPage extends StatefulWidget {
  final ApiService api;
  final ProductoDto producto;

  const EditarProductoPage({
    super.key,
    required this.api,
    required this.producto,
  });

  @override
  State<EditarProductoPage> createState() => _EditarProductoPageState();
}

class _EditarProductoPageState extends State<EditarProductoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtl;
  late TextEditingController _descripcionCtl;
  late TextEditingController _prezoCtl;
  late TextEditingController _stockCtl;
  late TextEditingController _imagenUrlCtl;
  late TextEditingController _categoriaCtl;

  late ProductoService _productoService;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _productoService = ProductoService(widget.api);
    
    // Inicializar controladores con los datos del producto
    _nombreCtl = TextEditingController(text: widget.producto.nome ?? '');
    _descripcionCtl = TextEditingController(text: widget.producto.descricion ?? '');
    _prezoCtl = TextEditingController(text: widget.producto.prezo?.toString() ?? '');
    _stockCtl = TextEditingController(text: widget.producto.stock?.toString() ?? '');
    _imagenUrlCtl = TextEditingController(text: widget.producto.imaxe ?? '');
    _categoriaCtl = TextEditingController(text: widget.producto.categoria ?? '');
    
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

  Future<void> _actualizarProducto() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      // Actualizar producto con los nuevos datos
      final productoActualizado = ProductoDto(
        id: widget.producto.id,
        nome: _nombreCtl.text.trim(),
        descricion: _descripcionCtl.text.trim(),
        prezo: double.tryParse(_prezoCtl.text) ?? 0.0,
        stock: int.tryParse(_stockCtl.text) ?? 0,
        imaxe: _imagenUrlCtl.text.trim(),
        categoria: _categoriaCtl.text.trim(),
        negocioId: widget.producto.negocioId,
      );

      // Usar el nuevo endpoint user-scoped que verifica propiedad
      await _productoService.actualizarProductoEnNegocio(productoActualizado.id!, productoActualizado);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado exitosamente')),
      );
      Navigator.of(context).pop(true); // Retornar true para recargar la lista
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
          'Editar Producto',
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
              // URL Imaxe
              const Text(
                'URL da imaxe',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imagenUrlCtl,
                decoration: InputDecoration(
                  hintText: 'https://example.com/imagen.jpg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Introduce a URL da imaxe' : null,
              ),
              const SizedBox(height: 12),

              // Preview da imaxe
              if (_imagenUrlCtl.text.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: Image.network(
                    _imagenUrlCtl.text,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.image_not_supported, size: 48),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 48),
                  ),
                ),
              const SizedBox(height: 24),

              // Nome do produto
              const Text(
                'Nome do produto',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nombreCtl,
                decoration: InputDecoration(
                  hintText: 'Ej: Tomates Galegos',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Introduce o nome do produto' : null,
              ),
              const SizedBox(height: 12),

              // Categoría
              const Text(
                'Categoría',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _categoriaCtl,
                decoration: InputDecoration(
                  hintText: 'Ej: Frutas, Verduras, etc',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Introduce a categoría' : null,
              ),
              const SizedBox(height: 12),

              // Descripción
              const Text(
                'Descripción',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descripcionCtl,
                decoration: InputDecoration(
                  hintText: 'Describe o teu producto...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Introduce a descripción' : null,
              ),
              const SizedBox(height: 12),

              // Prezo e Stock
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Prezo (€)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _prezoCtl,
                          decoration: InputDecoration(
                            hintText: '0.00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Introduce o prezo';
                            if (double.tryParse(v) == null) return 'Prezo non válido';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Stock (kg)',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _stockCtl,
                          decoration: InputDecoration(
                            hintText: '0',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Introduce o stock';
                            if (int.tryParse(v) == null) return 'Stock non válido';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botón actualizar
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
                  onPressed: _loading ? null : _actualizarProducto,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Actualizar producto',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
}
