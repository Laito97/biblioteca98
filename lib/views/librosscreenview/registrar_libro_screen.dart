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
  final Libro? libroEditar;

  const RegistrarLibroScreen({Key? key, this.libroEditar}) : super(key: key);

  @override
  State<RegistrarLibroScreen> createState() => _RegistrarLibroScreenState();
}

class _RegistrarLibroScreenState extends State<RegistrarLibroScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controllers
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _edicionController = TextEditingController();
  final TextEditingController _existenciasController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();

  // Dropdown data
  List<Autor> _autores = [];
  List<Categoria> _categorias = [];
  List<Editorial> _editoriales = [];

  // Selected values
  Autor? _selectedAutor;
  Categoria? _selectedCategoria;
  Editorial? _selectedEditorial;

  late ApiService _apiService;
  bool _loading = false;
  bool get isEditMode => widget.libroEditar != null;

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

      // Funciones auxiliares para buscar por ID o devolver null
      Autor? findAutorById(int? id) {
        if (id == null) return null;
        try {
          return autores.firstWhere((a) => a.autor_id == id);
        } catch (_) {
          return null;
        }
      }

      Categoria? findCategoriaById(int? id) {
        if (id == null) return null;
        try {
          return categorias.firstWhere((c) => c.categoria_id == id);
        } catch (_) {
          return null;
        }
      }

      Editorial? findEditorialById(int? id) {
        if (id == null) return null;
        try {
          return editoriales.firstWhere((e) => e.editorial_id == id);
        } catch (_) {
          return null;
        }
      }

      setState(() {
        _autores = autores;
        _categorias = categorias;
        _editoriales = editoriales;

        if (isEditMode) {
          final libro = widget.libroEditar!;
          _nombreController.text = libro.libro_nom ?? '';
          _anioController.text = libro.anio_publicacion ?? '';
          _descripcionController.text = libro.descripcion ?? '';
          _edicionController.text = libro.edicion ?? '';
          _existenciasController.text = (libro.existencias ?? 0).toString();
          _isbnController.text = libro.isbn ?? '';

          _selectedAutor = findAutorById(libro.autor?.autor_id);
          _selectedCategoria = findCategoriaById(libro.categoria?.categoria_id);
          _selectedEditorial = findEditorialById(libro.editorial?.editorial_id);
        }
      });
    } catch (e) {
      print("Error cargando listas: $e");
      // Aquí podrías mostrar mensaje de error al usuario
    }
  }

  Future<void> _guardarLibro() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedAutor == null || _selectedCategoria == null || _selectedEditorial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona Autor, Categoría y Editorial')),
      );
      return;
    }

    final userId = Provider.of<UsuarioProvider>(context, listen: false).usuario?.usuarioId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: usuario no identificado')),
      );
      return;
    }

    setState(() => _loading = true);

    Libro libro = Libro(
      libro_id: widget.libroEditar?.libro_id ?? 0,
      libro_nom: _nombreController.text.trim(),
      anio_publicacion: _anioController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      edicion: _edicionController.text.trim(),
      existencias: int.tryParse(_existenciasController.text.trim()) ?? 0,
      isbn: _isbnController.text.trim(),
      autor: _selectedAutor!,
      categoria: _selectedCategoria!,
      editorial: _selectedEditorial!,
      usuario_creacion_id: widget.libroEditar?.usuario_creacion_id ?? userId,
      usuario_actualizacion_id: userId,
      fecha_creacion: widget.libroEditar?.fecha_creacion ?? DateTime.now(),
      fecha_actualizacion: DateTime.now(),
      url_portada: widget.libroEditar?.url_portada ?? '',
    );

    bool success = await _apiService.registrarLibroV2(libro);
    setState(() => _loading = false);

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar libro')),
      );
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _anioController.dispose();
    _descripcionController.dispose();
    _edicionController.dispose();
    _existenciasController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = isEditMode ? 'Editar Libro' : 'Registrar Libro';
    final buttonText = isEditMode ? 'ACTUALIZAR' : 'REGISTRAR';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.red,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset('assets/agregar_usuario.png', width: 150, height: 150),
                    const SizedBox(height: 20),
                    _buildTextField(_nombreController, 'Nombre del libro', Icons.book),
                    const SizedBox(height: 10),
                    _buildTextField(_anioController, 'Año de publicación', Icons.calendar_today,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildTextField(_descripcionController, 'Descripción', Icons.description),
                    const SizedBox(height: 10),
                    _buildTextField(_edicionController, 'Edición', Icons.edit),
                    const SizedBox(height: 10),
                    _buildTextField(_existenciasController, 'Existencias', Icons.storage,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildTextField(_isbnController, 'ISBN', Icons.confirmation_num),
                    const SizedBox(height: 10),
                    _buildDropdown<Autor>(
                        label: 'Autor',
                        items: _autores,
                        value: _selectedAutor,
                        itemLabel: (a) => a.autor_nom ?? 'Autor ${a.autor_id}',
                        onChanged: (v) => setState(() => _selectedAutor = v)),
                    const SizedBox(height: 10),
                    _buildDropdown<Categoria>(
                        label: 'Categoría',
                        items: _categorias,
                        value: _selectedCategoria,
                        itemLabel: (c) => c.categoria_nom ?? 'Categoría ${c.categoria_id}',
                        onChanged: (v) => setState(() => _selectedCategoria = v)),
                    const SizedBox(height: 10),
                    _buildDropdown<Editorial>(
                        label: 'Editorial',
                        items: _editoriales,
                        value: _selectedEditorial,
                        itemLabel: (e) => e.editorial_nom ?? 'Editorial ${e.editorial_id}',
                        onChanged: (v) => setState(() => _selectedEditorial = v)),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
                        onPressed: _guardarLibro,
                        child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
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
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Por favor ingresa $hint' : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required List<T> items,
    required T? value,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: const Icon(Icons.list),
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
      items: items.map((item) => DropdownMenuItem(child: Text(itemLabel(item)), value: item)).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Por favor selecciona $label' : null,
    );
  }
}
