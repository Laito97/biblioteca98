// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prestamo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrestamoResponse _$PrestamoResponseFromJson(Map<String, dynamic> json) =>
    PrestamoResponse(
      code: json['code'] as String,
      mensaje: json['mensaje'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => DataPrestamo.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$PrestamoResponseToJson(PrestamoResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'mensaje': instance.mensaje,
      'data': instance.data,
    };
