import 'package:flutter/material.dart';

class NavegacionScreen extends StatelessWidget {
  final String nombreUsuario;

  const NavegacionScreen({Key? key, required this.nombreUsuario})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Home'), backgroundColor: Colors.red),
        drawer: const NavigationDrawer(),
        body: Center(
          child: Text('Bienvenido, $nombreUsuario'),
        ),
      );
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> listaMenu = const [
    {'title': "Usuarios", 'icon': Icons.people},
    {'title': "Autores", 'icon': Icons.book},
    {'title': "Editoriales", 'icon': Icons.library_books},
    {'title': "Categorías", 'icon': Icons.category},
    {'title': "Libros", 'icon': Icons.library_books},
    {'title': "Préstamos", 'icon': Icons.assignment},
  ];

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.red,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/3135/3135768.png',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Juan Ruelas',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Text(
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer si es necesario
                _onMenuItemClick(item['title'], context);
              },
            ),
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/navegacion', (route) => false);
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


// class _NavegacionScreenState extends State<NavegacionScreen> {
//   List<Map<String, dynamic>> listaMenu = [
//     {'title': "Usuarios", 'icon': Icons.people},
//     {'title': "Autores", 'icon': Icons.book},
//     {'title': "Editoriales", 'icon': Icons.library_books},
//     {'title': "Categorías", 'icon': Icons.category},
//     {'title': "Libros", 'icon': Icons.library_books},
//     {'title': "Préstamos", 'icon': Icons.assignment},
//   ];

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Navegación'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   widget.nombreUsuario,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _cerrarSesion(context);
//                   },
//                   child: Icon(
//                     Icons.exit_to_app,
//                     size: 30,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: listaMenu.length,
//               itemBuilder: (context, index) {
//                 return MenuItemWidget(
//                   menuTitle: listaMenu[index]['title'],
//                   menuIcon: listaMenu[index]['icon'],
//                   onTap: () {
//                     _onMenuItemClick(listaMenu[index]['title'], context);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onMenuItemClick(String menu, BuildContext context) {
//     switch (menu.toLowerCase()) {
//       case 'usuarios':
//         Navigator.pushNamed(context, '/usuarios');
//         break;
//       case 'autores':
//         Navigator.pushNamed(context, '/autores');
//         break;
//       case 'editoriales':
//         Navigator.pushNamed(context, '/editoriales');
//         break;
//       case 'categorías':
//         Navigator.pushNamed(context, '/categorias');
//         break;
//       case 'libros':
//         Navigator.pushNamed(context, '/libros');
//         break;
//       case 'préstamos':
//         Navigator.pushNamed(context, '/prestamos');
//         break;
//     }
//   }

// }
