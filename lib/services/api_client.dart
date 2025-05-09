import 'package:http/http.dart' as http;
import 'dart:convert';

// ApiClient centralizado que realiza las peticiones
class ApiClient {
  final String baseUrl = 'http://192.168.1.16:3000';  // Base de la API

  // Petición GET genérica
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);  // Retorna la respuesta en formato JSON
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Petición POST genérica
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);  // Retorna la respuesta en formato JSON
    } else {
      throw Exception('Failed to post data');
    }
  }
}
