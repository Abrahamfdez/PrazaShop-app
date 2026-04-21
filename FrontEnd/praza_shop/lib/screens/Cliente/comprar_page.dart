import 'package:flutter/material.dart';
import 'package:praza_shop/models/detalle_pedido_dto.dart';
import 'package:praza_shop/models/pedido_dto.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/models/negocio_dto.dart';
import 'package:praza_shop/screens/Cliente/valoracion_compra_page.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/cliente_service.dart';
import 'package:praza_shop/services/detalle_pedido_service.dart';
import 'package:praza_shop/services/negocio_service.dart';
import 'package:praza_shop/services/pedido_service.dart';
import 'package:praza_shop/utils/api_utils.dart';
import 'package:praza_shop/widgets/producto_carrito_card.dart';
import 'package:praza_shop/widgets/cantidad_selector.dart';
import 'package:praza_shop/widgets/resumen_pedido.dart';

/// Página de confirmación de compra (checkout)
class ComprarPage extends StatefulWidget {
  final ProductoDto producto;
  final NegocioDto? negocio;
  final ApiService api;

  const ComprarPage({
    super.key,
    required this.producto,
    this.negocio,
    required this.api,
  });

  @override
  State<ComprarPage> createState() => _ComprarPageState();
}

class _ComprarPageState extends State<ComprarPage> {
  late int _cantidad;
  late NegocioService _negocioService;
  NegocioDto? _negocio;
  bool _isLoading = false;

  static const double GASTOS_ENVIO = 0.0; // Gratis

  @override
  void initState() {
    super.initState();
    _cantidad = 1;
    _negocio = widget.negocio;
    _negocioService = NegocioService(widget.api);

    // Si no tenemos el negocio, lo cargamos
    if (_negocio == null && widget.producto.negocioId != null) {
      _cargarNegocio();
    }
  }

  /// Carga la información del negocio
  Future<void> _cargarNegocio() async {
    setState(() => _isLoading = true);
    try {
      final negocio = await _negocioService.getById(widget.producto.negocioId!);
      setState(() {
        _negocio = negocio;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar negocio: $e');
      setState(() => _isLoading = false);
    }
  }

  /// Calcula el subtotal
  double get _subtotal => (_cantidad * (widget.producto.prezo ?? 0.0));

  /// Calcula el total
  double get _total => _subtotal + GASTOS_ENVIO;

  /// Incrementa la cantidad
  void _incrementarCantidad() {
    final maxStock = widget.producto.stock ?? 0;
    if (_cantidad < maxStock) {
      setState(() => _cantidad++);
    }
  }

  /// Decrementa la cantidad
  void _decrementarCantidad() {
    if (_cantidad > 1) {
      setState(() => _cantidad--);
    }
  }

  /// Confirma la compra
  Future<void> _confirmarCompra() async {
    try{
    // Obtener usuario actual
    final usuario = await ApiUtils.getUserFromToken(widget.api, widget.api.token);
    
    // Obtener cliente asociado al usuario
    final cliente = await ClienteService(widget.api).getByUsuarioId(usuario.id!);
    
    // Crear el pedido
    PedidoDto pedido = PedidoDto(
      negocioId: widget.producto.negocioId!,
      clienteId: cliente.id!,
      total: _total,
      estado: 'PENDIENTE',
      dataCancelacion: null,
      dataConfirmacion: null,
      dataEntrega: null,
      dataPedido: DateTime.now(),
    );

    var pedidoCreated=await PedidoService(widget.api).create(pedido);
    
    // Crear el detalle del pedido
    DetallePedidoDto detalle = DetallePedidoDto(
      productoId: widget.producto.id!,
      cantidade: _cantidad,
      prezoUnitario: widget.producto.prezo ?? 0.0,
      pedidoId: pedidoCreated.id!, 
    );
    var detalleCreated=await DetallePedidoService(widget.api).create(detalle);
    // TODO: Implementar lógica de compra con API
    Navigator.of(context).pop();
    // Navegar a la página de valoración
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ValoracionCompraPage(
          pedido: pedidoCreated,
          producto: widget.producto,
          negocio: _negocio ?? NegocioDto(),
          api: widget.api,
        ),
      ),
    );
    }catch(e){
      print('Error al confirmar compra: $e');
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Compra de $_cantidad ${_cantidad == 1 ? 'unidad' : 'unidades'} confirmada. Total: ${_total.toStringAsFixed(2)}€',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    
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
          'Confirmar compra',
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Producto
                        ProductoCarritoCard(
                          producto: widget.producto,
                          negocio: _negocio,
                        ),

                        const SizedBox(height: 24),

                        // Cantidad
                        CantidadSelector(
                          cantidad: _cantidad,
                          onIncrementar: _incrementarCantidad,
                          onDecrementar: _decrementarCantidad,
                          puedeIncrementar:
                              (_cantidad < (widget.producto.stock ?? 0)),
                        ),

                        const SizedBox(height: 24),

                        // Resumen del pedido
                        ResumenPedido(
                          subtotal: _subtotal,
                          gastosEnvio: GASTOS_ENVIO,
                          total: _total,
                        ),

                        const SizedBox(height: 32),

                        // Botón de confirmación
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
                            onPressed: _confirmarCompra,
                            child: const Text(
                              'Confirmar compra',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
