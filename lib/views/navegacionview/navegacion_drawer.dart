import 'package:biblioteca97/utils/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca97/models/usuario.dart';
import 'package:provider/provider.dart';

class NavegacionDrawer extends StatelessWidget {
  NavegacionDrawer({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> listaMenu = const [
    {'title': "Usuarios", 'icon': Icons.people},
    {'title': "Autores", 'icon': Icons.book},
    {'title': "Editoriales", 'icon': Icons.library_books},
    {'title': "Categorías", 'icon': Icons.category},
    {'title': "Libros", 'icon': Icons.library_books},
    {'title': "Préstamos", 'icon': Icons.assignment},
  ];

  @override
  Widget build(BuildContext context) {
    final usuarioLogged =
        Provider.of<UsuarioProvider>(context, listen: false).usuario;

    if (usuarioLogged == null) {
      return const Drawer(
        child: Center(child: Text("No hay usuario logueado")),
      );
    }

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context, usuarioLogged),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, Usuario usuarioLogged) => Material(
    color: Colors.red,
    child: InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 52,
              backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/3135/3135768.png',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${usuarioLogged.persona?.nombres} ${usuarioLogged.persona?.apellidos}'
                  .toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const Text(
              'ADMINISTRADOR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget buildMenuItems(BuildContext context) => Wrap(
    runSpacing: 4,
    children: [
      ...listaMenu.map(
        (item) => ListTile(
          leading: Icon(item['icon']),
          title: Text(
            item['title'],
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          onTap: () {
            Navigator.pop(context);
            _onMenuItemClick(item['title'], context);
          },
        ),
      ),
      const Divider(color: Colors.black54),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Home'),
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/navegacion',
            (route) => false,
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.exit_to_app),
        title: const Text('Cerrar sesión'),
        onTap: () {
          _cerrarSesion(context);
        },
      ),
    ],
  );

  void _onMenuItemClick(String menu, BuildContext context) {
    switch (menu.toLowerCase()) {
      case 'usuarios':
        Navigator.pushNamed(context, '/usuarios');
        break;
      case 'autores':
        Navigator.pushNamed(context, '/autores');
        break;
      case 'editoriales':
        Navigator.pushNamed(context, '/editoriales');
        break;
      case 'categorías':
        Navigator.pushNamed(context, '/categorias');
        break;
      case 'libros':
        Navigator.pushNamed(context, '/libros');
        break;
      case 'préstamos':
        Navigator.pushNamed(context, '/prestamos');
        break;
    }
  }

  void _cerrarSesion(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
