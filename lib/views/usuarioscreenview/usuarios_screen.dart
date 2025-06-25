import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
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

  void _showUserOptionsDialog(Usuario usuario) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Opciones para ${usuario.persona?.nombres ?? 'Usuario'}'),
          content: Text('Seleccione una acción:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Aquí solo maqueta, no eliminará realmente
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Función eliminar no implementada')),
                );
              },
              child: Text('Eliminar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(
                      usuarioId: usuario.usuarioId,
                    ),
                  ),
                ).then((value) {
                  _fetchUsers(); // refrescar al volver
                });
              },
              child: Text('Editar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
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
              ).then((value) {
                _fetchUsers();
              });
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
                labelText: 'Buscar usuario...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              // Puedes implementar filtrado aquí si quieres
            ),
          ),
          Expanded(
            child: usuariosFiltrados.isEmpty
                ? Center(child: Text('No se encontraron usuarios'))
                : ListView.builder(
                    itemCount: usuariosFiltrados.length,
                    itemBuilder: (context, index) {
                      final usuario = usuariosFiltrados[index];
                      return GestureDetector(
                        onTap: () => _showUserOptionsDialog(usuario),
                        child: MenuItemWidget(
                          usuario: usuario,
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
