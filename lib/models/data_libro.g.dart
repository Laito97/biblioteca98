// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_libro.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataLibro _$DataLibroFromJson(Map<String, dynamic> json) => DataLibro(
  isbn: json['isbn'] as String,
  portada: json['portada'] as String?,
  nomLibro: json['nom_libro'] as String?,
  nomAutor: json['autor'] as String?,
  descripcion: json['descripcion'] as String?,
  nomEditorial: json['editorial'] as String?,
  anioPublicacion: json['anio_publicacion'] as String?,
  edicion: json['edicion'] as String?,
  existencias: (json['existencias'] as num).toInt(),
  nomCategoria: json['categoria'] as String?,
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
