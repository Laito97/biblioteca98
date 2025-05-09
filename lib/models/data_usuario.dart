import 'package:json_annotation/json_annotation.dart';

part 'data_usuario.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class DataUsuario {
  @JsonKey(name: 'id_usuario')
  final String idUsuario;

  @JsonKey(name: 'nom_usuario')
  final String nomUsuario;

  @JsonKey(name: 'estado_usuario')
  final String? estadoUsuario;  // Permitir valores null

  @JsonKey(name: 'contrasena')
  final String contrasena;

  DataUsuario({
    required this.idUsuario,
    required this.nomUsuario,
    this.estadoUsuario,  // Ya no es obligatorio
    required this.contrasena,
  });

  factory DataUsuario.fromJson(Map<String, dynamic> json) => _$DataUsuarioFromJson(json);
  Map<String, dynamic> toJson() => _$DataUsuarioToJson(this);
}
