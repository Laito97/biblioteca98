import 'package:biblioteca97/models/editorial.dart';
import 'package:flutter/material.dart';
import '../../models_ant/data_editorial.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'MenuItemWidget.dart';

class EditorialesScreen extends StatefulWidget {
  @override
  _EditorialesScreenState createState() => _EditorialesScreenState();
}

class _EditorialesScreenState extends State<EditorialesScreen> {
  late ApiService _apiService;
  List<Editorial> listaEditoriales = [];

  bool isEditing = false;
  late DataEditorial editorialEditando;

  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchEditoriales();
  }

  // Obtener editoriales desde la API
Future<void> _fetchEditoriales() async {
  try {
    listaEditoriales = await _apiService.listEditorialesV2();
    print("Editoriales recibidas: ${listaEditoriales.length}");
    setState(() {});
  } catch (e) {
    print("Error al obtener editoriales: $e");
  }
}


  // Mostrar diálogo de agregar/editar
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

  // Agregar nueva editorial
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

  // Actualizar editorial existente
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

  // Editar editorial existente
  void _editEditorial(DataEditorial editorial) {
    setState(() {
      isEditing = true;
      editorialEditando = editorial;
      idController.text = editorial.idEditorial;
      nomController.text = editorial.nomEditorial;
    });
    _showAddUpdateDialog();
  }

  // Eliminar una editorial
void _deleteEditorial(DataEditorial editorial) async {
  print('Eliminando editorial: ${editorial.nomEditorial}');
  try {
    final result = await _apiService.deleteEditorial(editorial.idEditorial);
    if (result) {
      _fetchEditoriales(); // Actualizamos la lista
    } else {
      print("Error al eliminar editorial.");
    }
  } catch (e) {
    print("Error al eliminar editorial: $e");
  }
}

  // Vista principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editoriales'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                isEditing = false;
                idController.clear();
                nomController.clear();
              });
              _showAddUpdateDialog();
            },
          ),
        ],
      ),
      body: listaEditoriales.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listaEditoriales.length,
              itemBuilder: (context, index) {
                final editorial = listaEditoriales[index];
                return MenuItemWidget(
                  editorial: editorial,
                  onEdit: _editEditorial,
                  onDelete:_deleteEditorial,
                );
              },
            ),
    );
  }
}
