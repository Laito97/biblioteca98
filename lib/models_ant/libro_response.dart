import 'package:json_annotation/json_annotation.dart';
import 'data_libro.dart';  // Asegúrate de tener el archivo 'data_libro.dart' importado

part 'libro_response.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class LibroResponse {
  final String code;
  final String mensaje;
  final List<DataLibro> data;

  LibroResponse({
    required this.code,
    required this.mensaje,
    required this.data,
  });

  // Generados automáticamente por build_runner
  factory LibroResponse.fromJson(Map<String, dynamic> json) =>
      _$LibroResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LibroResponseToJson(this);
}
