import 'package:biblioteca97/models/libro.dart';
import 'package:biblioteca97/models/prestamo_estado.dart';
import 'package:biblioteca97/models/usuario.dart';

class Prestamo{
  final int? prestamo_id;
  final DateTime? fecha_actualizacion;
  final DateTime? fecha_creacion;
  final DateTime? fecha_devolucion_prestamo;
  final DateTime? fecha_solicitud_prestamo;
  final Libro libro;
  final PrestamoEstado prestamo_estado;
  final int usuario_creacion_id;
  final Usuario usuario_solicita_prestamo;
Prestamo({
    required this.prestamo_id,
    required this.fecha_actualizacion,
    required this.fecha_creacion,
    required this.fecha_devolucion_prestamo,
    required this.fecha_solicitud_prestamo,
    required this.libro,
    required this.prestamo_estado,
    required this.usuario_creacion_id,
    required this.usuario_solicita_prestamo,

  });

  factory Prestamo.fromJson(Map<String, dynamic> json) {
    return Prestamo(
      prestamo_id: json['prestamo_id'] ?? 0,
      fecha_actualizacion: json['fecha_actualizacion'] != null
          ? DateTime.tryParse(json['fecha_actualizacion'])
          : null,
      fecha_creacion: json['fecha_creacion'] != null
          ? DateTime.tryParse(json['fecha_creacion'])
          : null,
      fecha_devolucion_prestamo: json['fecha_devolucion_prestamo'] != null
          ? DateTime.tryParse(json['fecha_devolucion_prestamo'])
          : null,
      fecha_solicitud_prestamo: json['fecha_solicitud_prestamo'] != null
          ? DateTime.tryParse(json['fecha_solicitud_prestamo'])
          : null,
      libro: Libro.fromJson(json['libro'] ?? {}),
      prestamo_estado: PrestamoEstado.fromJson(json['prestamo_estado'] ?? {}),
      usuario_creacion_id: json['usuario_creacion_id'] ?? 0,
      usuario_solicita_prestamo: Usuario.fromJson(json['usuario_solicita_prestamo'] ?? {}),
    );
  }
}