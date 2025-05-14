import 'package:biblioteca97/controllers/auth_controller.dart';
import 'package:biblioteca97/controllers/usuario_controller.dart';
import 'package:biblioteca97/models/usuario.dart';

import '../models_ant/data_categoria.dart';
import '../models_ant/data_editorial.dart';
import '../models_ant/data_libro.dart';
import '../models_ant/data_prestamo.dart';
import '../models_ant/data_usuario.dart';
import '../models_ant/data_autor.dart';
import '../models_ant/admin_usuario_response.dart';
import '../models_ant/autor_response.dart';
import 'api_client.dart';

class ApiService {
  final ApiClient client;

  ApiService({required this.client});

  //SERVICES V2

    // LOGIN V2
  Future<AuthResponse?> loginV2(String usuario, String contrasena) async {
    try {
      final response = await client.post('/auth/login', {
        'username': usuario,
        'password': contrasena,
      });

      if (response != null && response is Map<String, dynamic> && response.isNotEmpty) {
        if (response.containsKey('access_token')) {
          return AuthResponse.fromJson(response);
        } else {
          print("La respuesta del servidor no contiene un 'access_token'.");
          return null;
        }
      } else {
        print("Respuesta de login vacía o mal formada.");
        return null;
      }
    } catch (e) {
      print("Error en login: $e");
      rethrow; 
    }
  }

  Future<List<Usuario>> listUserV2() async {
    try {
      final data = await client.get('/usuarios/list');
      if (data != null && data['usuarios'] != null && data['usuarios'] is List) {
        print("DATA RECIBIDA: $data");
        final response = UsuarioController.fromJson(data);
        return response.usuarios;
      } else {
        return [];
      }
    } catch (e) {
      print("Error al obtener los usuarios: $e");
      rethrow;
    }
  }





  // ===================== LOGIN =====================
  Future<AdminUsuarioResponse?> login(String usuario, String contrasena) async {
    try {
      final response = await client.post('/adminlogin', {
        'id_usuario': usuario,
        'contrasena': contrasena,
      });

      if (response != null && response is Map<String, dynamic> && response.isNotEmpty) {
        return AdminUsuarioResponse.fromJson(response);
      } else {
        print("Respuesta de login vacía o mal formada.");
        return null;
      }
    } catch (e) {
      print("Error en login: $e");
      rethrow;
    }
  }

  // ===================== USUARIOS =====================
  // OBTENER USUARIOS
  Future<List<DataUsuario>> fetchUsers() async {
    try {
      final data = await client.get('/usuarios');
      if (data != null && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => DataUsuario.fromJson(e)) // Deserializamos la respuesta en objetos DataUsuario
            .whereType<DataUsuario>()
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error al obtener los usuarios: $e");
      rethrow;
    }
  }

  // AGREGAR USUARIO
  Future<bool> addUser(DataUsuario usuario) async {
    try {
      final response = await client.post('/usuarios/add', usuario.toJson());
      return response['code'] == '200';  // Verifica que la API responda correctamente
    } catch (e) {
      print("Error al agregar usuario: $e");
      return false;
    }
  }

  // ACTUALIZAR USUARIO
  Future<bool> updateUser(DataUsuario usuario) async {
    try {
      final response = await client.post('/usuarios/update', usuario.toJson());
      return response['code'] == '200';  // Asegúrate de que la respuesta sea la correcta
    } catch (e) {
      print("Error al actualizar usuario: $e");
      return false;
    }
  }

  // ELIMINAR USUARIO
  Future<bool> deleteUser(String idUsuario) async {
    try {
      final response = await client.post('/usuarios/delete', {
        'id_usuario': idUsuario,
      });
      return response['code'] == '200';  // Verifica que la API responda correctamente
    } catch (e) {
      print("Error al eliminar usuario: $e");
      return false;
    }
  }

  // ===================== AUTORES =====================
  // OBTENER AUTORES
  Future<List<DataAutor>> fetchAutores() async {
    try {
      final data = await client.get('/autores');
      if (data != null && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => DataAutor.fromJson(e))
            .whereType<DataAutor>()
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error al obtener los autores: $e");
      rethrow;
    }
  }

  // AGREGAR AUTOR
  Future<bool> addAutor(DataAutor autor) async {
    try {
      final response = await client.post('/autores/add', autor.toJson());
      return response['code'] == '200';  // Verifica que la API responda correctamente
    } catch (e) {
      print("Error al agregar autor: $e");
      return false;
    }
  }

