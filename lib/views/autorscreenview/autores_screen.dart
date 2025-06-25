import 'package:biblioteca97/models/autor.dart';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'MenuItemWidget.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
import 'package:biblioteca97/views/autorscreenview/autores_register_screen.dart';

class AutoresScreen extends StatefulWidget {
  @override
  _AutoresScreenState createState() => _AutoresScreenState();
}

class _AutoresScreenState extends State<AutoresScreen> {
  late ApiService _apiService;
  List<Autor> listaAutores = [];
  List<Autor> listaFiltrada = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchAutores();

    searchController.addListener(() {
      _filtrarAutores();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchAutores() async {
    try {
      listaAutores = await _apiService.listAutorV2();
      listaFiltrada = List.from(listaAutores);
      setState(() {});
    } catch (e) {
      print("Error al obtener autores: $e");
    }
  }

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

  // Mostrar diálogo con opciones: Editar, Eliminar, Cancelar
  void _mostrarOpcionesAutor(Autor autor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Opciones para "${autor.autor_nom}"'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // cerrar diálogo
                _editarAutor(autor);
              },
              child: const Text('Editar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // cerrar diálogo
                // Por ahora solo maqueta eliminar:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Eliminar no implementado todavía')),
                );
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  // Navegar a pantalla de editar autor
  void _editarAutor(Autor autor) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AutoresRegisterScreen(
          autorEditar: autor,
        ),
      ),
    );
    _fetchAutores(); // refrescar lista tras editar
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
              _fetchAutores();
            },
          ),
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
                labelText: 'Buscar Autor',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                      return GestureDetector(
                        onTap: () => _mostrarOpcionesAutor(autor),
                        child: MenuItemWidget(
                          autor: autor,
                          onEdit: (_) {},
                          onDelete: (_) {},
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
