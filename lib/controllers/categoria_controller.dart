import 'package:biblioteca97/models/categoria.dart';

class CategoriaController {
  final String message;
  final int responseCode;
  final List<Categoria> categorias;

  CategoriaController({
    required this.message,
    required this.responseCode,
    List<Categoria>? categorias,
  }) : categorias = categorias ?? []; // Inicializa lista vacía si es null

  factory CategoriaController.fromJson(Map<String, dynamic> json) {
    return CategoriaController(
      message: json['message'],
      responseCode: json['response_code'],
      categorias: json['categorias'] != null
          ? List<Categoria>.from(json['categorias'].map((u) => Categoria.fromJson(u)))
          : [], // Lista vacía si no hay datos
    );
  }
}