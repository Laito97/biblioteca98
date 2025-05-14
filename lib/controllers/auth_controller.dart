import 'package:biblioteca97/models/usuario.dart';

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

