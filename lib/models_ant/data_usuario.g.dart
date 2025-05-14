// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataUsuario _$DataUsuarioFromJson(Map<String, dynamic> json) => DataUsuario(
  usuarioId: (json['usuario_id'] as num).toInt(),
  usuarioNombre: json['usuario_nombre'] as String,
  usuarioTipo: json['usuario_tipo'] as String?,
);

Map<String, dynamic> _$DataUsuarioToJson(DataUsuario instance) =>
    <String, dynamic>{
      'usuario_id': instance.usuarioId,
      'usuario_nombre': instance.usuarioNombre,
      'usuario_tipo': instance.usuarioTipo,
    };
