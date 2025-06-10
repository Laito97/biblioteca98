import 'package:biblioteca97/models/autor.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import 'package:biblioteca97/utils/usuario_provider.dart';
import 'package:provider/provider.dart';

class AutoresRegisterScreen extends StatefulWidget {
  const AutoresRegisterScreen({Key? key}) : super(key: key);

  @override
  State<AutoresRegisterScreen> createState() => _AutoresRegisterScreenState();
}

class _AutoresRegisterScreenState extends State<AutoresRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreAutorController = TextEditingController();
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
  }

  void _showDialog(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Aviso"),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Nota: No obtenemos usuarioLogged aquí porque lo usaremos solo en el botón

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Registrar Autor"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/agregar_usuario.png', width: 200, height: 120),
                const SizedBox(height: 10),
                const Text(
                  "Registro de Autor",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 19, 19, 19),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nombreAutorController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingrese el nombre del autor';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Nombre del autor',
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
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
                    onPressed: () async {
                      print("✅ Botón REGISTRAR AUTOR presionado");

                      if (_formKey.currentState!.validate()) {
                        // Obtenemos usuarioLogged aquí, asegurando que esté actualizado
                        final usuarioLogged = Provider.of<UsuarioProvider>(context, listen: false).usuario;

                        if (usuarioLogged == null) {
                          _showDialog("Error: Usuario no autenticado.");
                          return;
                        }

                        print("🔑 Usuario logueado: ${usuarioLogged.usuarioId}");

                        final autor = Autor(
                          autor_nom: _nombreAutorController.text,
                          usuario_creacion_id: usuarioLogged.usuarioId,
                        );

                        try {
                          bool registrado = await _apiService.registrarAutorV2(autor);
                          _showDialog(
                            registrado
                                ? "Autor registrado con éxito"
                                : "No se pudo registrar el autor",
                          );
                          if (registrado) _nombreAutorController.clear();
                        } catch (e) {
                          _showDialog("Error: $e");
                        }
                      }
                    },
                    child: const Text(
                      'REGISTRAR AUTOR',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
