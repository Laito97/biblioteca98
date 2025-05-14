import 'package:biblioteca97/models/persona.dart';
import 'package:biblioteca97/models/tipo_usuario.dart';

class Usuario {
  final int usuarioId;
  final String usuarioNombre;
  final Persona persona;
  final TipoUsuario tipoUsuario;

  Usuario({
    required this.usuarioId,
    required this.usuarioNombre,
    required this.tipoUsuario,
    required this.persona,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuarioId: json['usuario_id'] ?? 0,
      usuarioNombre: json['usuario_nombre'] ?? '',
      tipoUsuario: TipoUsuario.fromJson(json['usuario_tipo'] ?? {}),
      persona: Persona.fromJson(json['persona'] ?? {}),
    );
  }
}
