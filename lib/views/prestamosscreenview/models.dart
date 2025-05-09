// models.dart

// Clase para representar un Usuario
class DataUsuario {
  final String idUsuario;
  final String nombre;

  DataUsuario(this.idUsuario, this.nombre);

  // Constructor para crear un objeto DataUsuario a partir de un JSON
  factory DataUsuario.fromJson(Map<String, dynamic> json) {
    return DataUsuario(
      json['idUsuario'] as String,  // Asegúrate de que el campo 'idUsuario' esté en la respuesta JSON
      json['nombre'] as String,     // Asegúrate de que el campo 'nombre' esté en la respuesta JSON
    );
  }

  @override
  String toString() => '$idUsuario - $nombre';  // Para mostrar un string bonito en el Autocomplete
}

// Clase para representar un Préstamo
class DataPrestamo {
  final String idPrestamo;
  final String idUsuario;
  final String isbn;
  final String fechaPrestamo;

  DataPrestamo(this.idPrestamo, this.idUsuario, this.isbn, this.fechaPrestamo);

  // Constructor para crear un objeto DataPrestamo a partir de un JSON
  factory DataPrestamo.fromJson(Map<String, dynamic> json) {
    return DataPrestamo(
      json['idPrestamo'] as String,  // Asegúrate de que el campo 'idPrestamo' esté en la respuesta JSON
      json['idUsuario'] as String,   // Asegúrate de que el campo 'idUsuario' esté en la respuesta JSON
      json['isbn'] as String,        // Asegúrate de que el campo 'isbn' esté en la respuesta JSON
      json['fechaPrestamo'] as String, // Asegúrate de que el campo 'fechaPrestamo' esté en la respuesta JSON
    );
  }
}
