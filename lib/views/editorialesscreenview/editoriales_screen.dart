import 'package:biblioteca97/models/editorial.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
import 'package:flutter/material.dart';
import '../../models_ant/data_editorial.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'MenuItemWidget.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart' as custom_nav;
import 'package:biblioteca97/views/editorialesscreenview/editorial_register_screen.dart';

class EditorialesScreen extends StatefulWidget {
  @override
  _EditorialesScreenState createState() => _EditorialesScreenState();
}

class _EditorialesScreenState extends State<EditorialesScreen> {
  late ApiService _apiService;
  List<Editorial> listaEditoriales = [];
  List<Editorial> filteredEditoriales = [];

  bool isEditing = false;
  late DataEditorial editorialEditando;

  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchEditoriales();
  }

  Future<void> _fetchEditoriales() async {
    try {
      listaEditoriales = await _apiService.listEditorialesV2();
      filteredEditoriales = listaEditoriales;
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

  void _showAddUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Editorial' : 'Agregar Editorial'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID Editorial'),
                readOnly: isEditing,
              ),
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nombre Editorial'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                isEditing ? _updateEditorial() : _addEditorial();
              },
              child: Text(isEditing ? 'Actualizar' : 'Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addEditorial() async {
    final nuevaEditorial = DataEditorial(
      idEditorial: DateTime.now().millisecondsSinceEpoch.toString(),
      nomEditorial: nomController.text,
    );

    try {
      await _apiService.addEditorial(nuevaEditorial);
      _fetchEditoriales();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error al agregar editorial: $e");
    }
  }

  Future<void> _updateEditorial() async {
    final editorialActualizada = DataEditorial(
      idEditorial: idController.text,
      nomEditorial: nomController.text,
    );

    try {
      await _apiService.updateEditorial(editorialActualizada);
      _fetchEditoriales();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error al actualizar editorial: $e");
    }
  }

  void _editEditorial(DataEditorial editorial) {
    setState(() {
      isEditing = true;
      editorialEditando = editorial;
      idController.text = editorial.idEditorial;
      nomController.text = editorial.nomEditorial;
    });
    _showAddUpdateDialog();
  }

  void _deleteEditorial(DataEditorial editorial) async {
    print('Eliminando editorial: ${editorial.nomEditorial}');
    try {
      final result = await _apiService.deleteEditorial(editorial.idEditorial);
      if (result) {
        _fetchEditoriales();
      } else {
        print("Error al eliminar editorial.");
      }
    } catch (e) {
      print("Error al eliminar editorial: $e");
    }
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
              _fetchEditoriales(); // Refrescar lista tras registrar
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
              onChanged: _filterEditoriales,
            ),
          ),
          Expanded(
            child: filteredEditoriales.isEmpty
                ? Center(child: Text('No se encontraron resultados'))
                : ListView.builder(
                    itemCount: filteredEditoriales.length,
                    itemBuilder: (context, index) {
                      final editorial = filteredEditoriales[index];
                      return MenuItemWidget(
                        editorial: editorial,
                        onEdit: _editEditorial,
                        onDelete: _deleteEditorial,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
