import 'package:json_annotation/json_annotation.dart';
import 'data_usuario.dart';

part 'usuario_response.g.dart';

@JsonSerializable()
class UsuariosResponse {
  final String message;

  @JsonKey(name: 'response_code')
  final int responseCode;

  final List<DataUsuario> usuarios;

  UsuariosResponse({
    required this.message,
    required this.responseCode,
    required this.usuarios,
  });

  factory UsuariosResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuariosResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UsuariosResponseToJson(this);
}
