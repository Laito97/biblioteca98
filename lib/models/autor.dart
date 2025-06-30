class Autor {
  final int? autor_id;
  final String? autor_nom;
  final DateTime? fecha_actualizacion;
  final DateTime? fecha_creacion;
  int? usuario_actualizacion_id;
  int? usuario_creacion_id;

  Autor({
    this.autor_id,
    required this.autor_nom,
    this.fecha_actualizacion,
    this.fecha_creacion,
    this.usuario_actualizacion_id,
    this.usuario_creacion_id,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      autor_id: json['autor_id'],
      autor_nom: json['autor_nom'],
      fecha_actualizacion:
          json['fecha_actualizacion'] != null
              ? DateTime.tryParse(json['fecha_actualizacion'])
              : null,
      fecha_creacion:
          json['fecha_creacion'] != null
              ? DateTime.tryParse(json['fecha_creacion'])
              : null,
      usuario_actualizacion_id: json['usuario_actualizacion_id'],
      usuario_creacion_id: json['usuario_creacion_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "autor_id": autor_id,
      "autor_nom": autor_nom,
      "fecha_actualizacion": fecha_actualizacion?.toIso8601String(),
      "fecha_creacion": fecha_creacion?.toIso8601String(),
      "usuario_actualizacion_id": usuario_actualizacion_id,
      "usuario_creacion_id": usuario_creacion_id,
    };
  }

  // Método específico para enviar sólo el id del usuario que modifica
  Map<String, dynamic> toJsonForDelete(int usuarioModificacionId) {
    return {
      "usuario_modificacion_id": usuarioModificacionId,
    };
  }
}
