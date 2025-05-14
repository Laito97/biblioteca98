// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'libro_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibroResponse _$LibroResponseFromJson(Map<String, dynamic> json) =>
    LibroResponse(
      code: json['code'] as String,
      mensaje: json['mensaje'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => DataLibro.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$LibroResponseToJson(LibroResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'mensaje': instance.mensaje,
      'data': instance.data,
    };
