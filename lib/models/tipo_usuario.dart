class TipoUsuario {
  final int? id;
  final String? nombre;

  TipoUsuario({
     this.id,
     this.nombre,
  });

  factory TipoUsuario.fromJson(Map<String, dynamic> json) {
    return TipoUsuario(
      id: json['usuario_tipo_id'] ?? 0,
      nombre: json['tipo_nom'] ?? '',
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre" : nombre
      };
  }
}
