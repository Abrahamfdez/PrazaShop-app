import 'package:flutter/material.dart';
import 'package:praza_shop/models/cliente_dto.dart';
import 'package:praza_shop/models/usuario_dto.dart';
import 'package:praza_shop/models/role.dart';
import 'package:praza_shop/services/api_service.dart';
import 'package:praza_shop/services/cliente_service.dart';
import 'package:praza_shop/utils/api_utils.dart';
import 'package:praza_shop/widgets/user_type_option.dart';

/// Página de registro con todos los campos de `UsuarioDto` excepto `id`.
///
/// - Construye un `UsuarioDto` al enviar y llama a `onRegister` si se proporciona.
class RegisterPage extends StatefulWidget {
  final ApiService api;
  const RegisterPage({super.key, required this.api});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // Campos comunes a todos los roles
  final _nomeCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _telefonoCtl = TextEditingController();
  // Campos específicos para Cliente y Negocio
  final _clienteDireccionCtl = TextEditingController();
  final _negocioNombreCtl = TextEditingController();
  final _negocioDireccionCtl = TextEditingController();
  final _negocioDescricionCtl = TextEditingController();

  Role _selectedRole = Role.CLIENTE;
  bool _loading = false;
  late final ClienteService clienteService = ClienteService(widget.api);

  @override
  void dispose() {
    _nomeCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    _telefonoCtl.dispose();
    _clienteDireccionCtl.dispose();
    _negocioNombreCtl.dispose();
    _negocioDireccionCtl.dispose();
    _negocioDescricionCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final usuario = UsuarioDto(
      nome: _nomeCtl.text.trim(),
      email: _emailCtl.text.trim(),
      contrasinal: _passCtl.text,
      telefono: _telefonoCtl.text.trim(),
      tipoUsuario: _selectedRole,
    );

    try {
          // Añadir campos según rol seleccionado
         var payload = usuario.toJson();
          // Enviar registro
        var response = await widget.api.register(payload);
        var usuarioCreado=await ApiUtils.getUserFromToken(widget.api, response.accessToken);
        switch (usuarioCreado.tipoUsuario) {
          case Role. CLIENTE:
          var clienteCreated=ClienteDto(
            usuarioId: usuarioCreado.id,
            direccionEnvio: _clienteDireccionCtl.text.trim(),
          );
            await clienteService.create(clienteCreated);
            print("Usuario registrado como CLIENTE");
             break;
          case Role.NEGOCIO:    
            print("Usuario registrado como NEGOCIO");
             break; 
          case Role.ADMIN:      
            print("Usuario registrado como ADMIN");
             break; 
            case Role.DESCONOCIDO:  
            print("Usuario registrado con rol DESCONOCIDO");
            break;
          default:
            print("Usuario registrado con rol desconocido");
        }
      

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro enviado')));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF10A75A);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.eco, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 12),
                const Text('PrazaShop', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Únete a PrazaShop', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      const SizedBox(height: 4),
                      const Text('Tipo de usuario', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: UserTypeOption(
                              label: 'Cliente',
                              icon: Icons.person,
                              selected: _selectedRole == Role.CLIENTE,
                              onTap: () => setState(() => _selectedRole = Role.CLIENTE),
                              color: green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: UserTypeOption(
                              label: 'Negocio',
                              icon: Icons.store,
                              selected: _selectedRole == Role.NEGOCIO,
                              onTap: () => setState(() => _selectedRole = Role.NEGOCIO),
                              color: green,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Text('Nome completo', style: TextStyle(fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nomeCtl,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Introduce o teu nome' : null,
                      ),

                      const SizedBox(height: 12),
                      const Text('Email', style: TextStyle(fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailCtl,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Introduce o teu correo';
                          final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+");
                          if (!emailRegex.hasMatch(v.trim())) return 'Email non válido';
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),
                      const Text('Contrasinal', style: TextStyle(fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passCtl,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Introduce a túa contrasinal';
                          if (v.length < 8) return 'A contrasinal debe ter polo menos 8 caracteres';
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),
                      const Text('Teléfono', style: TextStyle(fontSize: 13, color: Colors.black87)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _telefonoCtl,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 12),

                      // Campos específicos para Cliente
                      if (_selectedRole == Role.CLIENTE) ...[
                        const Text('Dirección', style: TextStyle(fontSize: 13, color: Colors.black87)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _clienteDireccionCtl,
                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Introduce la dirección' : null,
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Campos específicos para Negocio
                      if (_selectedRole == Role.NEGOCIO) ...[
                        const Text('Nombre del negocio', style: TextStyle(fontSize: 13, color: Colors.black87)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _negocioNombreCtl,
                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Introduce el nombre del negocio' : null,
                        ),
                        const SizedBox(height: 12),
                        const Text('Dirección del negocio', style: TextStyle(fontSize: 13, color: Colors.black87)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _negocioDireccionCtl,
                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Introduce la dirección del negocio' : null,
                        ),
                        const SizedBox(height: 12),
                        const Text('Descrición', style: TextStyle(fontSize: 13, color: Colors.black87)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _negocioDescricionCtl,
                          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                      ],

                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Crear conta'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ]
          ),
        ),
      ),
    )
    );
  }
}