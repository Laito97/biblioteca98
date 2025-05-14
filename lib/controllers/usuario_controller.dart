import 'package:biblioteca97/models/usuario.dart';

class UsuarioController {
  final String message;
  final int responseCode;
  final List<Usuario> usuarios;

  UsuarioController({
    required this.message,
    required this.responseCode,
    List<Usuario>? usuarios,
  }) : usuarios = usuarios ?? []; // Inicializa lista vacía si es null

  factory UsuarioController.fromJson(Map<String, dynamic> json) {
    return UsuarioController(
      message: json['message'],
      responseCode: json['response_code'],
      usuarios: json['usuarios'] != null
          ? List<Usuario>.from(json['usuarios'].map((u) => Usuario.fromJson(u)))
          : [], // Lista vacía si no hay datos
    );
  }
}
