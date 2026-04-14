import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/auth_utils.dart';
import 'register_page.dart';


/// Página de inicio de sesión que usa un `ApiService` para autenticar.
class LoginPage extends StatefulWidget {
  final ApiService api;
  const LoginPage({super.key, required this.api});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// Estado de `LoginPage` que gestiona el formulario, controladores y lógica
/// de envío (login).
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    // Libera los controladores para evitar fugas de memoria.
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Valida el formulario y realiza el login usando `AuthUtils`.
    // Gestiona el estado de carga y la navegación tras el login.
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final role = await AuthUtils.performLoginAndGetInfo(widget.api, _emailCtl.text, _passCtl.text);
      if (!mounted) return;
      String infoText;
      switch (role) {
        case UserRole.CLIENTE:
          infoText = 'Cliente';
          break;
        case UserRole.NEGOCIO:
          infoText = 'Negocio';
          break;
        case UserRole.ADMIN:
          infoText = 'Admin';
          break;
        default:
          infoText = 'Desconocido';
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Login successful! $infoText')))));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error : $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario de la pantalla de login.
    // Contiene el formulario de email/contraseña y el botón de envío.
    final green = const Color(0xFF10A75A);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.eco, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text('PrazaShop', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Benvido de volta', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                const SizedBox(height: 28),

                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email
                          const Text('Email', style: TextStyle(fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailCtl,
                            decoration: InputDecoration(
                              hintText: 'tucorreo@ejemplo.com',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) => (v == null || v.isEmpty) ? 'Introduce o teu correo' : null,
                          ),
                          const SizedBox(height: 16),

                          // Password
                          const Text('Contrasinal', style: TextStyle(fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passCtl,
                            decoration: InputDecoration(
                              hintText: 'Introduce o teu contrasinal',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            obscureText: true,
                            validator: (v) => (v == null || v.isEmpty) ? 'Introduce a túa contrasinal' : null,
                          ),

                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text('Esqueciches o contrasinal?', style: TextStyle(color: green)),
                            ),
                          ),

                          const SizedBox(height: 8),
                          _loading
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    onPressed: _submit,
                                    child: const Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterPage(api: widget.api))),
                              child: Text('Non tes conta? Rexistrate', style: TextStyle(color: green)),
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
