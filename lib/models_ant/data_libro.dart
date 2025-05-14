import 'package:json_annotation/json_annotation.dart';

part 'data_libro.g.dart';  // Este archivo será generado automáticamente por build_runner

@JsonSerializable()
class DataLibro {
  @JsonKey(name: 'isbn')
  String isbn;  // No es final para poder modificarlo

  @JsonKey(name: 'portada')
  String? portada;  // Cambiado a String? para permitir null

  @JsonKey(name: 'nom_libro')
  String? nomLibro;  // Cambiado a String? para permitir null

  @JsonKey(name: 'autor')
  String? nomAutor;  // Cambiado a String? para permitir null

  @JsonKey(name: 'descripcion')
  String? descripcion;  // Cambiado a String? para permitir null

  @JsonKey(name: 'editorial')
  String? nomEditorial;  // Cambiado a String? para permitir null

  @JsonKey(name: 'anio_publicacion')
  String? anioPublicacion;  // Cambiado a String? para permitir null

  @JsonKey(name: 'edicion')
  String? edicion;  // Cambiado a String? para permitir null

  @JsonKey(name: 'existencias')
  int existencias;  // Cambiado a int normal para permitir modificación

  @JsonKey(name: 'categoria')
  String? nomCategoria;  // Cambiado a String? para permitir null

  DataLibro({
    required this.isbn,
    this.portada,
    this.nomLibro,
    this.nomAutor,
    this.descripcion,
    this.nomEditorial,
    this.anioPublicacion,
    this.edicion,
    required this.existencias,
    this.nomCategoria,
  });

  // Generados automáticamente por build_runner
  factory DataLibro.fromJson(Map<String, dynamic> json) => _$DataLibroFromJson(json);
  Map<String, dynamic> toJson() => _$DataLibroToJson(this);

  // Método para crear una nueva instancia con valores vacíos
  DataLibro resetData() {
    return DataLibro(
      isbn: '',
      portada: null,  // Cambiado a null para que sea compatible con String?
      nomLibro: null,  // Cambiado a null para que sea compatible con String?
      nomAutor: null,  // Cambiado a null para que sea compatible con String?
      descripcion: null,  // Cambiado a null para que sea compatible con String?
      nomEditorial: null,  // Cambiado a null para que sea compatible con String?
      anioPublicacion: null,  // Cambiado a null para que sea compatible con String?
      edicion: null,  // Cambiado a null para que sea compatible con String?
      existencias: -1,
      nomCategoria: null,  // Cambiado a null para que sea compatible con String?
    );
  }
}
