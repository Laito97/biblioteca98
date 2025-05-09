import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:biblioteca97/views/loginscreenview/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Llamar al método que cambia la pantalla después de 3 segundos
    _cambiarPantalla();
  }

  // Método para cambiar de pantalla después de 3 segundos
  void _cambiarPantalla() {
    Future.delayed(Duration(seconds: 3), () {
      // Navegar a la siguiente pantalla (LoginScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para el SplashScreen
      body: Center(
        child: Image.asset(
          'assets/gif_libro.gif', // Ruta del logo o imagen
          width: 300,  // Ajusta el tamaño según sea necesario
          height: 300, // Ajusta el tamaño según sea necesario
          fit: BoxFit.contain,  // Ajuste de la imagen
        ),
      ),
    );
  }
}
