import 'package:flutter/material.dart';
import 'package:biblioteca97/models/usuario.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'MenuItemWidget.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart'
    as custom_nav;
import 'usuarios_register_screen.dart';


class UsuariosScreen extends StatefulWidget {
  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  late ApiService _apiService;
  List<Usuario> listaUsuarios = [];
  List<Usuario> usuariosFiltrados = [];
  bool isEditing = false;
  late Usuario usuarioEditando;

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
      listaUsuarios = await _apiService.listUserV2();
      usuariosFiltrados = List.from(listaUsuarios);
      setState(() {});
    } catch (e) {
      print("Error al obtener usuarios: $e");
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
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // isEditing ? _updateUsuario() : _addUsuario();
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

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const custom_nav.NavigationDrawer(), // Se usa tu Drawer
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
              // onChanged: _filtrarUsuarios,
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
                 // onEdit: editarUsuario,
                 // onDelete: eliminarUsuario,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
