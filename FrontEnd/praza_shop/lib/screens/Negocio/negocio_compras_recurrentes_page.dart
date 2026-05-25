import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praza_shop/models/usuario_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/compra_recorrente_service.dart';
import 'package:praza_shop/services/producto_service.dart';

class NegocioComprasRecurrentesPage extends StatefulWidget {
  final ApiService api;
  final UsuarioDto usuario;

  const NegocioComprasRecurrentesPage({
    super.key,
    required this.api,
    required this.usuario,
  });

  @override
  State<NegocioComprasRecurrentesPage> createState() => _NegocioComprasRecurrentesPageState();
}

class _NegocioComprasRecurrentesPageState extends State<NegocioComprasRecurrentesPage> {
  static const Color green = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color orange = Color(0xFFFF9800);

  late CompraRecorrenteService _compraRecorrenteService;
  late ProductoService _productoService;

  List<Map<String, dynamic>> _comprasRecurrentes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _compraRecorrenteService = CompraRecorrenteService(widget.api);
    _productoService = ProductoService(widget.api);
    _cargarCompras();
  }

  Future<void> _cargarCompras() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final compras = await _compraRecorrenteService.misComprasRecurrentesNegocio();

      // Enriquecer con información del producto
      List<Map<String, dynamic>> comprasEnriquecidas = [];
      for (var compra in compras) {
        try {
          final producto = await _productoService.getById(compra.productoId ?? 0);
          comprasEnriquecidas.add({
            'compra': compra,
            'producto': producto,
          });
          // Pequeño delay para no saturar el backend
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          // Si falla obtener el producto, igual lo agregamos
          comprasEnriquecidas.add({
            'compra': compra,
            'producto': null,
          });
        }
      }

      setState(() {
        _comprasRecurrentes = comprasEnriquecidas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar compras recurrentes: $e';
        _isLoading = false;
      });
    }
  }

  String _formatFrecuencia(String? frecuencia) {
    if (frecuencia == null) return 'N/A';
    switch (frecuencia.toUpperCase()) {
      case 'DIARIO':
        return 'Cada día';
      case 'SEMANAL':
        return 'Semanalmente';
      case 'QUINCENAL':
        return 'Cada 15 días';
      case 'MENSUAL':
        return 'Mensualmente';
      default:
        return frecuencia;
    }
  }

  /// Calcula la próxima fecha de entrega basada en la frecuencia y fecha de inicio
  /// Si la fecha de inicio está en el pasado y está activo, calcula la siguiente entrega
  /// Garantiza que la fecha retornada siempre sea futura
  DateTime? _calcularProximaFecha(DateTime? dataInicio, String? frecuencia, String? estado) {
    if (dataInicio == null || frecuencia == null || estado?.toUpperCase() != 'ACTIVO') {
      return dataInicio;
    }

    final hoy = DateTime.now();
    var proximaFecha = dataInicio;

    // Si la fecha inicial está en el pasado, calcular la próxima entrega
    if (proximaFecha.isBefore(hoy)) {
      switch (frecuencia.toUpperCase()) {
        case 'DIARIO':
          // Próxima entrega es mañana
          proximaFecha = DateTime(hoy.year, hoy.month, hoy.day + 1);
          break;
        
        case 'SEMANAL':
          // Continuar sumando semanas hasta que esté en el futuro
          while (proximaFecha.isBefore(hoy)) {
            proximaFecha = proximaFecha.add(const Duration(days: 7));
          }
          break;
        
        case 'QUINCENAL':
          // Continuar sumando quincenas hasta que esté en el futuro
          while (proximaFecha.isBefore(hoy)) {
            proximaFecha = proximaFecha.add(const Duration(days: 15));
          }
          break;
        
        case 'MENSUAL':
          // Continuar sumando meses hasta que esté en el futuro
          var mesActual = proximaFecha.month;
          var anoActual = proximaFecha.year;
          var diaOriginal = proximaFecha.day;

          while (proximaFecha.isBefore(hoy)) {
            mesActual++;
            if (mesActual > 12) {
              mesActual = 1;
              anoActual++;
            }
            try {
              proximaFecha = DateTime(anoActual, mesActual, diaOriginal);
            } catch (_) {
              // Si el día no existe en ese mes (ej: 31 febrero), usar último día del mes
              proximaFecha = DateTime(anoActual, mesActual + 1, 0);
              mesActual++;
            }
          }
          break;
      }
    }

    return proximaFecha;
  }

  String _getEstadoBadgeText(String? estado) {
    if (estado == null) return 'DESCONOCIDO';
    switch (estado.toUpperCase()) {
      case 'ACTIVO':
        return 'ACTIVO';
      case 'PAUSADO':
        return 'PAUSADO';
      case 'CANCELADO':
        return 'CANCELADO';
      default:
        return estado;
    }
  }

  Color _getEstadoColor(String? estado) {
    if (estado == null) return Colors.grey;
    switch (estado.toUpperCase()) {
      case 'ACTIVO':
        return green;
      case 'PAUSADO':
        return orange;
      case 'CANCELADO':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras Recurrentes'),
        backgroundColor: green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _cargarCompras,
                        style: ElevatedButton.styleFrom(backgroundColor: green),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _comprasRecurrentes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.repeat, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No hay compras recurrentes',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Cuando los clientes creen compras recurrentes,\naparecerán aquí',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _cargarCompras,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _comprasRecurrentes.length,
                        itemBuilder: (context, index) {
                          final item = _comprasRecurrentes[index];
                          final compra = item['compra'];
                          final producto = item['producto'];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Encabezado con nombre del producto y estado
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              producto?.nome ?? 'Producto desconocido',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (producto != null)
                                              Text(
                                                'ID: ${producto.id}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getEstadoColor(compra.estado),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          _getEstadoBadgeText(compra.estado),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 16),

                                  // Información de cantidad y precio
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Cantidad',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${compra.cantidade} unidades',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Precio unitario',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          if (producto != null)
                                            Text(
                                              '€${(producto.prezo ?? 0.0).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: green,
                                              ),
                                            )
                                          else
                                            Text(
                                              'N/A',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Información de frecuencia
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: lightGreen,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.repeat, color: green, size: 16),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Frecuencia',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              _formatFrecuencia(compra.frecuencia),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              (compra.estado?.toUpperCase() == 'ACTIVO' && 
                                               compra.dataInicio != null && 
                                               compra.dataInicio!.isBefore(DateTime.now()))
                                                  ? 'Próxima entrega'
                                                  : 'Inicio',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              compra.dataInicio != null
                                                  ? DateFormat('dd/MM/yyyy').format(
                                                      _calcularProximaFecha(compra.dataInicio, compra.frecuencia, compra.estado) ?? compra.dataInicio!
                                                    )
                                                  : 'N/A',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // ID de cliente
                                  Text(
                                    'Cliente ID: ${compra.clienteId}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
