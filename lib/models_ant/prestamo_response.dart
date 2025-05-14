import 'package:json_annotation/json_annotation.dart';
import 'data_prestamo.dart';  // Asegúrate de tener el archivo 'data_prestamo.dart' importado

part 'prestamo_response.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class PrestamoResponse {
  final String code;
  final String mensaje;
  final List<DataPrestamo> data;

  PrestamoResponse({
    required this.code,
    required this.mensaje,
    required this.data,
  });

  // Generados automáticamente por build_runner
  factory PrestamoResponse.fromJson(Map<String, dynamic> json) =>
      _$PrestamoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PrestamoResponseToJson(this);
}
