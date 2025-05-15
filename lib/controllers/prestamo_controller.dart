import 'package:biblioteca97/models/prestamo.dart';
import 'package:biblioteca97/models/usuario.dart';

class PrestamoController {
  final String message;
  final int responseCode;
  final List<Prestamo> prestamos;

  PrestamoController({
    required this.message,
    required this.responseCode,
    List<Prestamo>? prestamos,
  }) : prestamos = prestamos ?? []; // Inicializa lista vacía si es null

  factory PrestamoController.fromJson(Map<String, dynamic> json) {
    return PrestamoController(
      message: json['message'],
      responseCode: json['response_code'],
      prestamos: json['prestamos'] != null
          ? List<Prestamo>.from(json['prestamos'].map((u) => Prestamo.fromJson(u)))
          : [], // Lista vacía si no hay datos
    );
  }
}