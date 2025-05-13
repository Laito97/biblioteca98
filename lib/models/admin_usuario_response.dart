class AdminUsuarioResponse {
  final String code;
  final String mensaje;
  final List<DataAdminUsuario> data;

  AdminUsuarioResponse({
    required this.code,
    required this.mensaje,
    required this.data,
  });

  factory AdminUsuarioResponse.fromJson(Map<String, dynamic> json) {
    return AdminUsuarioResponse(
      code: json['response_code'],
      mensaje: json['message'],
      data: (json['access_token'] as List)
          .map((item) => DataAdminUsuario.fromJson(item))
          .toList(),
    );
  }

}

class DataAdminUsuario {
  final String idUsuario;
  final String nomUsuario;
  final String contrasena;

  DataAdminUsuario({
    required this.idUsuario,
    required this.nomUsuario,
    required this.contrasena,
  });

  factory DataAdminUsuario.fromJson(Map<String, dynamic> json) {
    return DataAdminUsuario(
      idUsuario: json['id_usuario'],
      nomUsuario: json['nom_usuario'],
      contrasena: json['contrasena'],
    );
  }
}
