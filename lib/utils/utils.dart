import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static const int DURACION_SPLASH_SCREEN = 4000;

  // Retorna la duración del splash screen
  int getDurationSplashScreen() {
    return DURACION_SPLASH_SCREEN;
  }

  // Validación de campos de login
  bool validarCamposLogin(String idUsuario, String contrasena) {
    if (idUsuario.isEmpty || contrasena.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // Validación de campos para agregar o actualizar usuario
  bool validarCamposAddUpdateUsuario(String idUsuario, String nomUsuario, String contrasena) {
    if (idUsuario.isEmpty || nomUsuario.isEmpty || contrasena.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // Validación de campos para agregar o actualizar autor
  bool validarCampoAddUpdateAutor(String idAutor, String nomAutor) {
    if (idAutor.isEmpty || nomAutor.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // Validación de campos para agregar o actualizar editorial
  bool validarCamposAddUpdateEditorial(String idEditorial, String nomEditorial) {
    if (idEditorial.isEmpty || nomEditorial.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // Validación de campos para agregar o actualizar categoría
  bool validarCamposAddUpdateCategoria(String idCategoria, String nomCategoria) {
    if (idCategoria.isEmpty || nomCategoria.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // Validación de campos para préstamo
  bool validarCamposPrestamo(DataPrestamo prestamo) {
    if (prestamo.isbn.isEmpty || prestamo.idUsuario.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // Validación de campos para agregar o actualizar libro
  bool validarCamposAddUpdateLibro(DataLibro libro) {
    if (libro.isbn.isEmpty ||
        libro.nomLibro.isEmpty ||
        libro.nomAutor.isEmpty ||
        libro.nomAutor.contains('*') ||
        libro.descripcion.isEmpty ||
        libro.nomEditorial.isEmpty ||
        libro.nomEditorial.contains('*') ||
        libro.nomCategoria.isEmpty ||
        libro.nomCategoria.contains('*') ||
        libro.anioPublicacion.isEmpty ||
        libro.edicion.isEmpty ||
        libro.existencias <= 0) {
      return false;
    } else {
      return true;
    }
  }

  // Separar ID de usuario a partir de un texto
  String separarIdUsuario(String textoSeparar) {
    List<String> array = textoSeparar.split(',');
    return array[0];
  }

  // Guardar preferencias compartidas con el usuario
  Future<void> guardarSharedPreferences(DataAdminUsuario usuario) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("idUsuario", usuario.idUsuario);
    preferences.setString("nomUsuario", usuario.nomUsuario);
  }

  // Leer preferencias compartidas
  Future<DataAdminUsuario> leerSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DataAdminUsuario usuario = DataAdminUsuario();
    usuario.idUsuario = preferences.getString("idUsuario") ?? "";
    usuario.nomUsuario = preferences.getString("nomUsuario") ?? "";
    return usuario;
  }

  // Borrar preferencias compartidas
  Future<void> borrarSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("idUsuario");
    preferences.remove("nomUsuario");
  }
}

// Estas clases pueden ser definidas como modelos en Dart también:
class DataAdminUsuario {
  late String idUsuario;
  late String nomUsuario;

  // Constructor
  DataAdminUsuario({this.idUsuario = "", this.nomUsuario = ""});
}

class DataPrestamo {
  late String isbn;
  late String idUsuario;

  // Constructor
  DataPrestamo({this.isbn = "", this.idUsuario = ""});
}

class DataLibro {
  late String isbn;
  late String nomLibro;
  late String nomAutor;
  late String descripcion;
  late String nomEditorial;
  late String nomCategoria;
  late String anioPublicacion;
  late String edicion;
  late int existencias;

  // Constructor
  DataLibro({
    this.isbn = "",
    this.nomLibro = "",
    this.nomAutor = "",
    this.descripcion = "",
    this.nomEditorial = "",
    this.nomCategoria = "",
    this.anioPublicacion = "",
    this.edicion = "",
    this.existencias = 0,
  });
}
