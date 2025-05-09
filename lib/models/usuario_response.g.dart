// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioResponse _$UsuarioResponseFromJson(Map<String, dynamic> json) =>
    UsuarioResponse(
      code: json['code'] as String,
      mensaje: json['mensaje'] as String,
      data:
          (json['data'] as List<dynamic>)
              .map((e) => DataUsuario.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$UsuarioResponseToJson(UsuarioResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'mensaje': instance.mensaje,
      'data': instance.data,
    };
