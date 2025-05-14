import 'package:biblioteca97/models/persona.dart';
import 'package:biblioteca97/models/tipo_usuario.dart';

class Usuario {
  final int? id;
  final String? nombre;
  final String? correo;
  final TipoUsuario? tipoUsuario;
  final Persona? persona;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    this.tipoUsuario,
    this.persona,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      nombre: json['nombre'],
      correo: json['correo'],
      tipoUsuario: json['tipo_usuario'] != null
          ? TipoUsuario.fromJson(json['tipo_usuario'])
          : null,
      persona: json['persona'] != null ? Persona.fromJson(json['persona']) : null,
    );
  }
}