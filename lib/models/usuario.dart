import 'package:biblioteca97/models/persona.dart';
import 'package:biblioteca97/models/tipo_usuario.dart';

class Usuario {
  final int? usuarioId;
  final String? usuarioNombre;
  final Persona persona;
  final TipoUsuario tipoUsuario;
  final String? password;

  Usuario({
    this.usuarioId,
     this.usuarioNombre,
    required this.tipoUsuario,
    required this.persona,
    this.password
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuarioId: json['usuario_id'] ?? 0,
      usuarioNombre: json['usuario_nombre'] ?? '',
      tipoUsuario: TipoUsuario.fromJson(json['usuario_tipo'] ?? {}),
      persona: Persona.fromJson(json['persona'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "usuario_id": usuarioId,
      "usuario_nombre": usuarioNombre,
      "persona": persona.toJson(),
      "usuario_tipo_id": tipoUsuario.toJson(),
      "password": password
    };
  }
}
