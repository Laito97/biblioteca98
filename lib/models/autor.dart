import 'package:biblioteca97/models/usuario.dart';

class Autor {
  final int? autor_id;
  final String? autor_nom;
  final DateTime? fecha_actualizacion;
  final DateTime? fecha_creacion;
  final Usuario? usuario_actualizacion_id;
  final Usuario? usuario_creacion_id;

  Autor({
    required this.autor_id,
    required this.autor_nom,
    this.fecha_actualizacion,
    this.fecha_creacion,
    this.usuario_actualizacion_id,
    this.usuario_creacion_id,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      autor_id: json['autor_id'] ?? 0,
      autor_nom: json['autor_nom'],
      fecha_actualizacion: json['fecha_actualizacion'],
      fecha_creacion: json['fecha_creacion'],
      usuario_actualizacion_id:
          json['usuario_actualizacion_id'] != null
              ? Usuario.fromJson(json['usuario_actualizacion_id'])
              : null,
      usuario_creacion_id:
          json['usuario_creacion_id'] != null
              ? Usuario.fromJson(json['usuario_creacion_id'])
              : null,
    );
  }
}
