import 'package:flutter/material.dart';

/// Diálogo reutilizable para pedir información del negocio.
///
/// Devuelve `Map<String,String>` con las claves `bizName` y `bizAddress`
/// cuando se confirma, o `null` si se cancela.
class BusinessInfoDialog extends StatefulWidget {
  final String? initialName;
  final String? initialAddress;

  const BusinessInfoDialog({Key? key, this.initialName, this.initialAddress}) : super(key: key);

  @override
  State<BusinessInfoDialog> createState() => _BusinessInfoDialogState();
}

class _BusinessInfoDialogState extends State<BusinessInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bizNameCtl;
  late final TextEditingController _bizAddressCtl;

  @override
  void initState() {
    super.initState();
    _bizNameCtl = TextEditingController(text: widget.initialName ?? '');
    _bizAddressCtl = TextEditingController(text: widget.initialAddress ?? '');
  }

  @override
  void dispose() {
    _bizNameCtl.dispose();
    _bizAddressCtl.dispose();
    super.dispose();
  }

  void _onAccept() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'bizName': _bizNameCtl.text.trim(),
        'bizAddress': _bizAddressCtl.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Información del negocio'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _bizNameCtl,
              decoration: const InputDecoration(labelText: 'Nombre del negocio'),
              validator: (v) => (v == null || v.isEmpty) ? 'Introduce el nombre del negocio' : null,
            ),
            TextFormField(
              controller: _bizAddressCtl,
              decoration: const InputDecoration(labelText: 'Dirección del negocio'),
              validator: (v) => (v == null || v.isEmpty) ? 'Introduce la dirección del negocio' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Cancelar')),
        ElevatedButton(onPressed: _onAccept, child: const Text('Aceptar')),
      ],
    );
  }
}
