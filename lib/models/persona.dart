class Persona {
  final int id;
  final String nombres;
  final String apellidos;
  final String dni;
  final int numcontacto;

  Persona({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.dni,
    required this.numcontacto,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      dni: json['dni'],
      numcontacto: json['num_contacto'],
    );
  }
}