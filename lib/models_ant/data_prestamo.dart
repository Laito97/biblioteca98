import 'package:json_annotation/json_annotation.dart';

part 'data_prestamo.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class DataPrestamo {
  @JsonKey(name: 'id_prestamo')
  final String idPrestamo;

  @JsonKey(name: 'isbn')
  final String isbn;

  @JsonKey(name: 'id_usuario')
  final String idUsuario;

  @JsonKey(name: 'fecha_prestamo')
  final String fechaPrestamo;

  DataPrestamo({
    required this.idPrestamo,
    required this.isbn,
    required this.idUsuario,
    required this.fechaPrestamo,
  });

  // Generados automáticamente por build_runner
  factory DataPrestamo.fromJson(Map<String, dynamic> json) => _$DataPrestamoFromJson(json);
  Map<String, dynamic> toJson() => _$DataPrestamoToJson(this);
}
