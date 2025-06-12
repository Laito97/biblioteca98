import 'package:biblioteca97/utils/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biblioteca97/models/autor.dart';
import 'package:biblioteca97/models/categoria.dart';
import 'package:biblioteca97/models/editorial.dart';
import 'package:biblioteca97/models/libro.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'package:biblioteca97/services/api_client.dart';

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

  List<Autor> _autores = [];
  List<Categoria> _categorias = [];
  List<Editorial> _editoriales = [];

  Autor? _selectedAutor;
  Categoria? _selectedCategoria;
  Editorial? _selectedEditorial;

  late ApiService _apiService;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    try {
      final autores = await _apiService.listAutorV2();
      final categorias = await _apiService.listCategoriasV2();
      final editoriales = await _apiService.listEditorialesV2();

      setState(() {
        _autores = autores;
        _categorias = categorias;
        _editoriales = editoriales;
      });
    } catch (e) {
      print("Error cargando listas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener usuario del provider
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final userId = usuarioProvider.usuario?.usuarioId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Libro'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/agregar_usuario.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(_nombreController, 'Nombre del libro', Icons.book),
                    const SizedBox(height: 10),
                    _buildTextField(_anioController, 'Año de publicación', Icons.calendar_today, keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildTextField(_descripcionController, 'Descripción', Icons.description),
                    const SizedBox(height: 10),
                    _buildTextField(_edicionController, 'Edición', Icons.edit),
                    const SizedBox(height: 10),
                    _buildTextField(_existenciasController, 'Existencias', Icons.storage, keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildTextField(_isbnController, 'ISBN', Icons.confirmation_num),
                    const SizedBox(height: 10),
                    _buildDropdown<Autor>(
                      label: 'Autor',
                      items: _autores,
                      value: _selectedAutor,
                      itemLabel: (autor) => autor.autor_nom ?? 'Autor ${autor.autor_id}',
                      onChanged: (val) => setState(() => _selectedAutor = val),
                    ),
                    const SizedBox(height: 10),
                    _buildDropdown<Categoria>(
                      label: 'Categoría',
                      items: _categorias,
                      value: _selectedCategoria,
                      itemLabel: (cat) => cat.categoria_nom ?? 'Categoría ${cat.categoria_id}',
                      onChanged: (val) => setState(() => _selectedCategoria = val),
                    ),
                    const SizedBox(height: 10),
                    _buildDropdown<Editorial>(
                      label: 'Editorial',
                      items: _editoriales,
                      value: _selectedEditorial,
                      itemLabel: (ed) => ed.editorial_nom ?? 'Editorial ${ed.editorial_id}',
                      onChanged: (val) => setState(() => _selectedEditorial = val),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedAutor == null || _selectedCategoria == null || _selectedEditorial == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Por favor seleccione Autor, Categoría y Editorial')),
                              );
                              return;
                            }
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No se pudo obtener el usuario.')),
                              );
                              return;
                            }

                            setState(() {
                              _loading = true;
                            });

                            final libro = Libro(
                              libro_id: 0,
                              libro_nom: _nombreController.text.trim(),
                              anio_publicacion: _anioController.text.trim(),
                              descripcion: _descripcionController.text.trim(),
                              edicion: _edicionController.text.trim(),
                              existencias: int.tryParse(_existenciasController.text.trim()) ?? 0,
                              isbn: _isbnController.text.trim(),
                              autor: _selectedAutor!,
                              categoria: _selectedCategoria!,
                              editorial: _selectedEditorial!,
                              usuario_creacion_id: userId,
                              usuario_actualizacion_id: userId,
                              fecha_creacion: DateTime.now(),
                              fecha_actualizacion: DateTime.now(),
                              url_portada: '', // o null o lo que corresponda
                            );

                            try {
                              bool success = await _apiService.registrarLibroV2(libro);
                              setState(() {
                                _loading = false;
                              });
                              if (success) {
                                Navigator.of(context).pushReplacementNamed('/libros');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Error al registrar libro')),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                _loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Por favor ingresa $hint' : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown<T>({required String label, required List<T> items, required T? value, required String Function(T) itemLabel, required void Function(T?) onChanged}) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: const Icon(Icons.list),
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
      items: items.map((item) => DropdownMenuItem<T>(child: Text(itemLabel(item)), value: item)).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Por favor selecciona $label' : null,
    );
  }
}
