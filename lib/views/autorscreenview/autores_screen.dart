import 'package:flutter/material.dart';
import 'package:biblioteca97/models/autor.dart';
import '../../models_ant/data_autor.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart'; // Asegúrate de importar ApiService
import 'MenuItemWidget.dart'; // Asegúrate de tener este widget
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart' as custom_nav; // Asegúrate del path correcto
import 'package:biblioteca97/views/autorscreenview/autores_register_screen.dart'; // Importa la pantalla de registro

class AutoresScreen extends StatefulWidget {
  @override
  _AutoresScreenState createState() => _AutoresScreenState();
}

class _AutoresScreenState extends State<AutoresScreen> {
  late ApiService _apiService;
  List<Autor> listaAutores = [];
  List<Autor> listaFiltrada = []; // Lista para mostrar según búsqueda

  bool isEditing = false; // Para saber si estamos en modo edición
  late DataAutor autorEditando; // Para almacenar el autor que estamos editando

  // Controladores para el formulario de edición
  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();

  // Controlador para el buscador
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchAutores();

    // Listener para buscar al escribir
    searchController.addListener(() {
      _filtrarAutores();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    idController.dispose();
    nomController.dispose();
    super.dispose();
  }

  // Fetch de autores desde la API
  Future<void> _fetchAutores() async {
    try {
      listaAutores = await _apiService.listAutorV2();
      listaFiltrada = List.from(listaAutores); // Inicializamos filtrada igual a original
      setState(() {});
    } catch (e) {
      print("Error al obtener autores: $e");
    }
  }

  // Filtrar lista según búsqueda
  void _filtrarAutores() {
  final query = searchController.text.toLowerCase();

  if (query.isEmpty) {
    listaFiltrada = List.from(listaAutores);
  } else {
    listaFiltrada = listaAutores.where((autor) {
      final nombre = autor.autor_nom?.toLowerCase() ?? '';
      return nombre.contains(query);
    }).toList();
  }
  setState(() {});
}
  // Método para editar autor (aún usamos diálogo para editar)
  void editarAutor(DataAutor autor) {
    setState(() {
      isEditing = true;
      autorEditando = autor; // Guardamos el autor que vamos a editar
      idController.text = autor.idAutor;
      nomController.text = autor.nomAutor;
    });
    _showEditDialog();
  }

  // Método para eliminar autor
  void eliminarAutor(DataAutor autor) async {
    print('Eliminando autor: ${autor.nomAutor}');
    try {
      bool result = await _apiService.deleteAutor(autor.idAutor);
      if (result) {
        _fetchAutores(); // Actualizamos la lista original y filtrada
      } else {
        print("Error al eliminar autor.");
      }
    } catch (e) {
      print("Error al eliminar autor: $e");
    }
  }

  // Mostrar diálogo para editar autor
  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Autor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID Autor'),
                readOnly: true,
              ),
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nombre Autor'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _updateAutor();
                Navigator.of(context).pop();
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  // Método para actualizar un autor
  Future<void> _updateAutor() async {
    final autor = DataAutor(
      idAutor: idController.text,
      nomAutor: nomController.text,
    );

    try {
      await _apiService.updateAutor(autor);
      _fetchAutores();
    } catch (e) {
      print("Error al actualizar autor: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autores'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AutoresRegisterScreen(),
                ),
              );
              _fetchAutores(); // Refrescar lista tras registrar nuevo autor
            },
          ),
        ],
      ),
      drawer: const custom_nav.NavigationDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Autor',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: listaFiltrada.isEmpty
                ? const Center(child: Text('No se encontraron autores'))
                : ListView.builder(
                    itemCount: listaFiltrada.length,
                    itemBuilder: (context, index) {
                      final autor = listaFiltrada[index];
                      return MenuItemWidget(
                        autor: autor,
                        onEdit: editarAutor,
                        onDelete: eliminarAutor,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
