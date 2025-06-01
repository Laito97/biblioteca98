import 'package:flutter/material.dart';

class CategoriaRegisterScreen extends StatefulWidget {
  const CategoriaRegisterScreen({Key? key}) : super(key: key);

  @override
  State<CategoriaRegisterScreen> createState() => _CategoriaRegisterScreenState();
}

class _CategoriaRegisterScreenState extends State<CategoriaRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _registrarCategoria() {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text.trim();
      // Aquí puedes agregar la lógica para enviar datos a la base de datos o API
      print('Categoría registrada: $nombre');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Categoría "$nombre" registrada correctamente')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Categoría'),
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
                // Misma imagen arriba del formulario
                Image.asset(
                  'assets/agregar_usuario.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    hintText: 'Nombre de la Categoría',
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa el nombre de la categoría';
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
                    onPressed: _registrarCategoria,
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
