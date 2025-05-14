class AutorResponse {
  final String code;
  final String mensaje;
  final List<dynamic> data;

  AutorResponse({
    required this.code,
    required this.mensaje,
    required this.data,
  });

  factory AutorResponse.fromJson(Map<String, dynamic> json) {
    return AutorResponse(
      code: json['code'],
      mensaje: json['mensaje'],
      data: json['data'],  // Asumí que 'data' es una lista de objetos
    );
  }
}
