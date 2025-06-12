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
     this.libro_id,
     this.libro_nom,
     this.anio_publicacion,
     this.descripcion,
     this.edicion,
     this.existencias,
     this.fecha_actualizacion,
     this.fecha_creacion,
     this.isbn,
     this.url_portada,
     this.usuario_actualizacion_id,
     this.usuario_creacion_id,
     this.autor,
     this.categoria,
     this.editorial,
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

  Map<String, dynamic> toJson() {
  return {
    'libro_id': libro_id,
    'libro_nom': libro_nom,
    'anio_publicacion': anio_publicacion,
    'descripcion': descripcion,
    'edicion': edicion,
    'existencias': existencias,
    'isbn': isbn,
    'url_portada': url_portada,
    'usuario_actualizacion_id': usuario_actualizacion_id,
    'usuario_creacion_id': usuario_creacion_id,
    'categoria_id': categoria?.categoria_id,
    'editorial_id': editorial?.editorial_id,
    'autor_id': autor?.autor_id,
  };
}
}