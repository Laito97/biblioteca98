import 'package:flutter/material.dart';

class EditorialRegisterScreen extends StatefulWidget {
  const EditorialRegisterScreen({Key? key}) : super(key: key);

  @override
  State<EditorialRegisterScreen> createState() => _EditorialRegisterScreenState();
}

class _EditorialRegisterScreenState extends State<EditorialRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _registrarEditorial() {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text.trim();
      // Aquí puedes agregar la lógica para enviar datos a la API o base de datos
      print('Editorial registrada: $nombre');

      // Mostrar mensaje o navegar atrás
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Editorial "$nombre" registrada correctamente')),
      );
      Navigator.pop(context);
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
                // Imagen arriba del formulario
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
