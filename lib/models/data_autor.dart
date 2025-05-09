import 'package:json_annotation/json_annotation.dart';

part 'data_autor.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class DataAutor {
  @JsonKey(name: 'id_autor')
  final String idAutor;

  @JsonKey(name: 'nom_autor')
  final String nomAutor;

  DataAutor({
    required this.idAutor,
    required this.nomAutor,
  });

  // Generados automáticamente por build_runner
  factory DataAutor.fromJson(Map<String, dynamic> json) => _$DataAutorFromJson(json);
  Map<String, dynamic> toJson() => _$DataAutorToJson(this);

  // Método para crear una nueva instancia de DataAutor con valores vacíos
  DataAutor resetData() {
    return DataAutor(idAutor: '', nomAutor: '');
  }

  @override
  String toString() {
    return this.nomAutor;
  }
}
