class Persona {
  final int id;
  final String nombres;
  final String apellidos;
  final String dni;
  final int numContacto;
  final String correo;
  final String direccion;

  Persona({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.dni,
    required this.numContacto,
    required this.correo,
    required this.direccion,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['persona_id'] ?? 0,
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      dni: json['dni'] ?? '',
      numContacto: json['num_contacto'] ?? 0,
      correo: json['correo'] ?? '',
      direccion: json['direccion'] ?? '',
    );
  }
}
