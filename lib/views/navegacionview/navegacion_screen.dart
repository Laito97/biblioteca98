import 'package:biblioteca97/utils/usuario_provider.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_carousel.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_categorias.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_recomendaciones';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavegacionScreen extends StatelessWidget {
  const NavegacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioLogged = Provider.of<UsuarioProvider>(context).usuario;

    if (usuarioLogged == null) {
      return Scaffold(body: Center(child: Text('No hay usuario logueado')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tus recomendaciones',
              style: TextStyle(fontSize: 11, color: Colors.white60),
            ),
            Text(
              'Bienvenido ${usuarioLogged.persona.nombres}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      drawer: NavegacionDrawer(),
      body: Container(
        color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavegacionCarousel(),            
              NavegacionCategorias(),
              RecomendacionSection(idUsuario: usuarioLogged.usuarioId!)
            ],
          ),
        ),
      ),
    );
  }
}
