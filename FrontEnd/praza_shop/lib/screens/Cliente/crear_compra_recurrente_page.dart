import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praza_shop/models/producto_dto.dart';
import 'package:praza_shop/models/negocio_dto.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/compra_recorrente_service.dart';

class CrearCompraRecurrentePage extends StatefulWidget {
  final ProductoDto producto;
  final NegocioDto negocio;
  final ApiService api;

  const CrearCompraRecurrentePage({
    super.key,
    required this.producto,
    required this.negocio,
    required this.api,
  }) : super();

  @override
  State<CrearCompraRecurrentePage> createState() => _CrearCompraRecurrentePageState();
}

class _CrearCompraRecurrentePageState extends State<CrearCompraRecurrentePage> {
  static const Color green = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFFE8F5E9);

  late CompraRecorrenteService _compraService;
  final _cantidadController = TextEditingController(text: '1');
  DateTime? _fechaInicio;
  String _frecuencia = 'MENSUAL';
  bool _isLoading = false;

  final List<String> frecuencias = ['DIARIO', 'SEMANAL', 'QUINCENAL', 'MENSUAL'];

  @override
  void initState() {
    super.initState();
    _compraService = CompraRecorrenteService(widget.api);
    _fechaInicio = DateTime.now();
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _fechaInicio) {
      setState(() {
        _fechaInicio = picked;
      });
    }
  }

  Future<void> _crearCompraRecurrente() async {
    if (_cantidadController.text.isEmpty || int.parse(_cantidadController.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La cantidad debe ser mayor a 0')),
      );
      return;
    }

    if (_fechaInicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar una fecha de inicio')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _compraService.crearMiCompraRecurrente(
        productoId: widget.producto.id!,
        cantidade: int.parse(_cantidadController.text),
        frecuencia: _frecuencia,
        dataInicio: _fechaInicio!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compra recurrente creada exitosamente'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compra Recurrente'),
        backgroundColor: green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del producto
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.producto.nome ?? 'Producto',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.negocio.nomeNegocio ?? 'Negocio',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '€${(widget.producto.prezo ?? 0.0).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: green,
                        ),
                      ),
                      if ((widget.producto.stock ?? 0) > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${widget.producto.stock} en stock',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cantidad
            const Text(
              'Cantidad por entrega',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      final valor = int.tryParse(_cantidadController.text) ?? 1;
                      if (valor > 1) {
                        _cantidadController.text = (valor - 1).toString();
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '1',
                      ),
                      onChanged: (value) {
                        if (value.isEmpty || int.tryParse(value) == null) {
                          _cantidadController.text = '1';
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final valor = int.tryParse(_cantidadController.text) ?? 1;
                      _cantidadController.text = (valor + 1).toString();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Frecuencia
            const Text(
              'Frecuencia de entrega',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _frecuencia,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _frecuencia = newValue);
                  }
                },
                items: frecuencias.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Fecha de inicio
            const Text(
              'Fecha de inicio',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _seleccionarFecha(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _fechaInicio != null
                          ? DateFormat('dd/MM/yyyy').format(_fechaInicio!)
                          : 'Seleccionar fecha',
                      style: TextStyle(
                        fontSize: 14,
                        color: _fechaInicio != null ? Colors.black : Colors.grey,
                      ),
                    ),
                    const Icon(Icons.calendar_today, color: green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Resumen
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Resumen',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cantidad por entrega:'),
                      Text(
                        '${_cantidadController.text} unidades',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Frecuencia:'),
                      Text(
                        _frecuencia.toLowerCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Próxima entrega:'),
                      Text(
                        _fechaInicio != null
                            ? DateFormat('dd/MM/yyyy').format(_fechaInicio!)
                            : 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Precio por entrega:'),
                      Text(
                        '€${((widget.producto.prezo ?? 0.0) * int.parse(_cantidadController.text)).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: green,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botón crear
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
                onPressed: _isLoading ? null : _crearCompraRecurrente,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Crear Compra Recurrente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Botón cancelar
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
