// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editorial_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditorialResponse _$EditorialResponseFromJson(Map<String, dynamic> json) =>
    EditorialResponse(
      code: json['code'] as String,
      mensaje: json['mensaje'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => DataEditorial.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$EditorialResponseToJson(EditorialResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'mensaje': instance.mensaje,
      'data': instance.data,
    };
