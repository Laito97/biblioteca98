class AuthResponse {
  final String accessToken;
  final String message;
  final int responseCode;
  final Usuario? usuario;

  AuthResponse({
    required this.accessToken,
    required this.message,
    required this.responseCode,
    this.usuario,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      message: json['message'],
      responseCode: json['response_code'],
      usuario: json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null,
    );
  }
}

class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final TipoUsuario? tipoUsuario;
  final Persona? persona;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    this.tipoUsuario,
    this.persona,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      tipoUsuario: json['tipo_usuario'] != null
          ? TipoUsuario.fromJson(json['tipo_usuario'])
          : null,
      persona: json['persona'] != null ? Persona.fromJson(json['persona']) : null,
    );
  }
}

class TipoUsuario {
  final int id;
  final String nombre;

  TipoUsuario({required this.id, required this.nombre});

  factory TipoUsuario.fromJson(Map<String, dynamic> json) {
    return TipoUsuario(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

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
