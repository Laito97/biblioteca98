class TipoUsuario {
  final int id;
  final String nombre;

  TipoUsuario({
    required this.id,
    required this.nombre,
  });

  factory TipoUsuario.fromJson(Map<String, dynamic> json) {
    return TipoUsuario(
      id: json['usuario_tipo_id'] ?? 0,
      nombre: json['tipo_nom'] ?? '',
    );
  }
}
