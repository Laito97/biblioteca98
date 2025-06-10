import 'package:biblioteca97/models/tipo_usuario.dart';
import 'package:biblioteca97/models/usuario.dart';

class UsuarioTipoController {
  final String message;
  final int responseCode;
  final List<TipoUsuario> tipousuarios;

  UsuarioTipoController({
    required this.message,
    required this.responseCode,
    List<TipoUsuario>? tipousuarios,
  }) : tipousuarios = tipousuarios ?? []; // Inicializa lista vacía si es null

  factory UsuarioTipoController.fromJson(Map<String, dynamic> json) {
    return UsuarioTipoController(
      message: json['message'],
      responseCode: json['response_code'],
      tipousuarios: json['usuario_tipo'] != null
          ? List<TipoUsuario>.from(json['usuario_tipo'].map((u) => TipoUsuario.fromJson(u)))
          : [], // Lista vacía si no hay datos
    );
  }
}