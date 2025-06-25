import 'package:http/http.dart' as http;
import 'dart:convert';

// ApiClient centralizado que realiza las peticiones
class ApiClient {
 final String host = 'http://192.168.1.29:3000/api/biblioteca_v1';  // Base de la API
//final String host = 'http://10.83.8.58:3000/api/biblioteca_v1';  // Base de la API
  //final String host = 'http://10.83.9.238:3000/api/biblioteca_v1';
  //final String host = 'http://10.83.9.47:3000/api/biblioteca_v1';


  // Petición GET genérica
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$host$endpoint'));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Retorna la respuesta en formato JSON
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse('$host$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    print('STATUS CODE: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      final errorBody = json.decode(response.body);
      final errorMessage = errorBody['message'] ?? 'Error desconocido';
      throw Exception('Failed to post data: $errorMessage');
    }
  }
}
