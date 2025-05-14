// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_categoria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataCategoria _$DataCategoriaFromJson(Map<String, dynamic> json) =>
    DataCategoria(
      idCategoria: json['id_categoria'] as String,
      nomCategoria: json['nom_categoria'] as String,
    );

Map<String, dynamic> _$DataCategoriaToJson(DataCategoria instance) =>
    <String, dynamic>{
      'id_categoria': instance.idCategoria,
      'nom_categoria': instance.nomCategoria,
    };
