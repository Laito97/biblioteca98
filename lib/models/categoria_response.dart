class CategoriaResponse {
  final String code;
  final String mensaje;
  final List<dynamic> data;

  CategoriaResponse({
    required this.code,
    required this.mensaje,
    required this.data,
  });

  factory CategoriaResponse.fromJson(Map<String, dynamic> json) {
    return CategoriaResponse(
      code: json['code'],
      mensaje: json['mensaje'],
      data: json['data'],  // Asumí que 'data' es una lista de objetos
    );
  }
}
