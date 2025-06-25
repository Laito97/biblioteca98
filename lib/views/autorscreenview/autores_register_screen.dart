import 'package:biblioteca97/models/autor.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import 'package:biblioteca97/utils/usuario_provider.dart';
import 'package:provider/provider.dart';

class AutoresRegisterScreen extends StatefulWidget {
  final Autor? autorEditar;

  const AutoresRegisterScreen({Key? key, this.autorEditar}) : super(key: key);

  @override
  State<AutoresRegisterScreen> createState() => _AutoresRegisterScreenState();
}

class _AutoresRegisterScreenState extends State<AutoresRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreAutorController = TextEditingController();
  late ApiService _apiService;

  bool get isEditMode => widget.autorEditar != null;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());

    if (isEditMode) {
      _nombreAutorController.text = widget.autorEditar!.autor_nom ?? '';
    }
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
                if (mensaje.contains('éxito')) {
                  Navigator.of(context).pop(); // Salir de la pantalla tras éxito
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _guardarAutor() async {
    if (!_formKey.currentState!.validate()) return;

    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final usuarioId = usuarioProvider.usuario?.usuarioId;

    // Crear objeto Autor con los campos necesarios para el backend
    Autor autor = Autor(
      autor_id: widget.autorEditar?.autor_id,
      autor_nom: _nombreAutorController.text.trim(),
      usuario_creacion_id: usuarioId,
    );

    try {
      bool resultado = await _apiService.registrarAutorV2(autor);

      _showDialog(
        resultado
            ? (isEditMode ? "Autor actualizado con éxito" : "Autor registrado con éxito")
            : (isEditMode ? "No se pudo actualizar el autor" : "No se pudo registrar el autor"),
      );

      if (resultado && !isEditMode) {
        _nombreAutorController.clear();
      }
    } catch (e) {
      _showDialog("Error: $e");
    }
  }

  @override
  void dispose() {
    _nombreAutorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = isEditMode ? "Editar Autor" : "Registrar Autor";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                Image.asset(
                  'assets/agregar_usuario.png',
                  width: 200,
                  height: 120,
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
                    onPressed: _guardarAutor,
                    child: Text(
                      isEditMode ? 'ACTUALIZAR AUTOR' : 'REGISTRAR AUTOR',
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
