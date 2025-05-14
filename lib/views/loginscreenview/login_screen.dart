import 'package:flutter/material.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'package:biblioteca97/models_ant/admin_usuario_response.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart';
import '../../services/api_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController(text: 'jruelasrojas');
  final _contrasenaController = TextEditingController(text: 'pablo123');
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService(client: ApiClient());

  bool isLoading = false;

  void _login() async {

    final usuario = _usuarioController.text.trim();
    final contrasena = _contrasenaController.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      _mostrarError("Verifica que no existan campos vacíos");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await apiService.loginV2(usuario, contrasena);

      setState(() => isLoading = false);

      if (response != null && response.responseCode == 200) {
        final nombre = response.usuario?.persona?.nombres;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => NavegacionScreen(nombreUsuario: nombre ?? 'Sin Nombre'),
          ),
        );
      } else {
        final mensaje = response?.message ?? "Error desconocido";
        _mostrarError(mensaje);
      }

    } catch (e) {
      setState(() => isLoading = false);
      _mostrarError("Hubo un error al intentar iniciar sesión. Intenta nuevamente.");
    }
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/user_card_3.png',
                    width: 200,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "AdminBibliotecaApp",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _usuarioController,
                    decoration: const InputDecoration(
                      labelText: '* Usuario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _contrasenaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: '* Contraseña',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Iniciar Sesión"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
