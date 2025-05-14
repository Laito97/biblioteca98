import 'package:biblioteca97/models/autor.dart';

class AutorController {
  final String message;
  final int responseCode;
  final List<Autor> autores;

  AutorController({
    required this.message,
    required this.responseCode,
    List<Autor>? autores,
  }) : autores = autores ?? []; // Inicializa lista vacía si es null

  factory AutorController.fromJson(Map<String, dynamic> json) {
    return AutorController(
      message: json['message'],
      responseCode: json['response_code'],
      autores: json['autores'] != null
          ? List<Autor>.from(json['autores'].map((u) => Autor.fromJson(u)))
          : [], // Lista vacía si no hay datos
    );
  }
}
