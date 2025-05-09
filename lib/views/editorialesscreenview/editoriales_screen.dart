import 'package:flutter/material.dart';
import '../../models/data_editorial.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'MenuItemWidget.dart';

class EditorialesScreen extends StatefulWidget {
  @override
  _EditorialesScreenState createState() => _EditorialesScreenState();
}

class _EditorialesScreenState extends State<EditorialesScreen> {
  late ApiService apiService;
  late Future<List<DataEditorial>> editorialesFuture;

  bool isEditing = false;
  late DataEditorial editorialEditando;

  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    apiService = ApiService(client: ApiClient());
    editorialesFuture = apiService.fetchEditoriales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editoriales"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEditorial,
          ),
        ],
      ),
      body: FutureBuilder<List<DataEditorial>>(
        future: editorialesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay editoriales disponibles"));
          } else {
            final editoriales = snapshot.data!;

            return ListView.builder(
              itemCount: editoriales.length,
              itemBuilder: (context, index) {
                return MenuItemWidget(
                  editorial: editoriales[index],
                  onEdit: () => _editEditorial(editoriales[index]),
                  onDelete: () => _deleteEditorial(editoriales[index].idEditorial),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Mostrar diálogo para agregar
  Future<void> _addEditorial() async {
    setState(() {
      isEditing = false;
      idController.clear();
      nomController.clear();
    });
    _showAddUpdateDialog();
  }

  // Mostrar diálogo para editar
  Future<void> _editEditorial(DataEditorial editorial) async {
    setState(() {
      isEditing = true;
      editorialEditando = editorial;
      idController.text = editorial.idEditorial;
      nomController.text = editorial.nomEditorial;
    });
    _showAddUpdateDialog();
  }

  // Eliminar una editorial
  Future<void> _deleteEditorial(String idEditorial) async {
    final result = await apiService.deleteEditorial(idEditorial);
    if (result) {
      setState(() {
        editorialesFuture = apiService.fetchEditoriales();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Editorial eliminada')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al eliminar editorial')));
    }
  }

  // Diálogo para agregar o editar
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
                isEditing ? _updateEditorial() : _addEditorialWithForm();
              },
              child: Text(isEditing ? 'Actualizar' : 'Agregar'),
            ),
          ],
        );
      },
    );
  }

  // Agregar editorial
  Future<void> _addEditorialWithForm() async {
    final nuevaEditorial = DataEditorial(
      idEditorial: DateTime.now().millisecondsSinceEpoch.toString(),
      nomEditorial: nomController.text,
    );

    await apiService.addEditorial(nuevaEditorial);
    Navigator.of(context).pop();
    setState(() {
      editorialesFuture = apiService.fetchEditoriales();
    });
  }

  // Actualizar editorial
  Future<void> _updateEditorial() async {
    final editorialActualizada = DataEditorial(
      idEditorial: idController.text,
      nomEditorial: nomController.text,
    );

    await apiService.updateEditorial(editorialActualizada);
    Navigator.of(context).pop();
    setState(() {
      editorialesFuture = apiService.fetchEditoriales();
    });
  }
}
