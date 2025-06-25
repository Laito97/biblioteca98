import 'package:biblioteca97/models/persona.dart';
import 'package:biblioteca97/models/tipo_usuario.dart';

class Usuario {
  final int? usuarioId;
  final String? usuarioNombre;
  final Persona persona;
  final TipoUsuario tipoUsuario;
  final String? password;
  final DateTime? fecha_creacion;
  final DateTime? fecha_actualizacion;
   int? usuario_creacion_id;
   int? usuario_actualizacion_id;

  Usuario({
    this.usuarioId,
     this.usuarioNombre,
    required this.tipoUsuario,
    required this.persona,
    this.password,
    this.fecha_creacion,
    this.fecha_actualizacion,
    this.usuario_actualizacion_id,
    this.usuario_creacion_id
  });

  

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      usuarioId: json['usuario_id'] ?? 0,
      usuarioNombre: json['usuario_nombre'] ?? '',
      tipoUsuario: TipoUsuario.fromJson(json['usuario_tipo'] ?? {}),
      persona: Persona.fromJson(json['persona'] ?? {}),
      fecha_creacion: json['fecha_creacion'],
      fecha_actualizacion: json['fecha_actualizacion']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "usuario_id": usuarioId,
      "usuario_nombre": usuarioNombre,
      "persona": persona.toJson(),
      "usuario_tipo_id": tipoUsuario.toJson(),
      "password": password,
      "usuario_creacion_id": usuario_creacion_id,
      "usuario_actualizacion_id": usuario_actualizacion_id
    };
  }
}
