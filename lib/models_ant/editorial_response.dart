import 'package:json_annotation/json_annotation.dart';
import 'data_editorial.dart';  // Asegúrate de tener el archivo 'data_editorial.dart' importado

part 'editorial_response.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class EditorialResponse {
  final String code;
  final String mensaje;
  final List<DataEditorial> data;

  EditorialResponse({
    required this.code,
    required this.mensaje,
    required this.data,
  });

  // Generados automáticamente por build_runner
  factory EditorialResponse.fromJson(Map<String, dynamic> json) =>
      _$EditorialResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EditorialResponseToJson(this);
}
