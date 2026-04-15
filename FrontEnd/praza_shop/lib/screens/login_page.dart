import 'package:flutter/material.dart';
import 'package:praza_shop/models/role.dart';
import 'package:praza_shop/models/usuario_dto.dart';
import 'package:praza_shop/screens/register_page.dart';
import 'package:praza_shop/utils/api_utils.dart';
import '../services/api_service.dart';



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
  

  @override
  void dispose() {
    // Libera los controladores para evitar fugas de memoria.
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }
  Future<void> _performLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailCtl.text.trim();
      final password = _passCtl.text;
      try {
        // Aquí se llamaría a AuthUtils.performLoginAndGetInfo para realizar el login
        // y obtener el rol del usuario, luego navegar a la pantalla correspondiente.
        var response=await widget.api.login(email, password);
        var usuario=await ApiUtils.getUserFromToken(widget.api, response.accessToken);
        switch (usuario.tipoUsuario) {
          case Role.CLIENTE:
            print("Navigate to cliente home page");
             // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ClienteHomePage(api: widget.api, usuario: usuario)));
             break;
            case Role.NEGOCIO:
            print("Navigate to negocio home page");
             // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NegocioHomePage(api: widget.api, usuario: usuario)));
             break; 
          case Role.ADMIN:
            print("Navigate to admin dashboard");
             // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AdminDashboard(api: widget.api, usuario: usuario)));
            break;
          default:
            print("Navigate to generic home page");
             // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage(api: widget.api, usuario: usuario)));
        }
      
      } catch (e) {
        // Mostrar un error genérico en caso de fallo.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')));
      }
    }
  }

  // Login logic removed from the screen; keep UI only.

  @override
  Widget build(BuildContext context) {
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
                              onPressed: () => print("Navigate to forgot password page"), // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ForgotPasswordPage(api: widget.api))),
                              child: Text('Esqueciches o contrasinal?', style: TextStyle(color: green)),
                            ),
                          ),

                          const SizedBox(height: 8),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              onPressed: () {
                                _performLogin();
                              },
                              child: const Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: TextButton(
                              onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegisterPage(api: widget.api))),
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
