import 'package:json_annotation/json_annotation.dart';

part 'data_editorial.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class DataEditorial {
  @JsonKey(name: 'id_editorial')
  final String idEditorial;

  @JsonKey(name: 'nom_editorial')
  final String nomEditorial;

  DataEditorial({
    required this.idEditorial,
    required this.nomEditorial,
  });

  // Generados automáticamente por build_runner
  factory DataEditorial.fromJson(Map<String, dynamic> json) => _$DataEditorialFromJson(json);
  Map<String, dynamic> toJson() => _$DataEditorialToJson(this);

  // Método para crear una nueva instancia con valores vacíos
  DataEditorial resetData() {
    return DataEditorial(idEditorial: '', nomEditorial: '');
  }

  @override
  String toString() {
    return this.nomEditorial;
  }
}
