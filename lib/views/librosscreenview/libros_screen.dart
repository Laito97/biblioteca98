import 'package:biblioteca97/models/libro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'LibroItemWidget.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
import 'package:biblioteca97/views/librosscreenview/registrar_libro_screen.dart';
import 'package:biblioteca97/utils/usuario_provider.dart';

class LibrosScreen extends StatefulWidget {
  const LibrosScreen({Key? key}) : super(key: key);

  @override
  _LibrosScreenState createState() => _LibrosScreenState();
}

class _LibrosScreenState extends State<LibrosScreen> {
  late ApiService _apiService;
  List<Libro> listaLibros = [];
  List<Libro> listaFiltrada = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchLibros();
    searchController.addListener(_filtrarLibros);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchLibros() async {
    try {
      listaLibros = await _apiService.listLibrosV2();
      listaFiltrada = List.from(listaLibros);
      _filtrarLibros();
    } catch (e) {
      print("Error al obtener libros: $e");
    }
  }

  void _filtrarLibros() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      listaFiltrada = List.from(listaLibros);
    } else {
      listaFiltrada = listaLibros.where((libro) {
        final nombreAutor = libro.autor?.autor_nom?.toLowerCase() ?? '';
        final nombreLibro = libro.libro_nom?.toLowerCase() ?? '';
        return nombreLibro.contains(query) || nombreAutor.contains(query);
      }).toList();
    }
    setState(() {});
  }

  void _mostrarOpcionesLibro(Libro libro) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Opciones para "${libro.libro_nom}"'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editarLibro(libro);
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _eliminarLibro(libro);
            },
            child: const Text('Eliminar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _editarLibro(Libro libro) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrarLibroScreen(libroEditar: libro),
      ),
    );
    _fetchLibros();
  }

  void _eliminarLibro(Libro libro) async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final usuarioId = usuarioProvider.usuario?.usuarioId;

    if (usuarioId == null) {
      _mostrarDialogo("No se pudo obtener el ID del usuario actual.");
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Confirmar eliminación"),
        content: Text('¿Seguro que quieres eliminar "${libro.libro_nom}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Eliminar")),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _apiService.deleteLibroById(libro.libro_id, usuarioId);
        _mostrarDialogo("Libro eliminado con éxito");
        _fetchLibros();
      } catch (e) {
        _mostrarDialogo("Error al eliminar: $e");
      }
    }
  }

  void _mostrarDialogo(String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Resultado"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _onAddLibro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegistrarLibroScreen()),
    );
    _fetchLibros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Libros"),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: listaFiltrada.isEmpty
                ? const Center(child: Text("No hay libros disponibles"))
                : ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      final libro = listaFiltrada[index];
                      return GestureDetector(
                        onTap: () => _mostrarOpcionesLibro(libro),
                        child: LibroItemWidget(
                          libro: libro,
                          onEdit: (_) {},
                          onDelete: (_) {},
                          onPrestar: (_) {},
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
