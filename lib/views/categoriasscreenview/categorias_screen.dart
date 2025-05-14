import 'package:flutter/material.dart';
import '../../models_ant/data_categoria.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart'; // Asegúrate de importar ApiService
import 'MenuItemWidget.dart'; // Asegúrate de tener este widget para categorías

class CategoriaScreen extends StatefulWidget {
  @override
  _CategoriaScreenState createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  late ApiService _apiService;
  List<DataCategoria> listaCategorias = [];
  bool isEditing = false; // Para saber si estamos en modo edición
  late DataCategoria categoriaEditando; // Para almacenar la categoría que estamos editando

  // Controladores para el formulario
  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchCategorias();
  }

  // Fetch de categorías desde la API
  Future<void> _fetchCategorias() async {
    try {
      listaCategorias = await _apiService.fetchCategorias();
      setState(() {}); // Actualizamos el estado para que se muestre la lista
    } catch (e) {
      print("Error al obtener categorías: $e");
    }
  }

  // Método para editar categoría
  void editarCategoria(DataCategoria categoria) {
    setState(() {
      isEditing = true;
      categoriaEditando = categoria; // Guardamos la categoría que vamos a editar
      idController.text = categoria.idCategoria;
      nomController.text = categoria.nomCategoria;
    });
    _showAddUpdateDialog();
  }

  // Método para eliminar categoría
  void eliminarCategoria(DataCategoria categoria) async {
    print('Eliminando categoría: ${categoria.nomCategoria}');
    try {
      bool result = await _apiService.deleteCategoria(categoria.idCategoria);
      if (result) {
        _fetchCategorias(); // Actualizamos la lista
      } else {
        print("Error al eliminar categoría.");
      }
    } catch (e) {
      print("Error al eliminar categoría: $e");
    }
  }

  // Método para mostrar el dialog de agregar/editar categoría
  void _showAddUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Categoría' : 'Agregar Categoría'),
          content: _buildForm(),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                isEditing ? _updateCategoria() : _addCategoria();
              },
              child: Text(isEditing ? 'Actualizar' : 'Agregar'),
            ),
          ],
        );
      },
    );
  }

  // Formulario de agregar/editar categoría
  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: idController,
          decoration: InputDecoration(labelText: 'ID Categoría'),
          readOnly: isEditing, // Si estamos editando, no permitimos cambiar el ID
        ),
        TextField(
          controller: nomController,
          decoration: InputDecoration(labelText: 'Nombre Categoría'),
        ),
      ],
    );
  }

  // Método para agregar una categoría
  Future<void> _addCategoria() async {
    final categoria = DataCategoria(
      idCategoria: DateTime.now().millisecondsSinceEpoch.toString(), // Generar un ID temporal
      nomCategoria: nomController.text,
    );

    try {
      await _apiService.addCategoria(categoria); // Llamamos al servicio para agregar
      _fetchCategorias(); // Actualizamos la lista
      Navigator.of(context).pop(); // Cerramos el diálogo
    } catch (e) {
      print("Error al agregar categoría: $e");
    }
  }

  // Método para actualizar una categoría
  Future<void> _updateCategoria() async {
    final categoria = DataCategoria(
      idCategoria: idController.text,
      nomCategoria: nomController.text, // Usamos los datos del formulario
    );

    try {
      await _apiService.updateCategoria(categoria); // Llamamos al servicio para actualizar
      _fetchCategorias(); // Actualizamos la lista
      Navigator.of(context).pop(); // Cerramos el diálogo
    } catch (e) {
      print("Error al actualizar categoría: $e");
    }
  }

  // Método para mostrar las categorías en pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
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
      body: listaCategorias.isEmpty
          ? Center(child: CircularProgressIndicator()) // Mostramos un loader mientras cargan las categorías
          : ListView.builder(
        itemCount: listaCategorias.length,
        itemBuilder: (context, index) {
          final categoria = listaCategorias[index];
          return MenuItemWidget(
            categoria: categoria,
            onEdit: editarCategoria,
            onDelete: eliminarCategoria,
          );
        },
      ),
    );
  }
}
