import 'package:json_annotation/json_annotation.dart';

part 'data_categoria.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class DataCategoria {
  @JsonKey(name: 'id_categoria')
  final String idCategoria;

  @JsonKey(name: 'nom_categoria')
  final String nomCategoria;

  DataCategoria({
    required this.idCategoria,
    required this.nomCategoria,
  });

  // Generados automáticamente por build_runner
  factory DataCategoria.fromJson(Map<String, dynamic> json) => _$DataCategoriaFromJson(json);
  Map<String, dynamic> toJson() => _$DataCategoriaToJson(this);

  // Método para crear una nueva instancia con valores vacíos
  DataCategoria resetData() {
    return DataCategoria(idCategoria: '', nomCategoria: '');
  }

  @override
  String toString() {
    return this.nomCategoria;
  }
}
