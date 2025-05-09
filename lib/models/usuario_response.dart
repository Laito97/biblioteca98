import 'package:json_annotation/json_annotation.dart';
import 'data_usuario.dart';  // Asegúrate de tener el archivo 'data_usuario.dart' importado

part 'usuario_response.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class UsuarioResponse {
  final String code;
  final String mensaje;
  final List<DataUsuario> data;

  UsuarioResponse({
    required this.code,
    required this.mensaje,
    required this.data,
  });

  // Generados automáticamente por build_runner
  factory UsuarioResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioResponseToJson(this);
}
