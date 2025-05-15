import 'package:biblioteca97/services/api_client.dart';
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
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart';  // Importa NavegacionScreen

void main() {
  // Crear una instancia del ApiClient y ApiService
  final ApiClient apiClient = ApiClient();
  final ApiService apiService = ApiService(client: apiClient);

  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  // Recibimos la instancia de ApiService desde el constructor
  MyApp({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Pantalla inicial
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/navegacion': (context) => NavegacionScreen(nombreUsuario: 'Nombre del Usuario'),
        '/usuarios': (context) => UsuariosScreen(),
        '/autores': (context) => AutoresScreen(),
        '/editoriales': (context) => EditorialesScreen(),
        '/categorias': (context) => CategoriaScreen(),
        '/libros': (context) => LibrosScreen(apiService: apiService),  // Pasa la instancia de apiService
        '/prestamos': (context) => PrestamosScreen(apiService: apiService),  // Pasa la instancia de apiService
      },
    );
  }
}