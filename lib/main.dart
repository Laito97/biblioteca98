import 'package:biblioteca97/models/usuario.dart';
import 'package:biblioteca97/services/api_client.dart';
import 'package:biblioteca97/utils/usuario_provider.dart';
import 'package:biblioteca97/views/prestamosscreenview/prestamos_screen.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca97/services/api_service.dart'; // Importa el servicio ApiService
import 'package:biblioteca97/views/editorialesscreenview/editoriales_screen.dart';
import 'package:biblioteca97/views/loginscreenview/login_screen.dart';
import 'package:biblioteca97/views/usuarioscreenview/usuarios_screen.dart';
import 'package:biblioteca97/views/autorscreenview/autores_screen.dart'; // Importar la pantalla de autores
import 'package:biblioteca97/views/categoriasscreenview/categorias_screen.dart'; // Importar la pantalla de categorías
import 'package:biblioteca97/views/librosscreenview/libros_screen.dart'; // Importar la pantalla de libros
import 'package:biblioteca97/views/splashscreenview/splashscreenview.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart';
import 'package:provider/provider.dart';

void main() {
  final ApiClient apiClient = ApiClient();
  final ApiService apiService = ApiService(client: apiClient);

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService), // Proveedor de ApiService
        ChangeNotifierProvider<UsuarioProvider>(create: (_) => UsuarioProvider()), // Proveedor de usuario
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/navegacion': (context) => NavegacionScreen(),
        '/usuarios': (context) => UsuariosScreen(),
        '/autores': (context) => AutoresScreen(),
        '/editoriales': (context) => EditorialesScreen(),
        '/categorias': (context) => CategoriaScreen(),
        '/libros': (context) => LibrosScreen(),
        '/prestamos': (context) => PrestamosScreen(),
      },
    );
  }
}
