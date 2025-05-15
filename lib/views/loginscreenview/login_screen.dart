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
  final _contrasenaController = TextEditingController(text: '123');
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService(client: ApiClient());

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
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
                Text(
                  "Bienvenido al App Biblioteca",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 19, 19, 19),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Ingresa tus credenciales",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(221, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 50),

                // CAMPO USUARIO
                TextFormField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    hintText: 'Usuario',
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    errorStyle: TextStyle(color: Colors.red),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa tu usuario';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // CAMPO CONTRASEÑA
                TextFormField(
                  controller: _contrasenaController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    errorStyle: TextStyle(color: Colors.red),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // BOTÓN INGRESAR
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    child: const Text(
                      'INGRESAR',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ENLACE OLVIDÓ CONTRASEÑA
                TextButton(
                  onPressed: () {
                    // Acción de "Forgot password"
                  },
                  child: Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    final usuario = _usuarioController.text.trim();
    final contrasena = _contrasenaController.text.trim();

    if (usuario.isEmpty || contrasena.isEmpty) {
      _mostrarError("Verifica que no existan campos vacíos");
      return;
    }

    _mostrarCarga();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final response = await apiService.loginV2(usuario, contrasena);

      Navigator.of(context).pop(); 

      if (response != null && response.responseCode == 200) {
        final nombre = response.usuario?.persona?.nombres;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => NavegacionScreen(nombreUsuario: nombre ?? 'Sin Nombre'),
          ),
        );
      } else {
        final mensaje = response?.message ?? "Error desconocido";
        _mostrarError(mensaje);
      }
    } catch (e) {
      Navigator.of(context).pop(); // Cierra la animación
      _mostrarError(
        "Hubo un error al intentar iniciar sesión. Intenta nuevamente.",
      );
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cerrar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _mostrarCarga() {
    showDialog(
      context: context,
      barrierDismissible: false, // impide cerrar tocando fuera del diálogo
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Colors.red),
                const SizedBox(width: 20),
                const Text("Iniciando sesión..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