  // ACTUALIZAR AUTOR
  Future<bool> updateAutor(DataAutor autor) async {
    try {
      final response = await client.post('/autores/update', autor.toJson());
      return response['code'] == '200';  // Asegúrate de que la respuesta sea la correcta
    } catch (e) {
      print("Error al actualizar autor: $e");
      return false;
    }
  }

  // ELIMINAR AUTOR
  Future<bool> deleteAutor(String idAutor) async {
    try {
      final response = await client.post('/autores/delete', {
        'id_autor': idAutor,
      });
      return response['code'] == '200';  // Verifica que la API responda correctamente
    } catch (e) {
      print("Error al eliminar autor: $e");
      return false;
    }
  }

  // ===================== EDITORIALES =====================
  // OBTENER EDITORIALES
  Future<List<DataEditorial>> fetchEditoriales() async {
    try {
      final data = await client.get('/editoriales');
      if (data != null && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => DataEditorial.fromJson(e))
            .whereType<DataEditorial>()
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error al obtener las editoriales: $e");
      rethrow;
    }
  }

  // AGREGAR EDITORIAL
  Future<bool> addEditorial(DataEditorial editorial) async {
    try {
      final response = await client.post('/editoriales/add', editorial.toJson());
      return response['code'] == '200';  // Verifica que la API responda correctamente
    } catch (e) {
      print("Error al agregar editorial: $e");
      return false;
    }
  }

  // ACTUALIZAR EDITORIAL
  Future<bool> updateEditorial(DataEditorial editorial) async {
    try {
      final response = await client.post('/editoriales/update', editorial.toJson());
      return response['code'] == '200';  // Asegúrate de que la respuesta sea la correcta
    } catch (e) {
      print("Error al actualizar editorial: $e");
      return false;
    }
  }

  // ELIMINAR EDITORIAL
  Future<bool> deleteEditorial(String idEditorial) async {
    try {
      final response = await client.post('/editoriales/delete', {
        'id_editorial': idEditorial,
      });
      return response['code'] == '200';  // Verifica que la API responda correctamente
    } catch (e) {
      print("Error al eliminar editorial: $e");
      return false;
    }
  }

  // ===================== CATEGORÍAS =====================
  // OBTENER CATEGORÍAS
  Future<List<DataCategoria>> fetchCategorias() async {
    try {
      final data = await client.get('/categorias');
      if (data != null && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => DataCategoria.fromJson(e))
            .whereType<DataCategoria>()
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error al obtener las categorías: $e");
      rethrow;
    }
  }

  // AGREGAR CATEGORÍA
  Future<bool> addCategoria(DataCategoria categoria) async {
    try {
      final response = await client.post('/categorias/add', categoria.toJson());
      return response['code'] == '200';  // Verifica que la API responda correctamente
    } catch (e) {
      print("Error al agregar categoría: $e");
      return false;
    }
  }

  // ACTUALIZAR CATEGORÍA
  Future<bool> updateCategoria(DataCategoria categoria) async {
    try {
      final response = await client.post('/categorias/update', categoria.toJson());
      return response['code'] == '200';  // Asegúrate de que la respuesta sea la correcta
    } catch (e) {
      print("Error al actualizar categoría: $e");
      return false;
    }
  }

  // ELIMINAR CATEGORÍA
  Future<bool> deleteCategoria(String idCategoria) async {
    try {
      final response = await client.post('/categorias/delete', {
        'id_categoria': idCategoria,
      });
      return response['code'] == '200';  // Verifica que la API responda correctamente
    } catch (e) {
      print("Error al eliminar categoría: $e");
      return false;
    }
  }

