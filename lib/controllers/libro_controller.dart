import 'package:biblioteca97/models/libro.dart';

class LibroController {
  final String message;
  final int responseCode;
  final List<Libro> libros;

  LibroController({
    required this.message,
    required this.responseCode,
    List<Libro>? libros,
  }) : libros = libros ?? []; // Inicializa lista vacía si es null

  factory LibroController.fromJson(Map<String, dynamic> json) {
    return LibroController(
      message: json['message'],
      responseCode: json['response_code'],
      libros: json['libros'] != null
          ? List<Libro>.from(json['libros'].map((u) => Libro.fromJson(u)))
          : [], // Lista vacía si no hay datos
    );
  }
}