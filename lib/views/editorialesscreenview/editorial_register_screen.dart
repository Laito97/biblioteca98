import 'package:flutter/material.dart';
import 'package:biblioteca97/models/editorial.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'package:biblioteca97/services/api_client.dart';

class EditorialRegisterScreen extends StatefulWidget {
  const EditorialRegisterScreen({Key? key}) : super(key: key);

  @override
  State<EditorialRegisterScreen> createState() => _EditorialRegisterScreenState();
}

class _EditorialRegisterScreenState extends State<EditorialRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _registrarEditorial() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text.trim();

      final editorial = Editorial(
        editorial_id: null,
        editorial_nom: nombre,
      );

      final registrado = await _apiService.registrarEditorialV2(editorial);

      if (registrado) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Editorial "$nombre" registrada correctamente')),
        );
        _nombreController.clear();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo registrar la editorial')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Editorial'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    hintText: 'Nombre de la Editorial',
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    prefixIcon: const Icon(Icons.business),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa el nombre de la editorial';
                    }
                    return null;
                  },
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
                    onPressed: _registrarEditorial,
                    child: const Text(
                      'REGISTRAR',
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