  // ===================== LIBROS =====================
  // OBTENER LIBROS
  Future<List<DataLibro>> fetchLibros() async {
    try {
      final data = await client.get('/libros');
      if (data != null && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => DataLibro.fromJson(e))
            .whereType<DataLibro>()
            .toList();
      } else {
        print("No se encontraron libros o formato de respuesta inesperado.");
        return [];
      }
    } catch (e) {
      print("Error al obtener los libros: $e");
      rethrow;
    }
  }

  // AGREGAR LIBRO
  Future<bool> addLibro(DataLibro libro) async {
    try {
      final response = await client.post('/libros/add', libro.toJson());
      return response['code'] == '200';  // Verifica la respuesta de la API
    } catch (e) {
      print("Error al agregar libro: $e");
      return false;
    }
  }

  // ACTUALIZAR LIBRO
  Future<bool> updateLibro(DataLibro libro) async {
    try {
      final response = await client.post('/libros/update', libro.toJson());
      return response['code'] == '200';  // Verifica la respuesta de la API
    } catch (e) {
      print("Error al actualizar libro: $e");
      return false;
    }
  }

  // ELIMINAR LIBRO
  Future<bool> deleteLibro(String idLibro) async {
    try {
      final response = await client.post('/libros/delete', {'id_libro': idLibro});
      return response['code'] == '200';  // Verifica la respuesta de la API
    } catch (e) {
      print("Error al eliminar libro: $e");
      return false;
    }
  }

  // ===================== PRÉSTAMOS =====================
  // OBTENER PRÉSTAMOS
  Future<List<DataPrestamo>> fetchPrestamos() async {
    try {
      final response = await client.get('/prestamos');  // Llamada a la API para obtener todos los préstamos
      if (response != null && response['data'] is List) {
        return (response['data'] as List)
            .map((e) => DataPrestamo.fromJson(e))
            .whereType<DataPrestamo>()
            .toList();
      } else {
        print("No se encontraron préstamos o el formato de respuesta es incorrecto.");
        return [];
      }
    } catch (e) {
      print("Error al obtener los préstamos: $e");
      rethrow;
    }
  }

  // FILTRAR PRÉSTAMOS POR USUARIO
  Future<List<DataPrestamo>> fetchPrestamosPorUsuario(String usuarioId) async {
    try {
      final response = await client.get('/prestamos/usuario/$usuarioId');  // Filtra préstamos por el ID de usuario
      if (response != null && response['data'] is List) {
        return (response['data'] as List)
            .map((e) => DataPrestamo.fromJson(e))
            .whereType<DataPrestamo>()
            .toList();
      } else {
        print("No se encontraron préstamos para el usuario $usuarioId.");
        return [];
      }
    } catch (e) {
      print("Error al obtener los préstamos por usuario: $e");
      rethrow;
    }
  }

  // DEVOLVER PRÉSTAMO
  Future<bool> devolverPrestamo(String idPrestamo) async {
    try {
      final response = await client.post('/prestamos/devolver', {
        'id_prestamo': idPrestamo,
      });

      // Verifica que la respuesta sea 200 (éxito)
      if (response != null && response['code'] == '200') {
        print("La devolución del préstamo fue exitosa.");
        return true;  // La devolución fue exitosa
      } else {
        print("Hubo un error al devolver el préstamo.");
        return false;  // Hubo un error al devolver el préstamo
      }
    } catch (e) {
      print("Error al devolver préstamo: $e");
      return false;  // Si ocurre un error, retornamos false
    }
  }

  // ELIMINAR PRÉSTAMO
  Future<bool> deletePrestamo(String idPrestamo) async {
    try {
      final response = await client.post('/prestamos/delete', {'id_prestamo': idPrestamo});
      if (response != null && response['code'] == '200') {
        print("El préstamo fue eliminado exitosamente.");
        return true;  // El préstamo fue eliminado correctamente
      } else {
        print("Hubo un error al eliminar el préstamo.");
        return false;  // Hubo un error al eliminar el préstamo
      }
    } catch (e) {
      print("Error al eliminar préstamo: $e");
      return false;  // Si ocurre un error, retornamos false
    }
  }

  // BUSCAR LIBROS POR CATEGORÍA
  Future<List<DataLibro>> fetchLibrosPorCategoria(String categoriaId) async {
    try {
      final response = await client.get('/libros/categoria/$categoriaId');
      if (response != null && response['data'] is List) {
        return (response['data'] as List)
            .map((e) => DataLibro.fromJson(e))
            .whereType<DataLibro>()
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error al obtener los libros por categoría: $e");
      rethrow;
    }
  }

  // BUSCAR LIBROS POR AUTOR
  Future<List<DataLibro>> fetchLibrosPorAutor(String autorId) async {
    try {
      final response = await client.get('/libros/autor/$autorId');
      if (response != null && response['data'] is List) {
        return (response['data'] as List)
            .map((e) => DataLibro.fromJson(e))
            .whereType<DataLibro>()
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error al obtener los libros por autor: $e");
      rethrow;
    }
  }

  // BUSCAR LIBROS POR EDITORIAL
  Future<List<DataLibro>> fetchLibrosPorEditorial(String editorialId) async {
    try {
      final response = await client.get('/libros/editorial/$editorialId');
      if (response != null && response['data'] is List) {
        return (response['data'] as List)
            .map((e) => DataLibro.fromJson(e))
            .whereType<DataLibro>()
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error al obtener los libros por editorial: $e");
      rethrow;
    }
  }
}
