import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/user_type_option.dart';
import '../widgets/business_info_dialog.dart';
import '../models/cliente.dart';
import '../models/negocio.dart';
import '../services/cliente_service.dart';
import '../services/negocio_service.dart';
import '../utils/auth_utils.dart';
import '../utils/auth_utils.dart';

/// Página de registro para crear una nueva cuenta.
class RegisterPage extends StatefulWidget {
  final ApiService? api;
  const RegisterPage({super.key, this.api});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum _RegisterUserType { CLIENTE, NEGOCIO }

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _addressCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  _RegisterUserType _type = _RegisterUserType.CLIENTE;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtl.dispose();
    _phoneCtl.dispose();
    _addressCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      // Si es tipo NEGOCIO, primero pedir información adicional del negocio
      Map<String, String>? negocioInfo;
      if (_type == _RegisterUserType.NEGOCIO) {
        negocioInfo = await showDialog<Map<String, String>>(
          context: context,
          builder: (ctx) => const BusinessInfoDialog(),
        );

        // Si el usuario canceló el diálogo, abortar el envío
        if (negocioInfo == null) {
          if (mounted) setState(() => _loading = false);
          return;
        }
      }

      // Construir el payload para el endpoint de registro
      final name = _nameCtl.text.trim();
      final email = _emailCtl.text.trim();
      final password = _passCtl.text;
      final address = _addressCtl.text.trim();

      final phone = _phoneCtl.text.trim();
      final Map<String, dynamic> body = {
        'nome': name,
        'email': email,
        'contrasinal': password,
        'telefono': phone.isNotEmpty ? phone : null,
        'tipoUsuario': _type == _RegisterUserType.CLIENTE ? 'CLIENTE' : 'NEGOCIO',
      };
      if (_type == _RegisterUserType.CLIENTE) body['direccion'] = address;
      if (_type == _RegisterUserType.NEGOCIO && negocioInfo != null) {
        body['nombreNegocio'] = negocioInfo['bizName'];
        body['direccionNegocio'] = negocioInfo['bizAddress'];
      }

      if (widget.api == null) throw Exception('ApiService no disponible');

      // Llamar a la utilidad que registra y devuelve el rol detectado
      final role = await AuthUtils.registerAndGetRole(widget.api!, body);
      if (!mounted) return;

      // Ahora crear el recurso asociado (Cliente o Negocio) usando el token
      try {
        if (role == UserRole.CLIENTE) {
          final cliente = Cliente(
            nome: name,
            email: email,
            telefono: null,
            direccion: address.isNotEmpty ? address : null,
          );
          await ClienteService(widget.api!).create(cliente);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro completado y cliente creado')));
        } else if (role == UserRole.NEGOCIO) {
          final bizName = negocioInfo?['bizName'] ?? '';
          final bizAddress = negocioInfo?['bizAddress'];
          final negocio = Negocio(
            nome: bizName,
            descricion: null,
            direccion: bizAddress,
            telefono: null,
            propietarioId: null,
            estado: null,
          );
          await NegocioService(widget.api!).create(negocio);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro completado y negocio creado')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro completado')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registro OK pero fallo al crear recurso: $e')));
      }

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Replaced by reusable `UserTypeOption` widget in the build method.

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF10A75A);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.eco, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 12),
                const Text('Crear Conta', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Únete a PrazaShop', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                const SizedBox(height: 18),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Tipo de usuario', style: TextStyle(fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: UserTypeOption(
                                  label: 'Cliente',
                                  icon: Icons.person,
                                  selected: _type == _RegisterUserType.CLIENTE,
                                  onTap: () => setState(() => _type = _RegisterUserType.CLIENTE),
                                  color: green,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: UserTypeOption(
                                  label: 'Negocio',
                                  icon: Icons.store,
                                  selected: _type == _RegisterUserType.NEGOCIO,
                                  onTap: () => setState(() => _type = _RegisterUserType.NEGOCIO),
                                  color: green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Text(_type == _RegisterUserType.NEGOCIO ? 'Nombre del dueño' : 'Nome completo', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameCtl,
                            decoration: InputDecoration(hintText: _type == _RegisterUserType.NEGOCIO ? 'Nombre del dueño' : 'O teu nome', contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            validator: (v) => (v == null || v.isEmpty) ? (_type == _RegisterUserType.NEGOCIO ? 'Introduce el nombre del dueño' : 'Introduce o teu nome') : null,
                          ),
                          const SizedBox(height: 12),

                          const Text('Teléfono', style: TextStyle(fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _phoneCtl,
                            decoration: InputDecoration(hintText: 'Número de teléfono', contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            keyboardType: TextInputType.phone,
                            validator: (v) => (v == null || v.isEmpty) ? 'Introduce un teléfono' : null,
                          ),
                          const SizedBox(height: 12),

                          // Campo 'Dirección' solo para clientes
                          if (_type == _RegisterUserType.CLIENTE) ...[
                            const Text('Dirección', style: TextStyle(fontSize: 13, color: Colors.black87)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _addressCtl,
                              decoration: InputDecoration(hintText: 'Tu dirección', contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                              validator: (v) => (_type == _RegisterUserType.CLIENTE && (v == null || v.isEmpty)) ? 'Introduce la dirección' : null,
                            ),
                            const SizedBox(height: 12),
                          ],

                          const Text('Email', style: TextStyle(fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailCtl,
                            decoration: InputDecoration(hintText: 'tucorreo@ejemplo.com', contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v == null || !v.contains('@')) ? 'Introduce un email válido' : null,
                          ),
                          const SizedBox(height: 12),

                          const Text('Contrasinal', style: TextStyle(fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passCtl,
                            decoration: InputDecoration(hintText: 'Mínimo 8 caracteres', contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                            obscureText: true,
                            validator: (v) => (v == null || (v.length < 8)) ? 'La contraseña debe tener al menos 8 caracteres' : null,
                          ),

                          const SizedBox(height: 18),
                          _loading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    onPressed: _submit,
                                    child: const Text('Crear conta', style: TextStyle(fontSize: 16)),
                                  ),
                                ),

                          const SizedBox(height: 14),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Xa tes conta? Inicia sesión', style: TextStyle(color: green)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
