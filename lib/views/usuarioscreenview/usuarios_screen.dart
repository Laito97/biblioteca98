import 'package:flutter/material.dart';
import '../../models/data_usuario.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'MenuItemWidget.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  late ApiService _apiService;
  List<DataUsuario> listaUsuarios = [];
  List<DataUsuario> usuariosFiltrados = [];
  bool isEditing = false;
  late DataUsuario usuarioEditando;

  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      listaUsuarios = await _apiService.fetchUsers();
      usuariosFiltrados = List.from(listaUsuarios);
      setState(() {});
    } catch (e) {
      print("Error al obtener usuarios: $e");
    }
  }

  void _filtrarUsuarios(String query) {
    final filtrados = listaUsuarios.where((usuario) {
      final nombre = usuario.nomUsuario.toLowerCase();
      final texto = query.toLowerCase();
      return nombre.contains(texto);
    }).toList();

    setState(() {
      usuariosFiltrados = filtrados;
    });
  }

  void editarUsuario(DataUsuario usuario) {
    setState(() {
      isEditing = true;
      usuarioEditando = usuario;
      idController.text = usuario.idUsuario;
      nomController.text = usuario.nomUsuario;
      contrasenaController.text = usuario.contrasena;
    });
    _showAddUpdateDialog();
  }

  void eliminarUsuario(DataUsuario usuario) async {
    print('Eliminando usuario: ${usuario.nomUsuario}');
    try {
      bool result = await _apiService.deleteUser(usuario.idUsuario);
      if (result) {
        _fetchUsers();
      } else {
        print("Error al eliminar usuario.");
      }
    } catch (e) {
      print("Error al eliminar usuario: $e");
    }
  }

  void _showAddUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Usuario' : 'Agregar Usuario'),
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
                isEditing ? _updateUser() : _addUser();
              },
              child: Text(isEditing ? 'Actualizar' : 'Agregar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: idController,
          decoration: InputDecoration(labelText: 'ID Usuario'),
          readOnly: isEditing,
        ),
        TextField(
          controller: nomController,
          decoration: InputDecoration(labelText: 'Nombre Usuario'),
        ),
        TextField(
          controller: contrasenaController,
          decoration: InputDecoration(labelText: 'Contraseña'),
          obscureText: true,
        ),
      ],
    );
  }

  Future<void> _addUser() async {
    final usuario = DataUsuario(
      idUsuario: DateTime.now().millisecondsSinceEpoch.toString(),
      nomUsuario: nomController.text,
      estadoUsuario: null,
      contrasena: contrasenaController.text,
    );

    try {
      await _apiService.addUser(usuario);
      searchController.clear(); // limpiar búsqueda
      _fetchUsers();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error al agregar usuario: $e");
    }
  }

  Future<void> _updateUser() async {
    final usuario = DataUsuario(
      idUsuario: idController.text,
      nomUsuario: nomController.text,
      estadoUsuario: usuarioEditando.estadoUsuario,
      contrasena: contrasenaController.text,
    );

    try {
      await _apiService.updateUser(usuario);
      searchController.clear(); // limpiar búsqueda
      _fetchUsers();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error al actualizar usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                isEditing = false;
                idController.clear();
                nomController.clear();
                contrasenaController.clear();
              });
              _showAddUpdateDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar usuario...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filtrarUsuarios,
            ),
          ),
          Expanded(
            child: usuariosFiltrados.isEmpty
                ? Center(child: Text('No se encontraron usuarios'))
                : ListView.builder(
              itemCount: usuariosFiltrados.length,
              itemBuilder: (context, index) {
                final usuario = usuariosFiltrados[index];
                return MenuItemWidget(
                  usuario: usuario,
                  onEdit: editarUsuario,
                  onDelete: eliminarUsuario,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
