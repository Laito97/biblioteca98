import 'package:flutter/material.dart';
import 'package:biblioteca97/models/autor.dart';
import '../../models_ant/data_autor.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart'; // Asegúrate de importar ApiService
import 'MenuItemWidget.dart'; // Asegúrate de tener este widget
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart' as custom_nav; // Asegúrate del path correcto

class AutoresScreen extends StatefulWidget {
  @override
  _AutoresScreenState createState() => _AutoresScreenState();
}

class _AutoresScreenState extends State<AutoresScreen> {
  late ApiService _apiService;
  List<Autor> listaAutores = [];
  bool isEditing = false; // Para saber si estamos en modo edición
  late DataAutor autorEditando; // Para almacenar el autor que estamos editando

  // Controladores para el formulario
  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchAutores();
  }

  // Fetch de autores desde la API
  Future<void> _fetchAutores() async {
    try {
      listaAutores = await _apiService.listAutorV2();
      setState(() {}); // Actualizamos el estado para que se muestre la lista
    } catch (e) {
      print("Error al obtener autores: $e");
    }
  }

  // Método para editar autor
  void editarAutor(DataAutor autor) {
    setState(() {
      isEditing = true;
      autorEditando = autor; // Guardamos el autor que vamos a editar
      idController.text = autor.idAutor;
      nomController.text = autor.nomAutor;
    });
    _showAddUpdateDialog();
  }

  // Método para eliminar autor
  void eliminarAutor(DataAutor autor) async {
    print('Eliminando autor: ${autor.nomAutor}');
    try {
      bool result = await _apiService.deleteAutor(autor.idAutor);
      if (result) {
        _fetchAutores(); // Actualizamos la lista
      } else {
        print("Error al eliminar autor.");
      }
    } catch (e) {
      print("Error al eliminar autor: $e");
    }
  }

  // Método para mostrar el dialog de agregar/editar autor
  void _showAddUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Autor' : 'Agregar Autor'),
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
                isEditing ? _updateAutor() : _addAutor();
              },
              child: Text(isEditing ? 'Actualizar' : 'Agregar'),
            ),
          ],
        );
      },
    );
  }

  // Formulario de agregar/editar autor
  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: idController,
          decoration: InputDecoration(labelText: 'ID Autor'),
          readOnly: isEditing, // Si estamos editando, no permitimos cambiar el ID
        ),
        TextField(
          controller: nomController,
          decoration: InputDecoration(labelText: 'Nombre Autor'),
        ),
      ],
    );
  }

  // Método para agregar un autor
  Future<void> _addAutor() async {
    final autor = DataAutor(
      idAutor: DateTime.now().millisecondsSinceEpoch.toString(), // Generar un ID temporal
      nomAutor: nomController.text,
    );

    try {
      await _apiService.addAutor(autor); // Llamamos al servicio para agregar
      _fetchAutores(); // Actualizamos la lista
      Navigator.of(context).pop(); // Cerramos el diálogo
    } catch (e) {
      print("Error al agregar autor: $e");
    }
  }

  // Método para actualizar un autor
  Future<void> _updateAutor() async {
    final autor = DataAutor(
      idAutor: idController.text,
      nomAutor: nomController.text, // Usamos los datos del formulario
    );

    try {
      await _apiService.updateAutor(autor); // Llamamos al servicio para actualizar
      _fetchAutores(); // Actualizamos la lista
      Navigator.of(context).pop(); // Cerramos el diálogo
    } catch (e) {
      print("Error al actualizar autor: $e");
    }
  }

  // Método para mostrar los autores en pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Autores'),
        backgroundColor: Colors.red,
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
      drawer: const custom_nav.NavigationDrawer(), // Aquí reutilizas tu NavigationDrawer
      body: listaAutores.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listaAutores.length,
              itemBuilder: (context, index) {
                final autor = listaAutores[index];
                return MenuItemWidget(
                  autor: autor,
                  onEdit: editarAutor,
                  onDelete: eliminarAutor,
                );
              },
            ),
    );
  }
}
