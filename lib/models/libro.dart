import 'package:biblioteca97/models/autor.dart';
import 'package:biblioteca97/models/categoria.dart';
import 'package:biblioteca97/models/editorial.dart';

class Libro{
  final int? libro_id;
  final String? libro_nom;
  final String? anio_publicacion;
  final String? descripcion;
  final String? edicion;
  final int? existencias;
  final DateTime? fecha_actualizacion;
  final DateTime? fecha_creacion;
  final String? isbn;
  final String? url_portada;
  final int? usuario_actualizacion_id;
  final int? usuario_creacion_id;
  final Autor? autor;
  final Categoria? categoria;
  final Editorial? editorial;

Libro({
    required this.libro_id,
    required this.libro_nom,
    required this.anio_publicacion,
    required this.descripcion,
    required this.edicion,
    required this.existencias,
    required this.fecha_actualizacion,
    required this.fecha_creacion,
    required this.isbn,
    required this.url_portada,
    required this.usuario_actualizacion_id,
    required this.usuario_creacion_id,
    required this.autor,
    required this.categoria,
    required this.editorial,
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      libro_id: json['libro_id'] ?? 0,
      libro_nom: json['libro_nom'] ?? '',
      anio_publicacion: json['anio_publicacion'] ?? '',
      descripcion: json['descripcion'] ?? '',
      edicion: json['edicion'] ?? '',
      existencias: json['existencias'] ?? 0,
      fecha_actualizacion: json['fecha_actualizacion'] != null
          ? DateTime.tryParse(json['fecha_actualizacion'])
          : null,
      fecha_creacion: json['fecha_creacion'] != null
          ? DateTime.tryParse(json['fecha_creacion'])
          : null,
      isbn: json['isbn'] ?? '',
      url_portada: json['url_portada'] ?? '',
      usuario_actualizacion_id: json['usuario_actualizacion_id'] ?? 0,
      usuario_creacion_id: json['usuario_creacion_id'] ?? 0,
      autor: Autor.fromJson(json['autor'] ?? {}),
      categoria: Categoria.fromJson(json['categoria'] ?? {}),
      editorial: Editorial.fromJson(json['editorial'] ?? {}),
    );
  }
}