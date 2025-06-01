import 'package:flutter/material.dart';

class RegistrarLibroScreen extends StatefulWidget {
  const RegistrarLibroScreen({Key? key}) : super(key: key);

  @override
  State<RegistrarLibroScreen> createState() => _RegistrarLibroScreenState();
}

class _RegistrarLibroScreenState extends State<RegistrarLibroScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _edicionController = TextEditingController();
  final TextEditingController _existenciasController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();

  final List<String> autores = ['Autor 1', 'Autor 2', 'Autor 3'];
  final List<String> categorias = ['Categoría 1', 'Categoría 2', 'Categoría 3'];
  final List<String> editoriales = ['Editorial 1', 'Editorial 2', 'Editorial 3'];

  String? _selectedAutor;
  String? _selectedCategoria;
  String? _selectedEditorial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Libro'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Imagen igual que en CategoriaRegisterScreen
              Image.asset(
                'assets/agregar_usuario.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),

              _buildTextField(_nombreController, 'Nombre del libro', Icons.book),

              const SizedBox(height: 10),

              _buildTextField(
                _anioController,
                'Año de publicación',
                Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 10),

              _buildTextField(_descripcionController, 'Descripción', Icons.description),

              const SizedBox(height: 10),

              _buildTextField(_edicionController, 'Edición', Icons.edit),

              const SizedBox(height: 10),

              _buildTextField(
                _existenciasController,
                'Existencias',
                Icons.storage,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 10),

              _buildTextField(_isbnController, 'ISBN', Icons.confirmation_num),

              const SizedBox(height: 10),

              _buildDropdown(
                label: 'Autor',
                items: autores,
                value: _selectedAutor,
                onChanged: (val) {
                  setState(() {
                    _selectedAutor = val;
                  });
                },
              ),

              const SizedBox(height: 10),

              _buildDropdown(
                label: 'Categoría',
                items: categorias,
                value: _selectedCategoria,
                onChanged: (val) {
                  setState(() {
                    _selectedCategoria = val;
                  });
                },
              ),

              const SizedBox(height: 10),

              _buildDropdown(
                label: 'Editorial',
                items: editoriales,
                value: _selectedEditorial,
                onChanged: (val) {
                  setState(() {
                    _selectedEditorial = val;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Aquí procesarías el registro
                      print('Libro registrado: ${_nombreController.text}');
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'REGISTRAR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Por favor ingresa $hint';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: const Icon(Icons.list),
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
      items: items.map((item) => DropdownMenuItem(child: Text(item), value: item)).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor selecciona $label';
        }
        return null;
      },
    );
  }
}
