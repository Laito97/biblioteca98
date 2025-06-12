import 'package:biblioteca97/models/libro.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
import 'package:flutter/material.dart';
import '../../models_ant/data_libro.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'LibroItemWidget.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart' as custom_nav;
import 'package:biblioteca97/views/librosscreenview/registrar_libro_screen.dart';

class LibrosScreen extends StatefulWidget {
  const LibrosScreen({super.key});

  @override
  _LibrosScreenState createState() => _LibrosScreenState();
}

class _LibrosScreenState extends State<LibrosScreen> {
  late ApiService _apiService;
  List<Libro> listaLibros = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient()); // ✅ Usamos instancia local
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrarLibroScreen()),
    ).then((_) {
      _fetchLibros();
    });
  }

  void _onEditLibro(DataLibro libro) {
    // Implementación futura si se requiere
  }

  void _onDeleteLibro(DataLibro libro) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Libro eliminado")),
        );
      }
    }
  }

  void _onPrestar(DataLibro libro) async {
    if (libro.existencias > 0) {
      libro.existencias -= 1;
      final success = await _apiService.updateLibro(libro);
      if (success) {
        _fetchLibros();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Libro prestado")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No hay existencias disponibles")),
      );
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
        backgroundColor: Colors.red,
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: _onAddLibro),
        ],
      ),
      drawer: NavegacionDrawer(),
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
            child: librosFiltrados.isEmpty
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
}
