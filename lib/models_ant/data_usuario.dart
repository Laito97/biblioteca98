import 'package:json_annotation/json_annotation.dart';

part 'data_usuario.g.dart';

@JsonSerializable()
class DataUsuario {
  @JsonKey(name: 'usuario_id')
  final int usuarioId;

  @JsonKey(name: 'usuario_nombre')
  final String usuarioNombre;

  @JsonKey(name: 'usuario_tipo')
  final String? usuarioTipo;  // Puede ser null

  DataUsuario({
    required this.usuarioId,
    required this.usuarioNombre,
    this.usuarioTipo,  // Puede ser null
  });

  factory DataUsuario.fromJson(Map<String, dynamic> json) => _$DataUsuarioFromJson(json);
  Map<String, dynamic> toJson() => _$DataUsuarioToJson(this);
}
