import 'package:biblioteca97/models/libro.dart';
import 'package:flutter/material.dart';
import '../../models_ant/data_libro.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'LibroItemWidget.dart';

class LibrosScreen extends StatefulWidget {
final ApiService apiService;

  LibrosScreen ({required this.apiService});

  @override
  _LibrosScreenState createState() => _LibrosScreenState();
}

class _LibrosScreenState extends State<LibrosScreen> {
  late ApiService _apiService;
  List<Libro> listaLibros = [];
  bool isEditing = false;
  late DataLibro libroEditando;

  TextEditingController searchController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  TextEditingController autorController = TextEditingController();
  TextEditingController existenciasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchLibros();
    searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchLibros() async {
    try {
      listaLibros = await _apiService.listLibrosV2();
      setState(() {});
    } catch (e) {
      print("Error al obtener libros: $e");
    }
  }

  void _onSearchChanged() {
    setState(() {});
  }

  void _onAddLibro() {
    setState(() {
      isEditing = false;
      tituloController.clear();
      autorController.clear();
      existenciasController.clear();
    });
    _showAddUpdateDialog();
  }

  void _onEditLibro(DataLibro libro) {
    setState(() {
      isEditing = true;
      libroEditando = libro;
      tituloController.text = libro.nomLibro ?? '';
      autorController.text = libro.nomAutor ?? '';
      existenciasController.text = libro.existencias.toString();
    });
    _showAddUpdateDialog();
  }

  void _onDeleteLibro(DataLibro libro) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Confirmar eliminación"),
            content: Text("¿Estás seguro de eliminar '${libro.nomLibro}'?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Eliminar"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await _apiService.deleteLibro(libro.isbn);
      if (success) {
        _fetchLibros();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Libro eliminado")));
      }
    }
  }

  void _showAddUpdateDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isEditing ? 'Editar Libro' : 'Agregar Libro'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: autorController,
                  decoration: InputDecoration(labelText: 'Autor'),
                ),
                TextField(
                  controller: existenciasController,
                  decoration: InputDecoration(labelText: 'Existencias'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  isEditing ? _updateLibro() : _addLibro();
                },
                child: Text(isEditing ? 'Actualizar' : 'Agregar'),
              ),
            ],
          ),
    );
  }

  Future<void> _addLibro() async {
    final nuevoLibro = DataLibro(
      isbn: '',
      nomLibro: tituloController.text,
      nomAutor: autorController.text,
      existencias: int.tryParse(existenciasController.text) ?? 0,
    );

    final success = await _apiService.addLibro(nuevoLibro);
    if (success) {
      _fetchLibros();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Libro agregado")));
    }
  }

  Future<void> _updateLibro() async {
    final libroActualizado = DataLibro(
      isbn: libroEditando.isbn,
      nomLibro: tituloController.text,
      nomAutor: autorController.text,
      existencias:
          int.tryParse(existenciasController.text) ?? libroEditando.existencias,
    );

    final success = await _apiService.updateLibro(libroActualizado);
    if (success) {
      _fetchLibros();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Libro actualizado")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final librosFiltrados = listaLibros.where((libro) {
  final filtro = searchController.text.toLowerCase();
  final nombreAutor = libro.autor?.autor_nom?.toLowerCase() ?? '';
  final nombreLibro = libro.libro_nom?.toLowerCase() ?? '';
  return nombreLibro.contains(filtro) || nombreAutor.contains(filtro);
}).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Libros"),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _onAddLibro)],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Buscar por autor o título",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child:
                librosFiltrados.isEmpty
                    ? Center(child: Text("No hay libros disponibles"))
                    : ListView.builder(
                      itemCount: librosFiltrados.length,
                      itemBuilder: (context, index) {
                        final libro = librosFiltrados[index];
                        return LibroItemWidget(
                          libro: libro,
                          onEdit: _onEditLibro,
                          onDelete: _onDeleteLibro,
                          onPrestar: _onPrestar,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _onPrestar(DataLibro libro) async {
    if (libro.existencias > 0) {
      libro.existencias -= 1;
      final success = await _apiService.updateLibro(libro);
      if (success) {
        _fetchLibros();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Libro prestado")));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No hay existencias disponibles")));
    }
  }
}
