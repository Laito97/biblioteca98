// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_libro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataLibro _$DataLibroFromJson(Map<String, dynamic> json) => DataLibro(
  isbn: json['isbn'] as String,
  portada: json['portada'] as String?,  // Cambiado a String? para permitir null
  nomLibro: json['nom_libro'] as String?,  // Cambiado a String? para permitir null
  nomAutor: json['autor'] as String?,  // Cambiado a String? para permitir null
  descripcion: json['descripcion'] as String?,  // Cambiado a String? para permitir null
  nomEditorial: json['editorial'] as String?,  // Cambiado a String? para permitir null
  anioPublicacion: json['anio_publicacion'] as String?,  // Cambiado a String? para permitir null
  edicion: json['edicion'] as String?,  // Cambiado a String? para permitir null
  existencias: (json['existencias'] as num).toInt(),
  nomCategoria: json['categoria'] as String?,  // Cambiado a String? para permitir null
);

Map<String, dynamic> _$DataLibroToJson(DataLibro instance) => <String, dynamic>{
  'isbn': instance.isbn,
  'portada': instance.portada,
  'nom_libro': instance.nomLibro,
  'autor': instance.nomAutor,
  'descripcion': instance.descripcion,
  'editorial': instance.nomEditorial,
  'anio_publicacion': instance.anioPublicacion,
  'edicion': instance.edicion,
  'existencias': instance.existencias,
  'categoria': instance.nomCategoria,
};
