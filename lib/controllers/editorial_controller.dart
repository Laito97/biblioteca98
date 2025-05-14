import 'package:biblioteca97/models/editorial.dart';

class EditorialController {
  final String message;
  final int responseCode;
  final List<Editorial> editoriales;

  EditorialController({
    required this.message,
    required this.responseCode,
    List<Editorial>? editoriales,
  }) : editoriales = editoriales ?? []; // Inicializa lista vacía si es null

  factory EditorialController.fromJson(Map<String, dynamic> json) {
    return EditorialController(
      message: json['message'],
      responseCode: json['response_code'],
      editoriales: json['editoriales'] != null
          ? List<Editorial>.from(json['editoriales'].map((u) => Editorial.fromJson(u)))
          : [], // Lista vacía si no hay datos
    );
  }
}
