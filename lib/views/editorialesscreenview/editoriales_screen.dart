import 'package:biblioteca97/models/editorial.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'MenuItemWidget.dart';
import 'package:biblioteca97/views/editorialesscreenview/editorial_register_screen.dart';

class EditorialesScreen extends StatefulWidget {
  @override
  _EditorialesScreenState createState() => _EditorialesScreenState();
}

class _EditorialesScreenState extends State<EditorialesScreen> {
  late ApiService _apiService;
  List<Editorial> listaEditoriales = [];
  List<Editorial> filteredEditoriales = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchEditoriales();

    searchController.addListener(() {
      _filterEditoriales(searchController.text);
    });
  }

  Future<void> _fetchEditoriales() async {
    try {
      listaEditoriales = await _apiService.listEditorialesV2();
      filteredEditoriales = List.from(listaEditoriales);
      setState(() {});
    } catch (e) {
      print("Error al obtener editoriales: $e");
    }
  }

  void _filterEditoriales(String query) {
    final resultados = listaEditoriales.where((editorial) {
      return (editorial.editorial_nom ?? '').toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredEditoriales = resultados;
    });
  }

  void _mostrarOpcionesEditorial(Editorial editorial) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Opciones para "${editorial.editorial_nom ?? ''}"'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _editarEditorial(editorial);
              },
              child: const Text('Editar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                // Maqueta eliminar
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

  void _editarEditorial(Editorial editorial) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditorialRegisterScreen(
          editorialEditar: editorial, // PASAMOS Editorial directo
        ),
      ),
    );
    _fetchEditoriales(); // refresca tras editar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editoriales'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditorialRegisterScreen(),
                ),
              );
              _fetchEditoriales(); // refrescar tras agregar
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
                labelText: 'Buscar Editorial',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: filteredEditoriales.isEmpty
                ? Center(child: Text('No se encontraron resultados'))
                : ListView.builder(
                    itemCount: filteredEditoriales.length,
                    itemBuilder: (context, index) {
                      final editorial = filteredEditoriales[index];
                      return GestureDetector(
                        onTap: () => _mostrarOpcionesEditorial(editorial),
                        child: MenuItemWidget(
                          editorial: editorial,
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
