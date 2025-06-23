class PrestamoEstado {
  final int? estado_id;
  final String? estado_nombre;

  PrestamoEstado({
    required this.estado_id,
    required this.estado_nombre,
  });

  factory PrestamoEstado.fromJson(Map<String, dynamic> json) {
    return PrestamoEstado(
      estado_id: json['prestamo_estado_id'], // ✅ clave correcta del backend
      estado_nombre: json['descripcion'],    // ✅ clave correcta del backend
    );
  }
}
