import 'package:flutter/material.dart';
import 'package:praza_shop/models/valoracion_dto.dart';
import 'package:praza_shop/models/pedido_dto.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/models/negocio_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/valoracion_service.dart';

/// Página para valorar una compra realizada
class ValoracionCompraPage extends StatefulWidget {
  final PedidoDto pedido;
  final ProductoDto producto;
  final NegocioDto negocio;
  final ApiService api;

  const ValoracionCompraPage({
    super.key,
    required this.pedido,
    required this.producto,
    required this.negocio,
    required this.api,
  });

  @override
  State<ValoracionCompraPage> createState() => _ValoracionCompraPageState();
}

class _ValoracionCompraPageState extends State<ValoracionCompraPage> {
  int _puntuacion = 0;
  late TextEditingController _comentarioController;
  bool _isLoading = false;
  late ValoracionService _valoracionService;

  @override
  void initState() {
    super.initState();
    _comentarioController = TextEditingController();
    _valoracionService = ValoracionService(widget.api);
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  /// Envía la valoración a la API
  Future<void> _enviarValoracion() async {
    if (_puntuacion == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una puntuación'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final valoracion = ValoracionDto(
        negocioId: widget.negocio.id,
        clienteId: widget.pedido.clienteId,
        puntuacion: _puntuacion,
        comentario: _comentarioController.text.isEmpty
            ? null
            : _comentarioController.text,
            dataValoracion: DateTime.now()
      );

      await _valoracionService.create(valoracion);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Valoración enviada correctamente!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Cerrar la página
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      print('Error al enviar valoración: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Salta la valoración
  void _saltarValoracion() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
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
          'Valorar compra',
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),

                    // Icono de éxito
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 40,
                        color: green,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Título
                    const Text(
                      '¡Compra confirmada!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtítulo
                    Text(
                      '¿Cómo fue a tua experiencia?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Sección de valoración
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Valoración',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Estrellas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: GestureDetector(
                                  onTap: () => setState(() =>
                                      _puntuacion = index + 1),
                                  child: Icon(
                                    index < _puntuacion
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 40,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Campo de comentario
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comentario (opcional)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _comentarioController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                'Comparte tu opinión sobre o producto...',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: green,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Botón enviar valoración
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _enviarValoracion,
                        child: const Text(
                          'Enviar valoración',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botón saltar
                    TextButton(
                      onPressed: _saltarValoracion,
                      child: Text(
                        'Saltar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}
