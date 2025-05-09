import 'package:flutter/material.dart';
import 'MenuItemWidget.dart';

class NavegacionScreen extends StatefulWidget {
  final String nombreUsuario;  // ✅ Recibe nombre del usuario

  const NavegacionScreen({Key? key, required this.nombreUsuario}) : super(key: key);

  @override
  _NavegacionScreenState createState() => _NavegacionScreenState();
}

class _NavegacionScreenState extends State<NavegacionScreen> {
  List<Map<String, dynamic>> listaMenu = [
    {'title': "Usuarios", 'icon': Icons.people},
    {'title': "Autores", 'icon': Icons.book},
    {'title': "Editoriales", 'icon': Icons.library_books},
    {'title': "Categorías", 'icon': Icons.category},
    {'title': "Libros", 'icon': Icons.library_books},
    {'title': "Préstamos", 'icon': Icons.assignment},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navegación'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.nombreUsuario,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _cerrarSesion(context);
                  },
                  child: Icon(
                    Icons.exit_to_app,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: listaMenu.length,
              itemBuilder: (context, index) {
                return MenuItemWidget(
                  menuTitle: listaMenu[index]['title'],
                  menuIcon: listaMenu[index]['icon'],
                  onTap: () {
                    _onMenuItemClick(listaMenu[index]['title'], context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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
