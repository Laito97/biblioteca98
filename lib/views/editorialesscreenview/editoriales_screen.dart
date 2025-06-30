import 'package:biblioteca97/models/editorial.dart';
import 'package:biblioteca97/utils/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'MenuItemWidget.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
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
      return (editorial.editorial_nom ?? '')
          .toLowerCase()
          .contains(query.toLowerCase());
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
          content: const Text('Seleccione una acción:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _eliminarEditorial(editorial);
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _editarEditorial(editorial);
              },
              child: const Text('Editar'),
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
          editorialEditar: editorial,
        ),
      ),
    );
    _fetchEditoriales();
  }

  void _eliminarEditorial(Editorial editorial) async {
    try {
      final usuarioId = Provider.of<UsuarioProvider>(
        context,
        listen: false,
      ).usuario?.usuarioId;

      if (usuarioId == null) {
        _mostrarDialogo("No se pudo obtener el ID del usuario actual.");
        return;
      }
      if (editorial.editorial_id == null) {
        _mostrarDialogo("La editorial no tiene un ID válido.");
        return;
      }

      await _apiService.deleteEditorialesById(editorial.editorial_id, usuarioId);
      _mostrarDialogo("Editorial eliminada con éxito");
      _fetchEditoriales();
    } catch (e) {
      _mostrarDialogo("Error al eliminar: $e");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editoriales'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditorialRegisterScreen(),
                ),
              );
              _fetchEditoriales();
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
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: filteredEditoriales.isEmpty
                ? const Center(child: Text('No se encontraron resultados'))
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
