// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuariosResponse _$UsuariosResponseFromJson(Map<String, dynamic> json) =>
    UsuariosResponse(
      message: json['message'] as String,
      responseCode: (json['response_code'] as num).toInt(),
      usuarios:
          (json['usuarios'] as List<dynamic>)
              .map((e) => DataUsuario.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$UsuariosResponseToJson(UsuariosResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'response_code': instance.responseCode,
      'usuarios': instance.usuarios,
    };
