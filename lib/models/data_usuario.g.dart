// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataUsuario _$DataUsuarioFromJson(Map<String, dynamic> json) => DataUsuario(
  idUsuario: json['id_usuario'] as String,
  nomUsuario: json['nom_usuario'] as String,
  estadoUsuario: json['estado_usuario'] as String?,  // Modificado aquí
  contrasena: json['contrasena'] as String,
);

Map<String, dynamic> _$DataUsuarioToJson(DataUsuario instance) =>
    <String, dynamic>{
      'id_usuario': instance.idUsuario,
      'nom_usuario': instance.nomUsuario,
      'estado_usuario': instance.estadoUsuario,
      'contrasena': instance.contrasena,
    };
