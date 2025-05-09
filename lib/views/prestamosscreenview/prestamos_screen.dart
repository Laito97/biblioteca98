import 'package:flutter/material.dart';
import 'package:biblioteca97/models/data_prestamo.dart';
import 'package:biblioteca97/services/api_service.dart';

class PrestamoScreen extends StatefulWidget {
  final ApiService apiService;

  PrestamoScreen({required this.apiService});

  @override
  _PrestamoScreenState createState() => _PrestamoScreenState();
}

class _PrestamoScreenState extends State<PrestamoScreen> {
  late Future<List<DataPrestamo>> _prestamosFuture;

  @override
  void initState() {
    super.initState();
    // Cargar los préstamos cuando se inicializa la pantalla
    _prestamosFuture = widget.apiService.fetchPrestamos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Préstamos'),
      ),
      body: FutureBuilder<List<DataPrestamo>>(
        future: _prestamosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los préstamos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay préstamos disponibles.'));
          } else {
            List<DataPrestamo> prestamos = snapshot.data!;
            return ListView.builder(
              itemCount: prestamos.length,
              itemBuilder: (context, index) {
                final prestamo = prestamos[index];
                return ListTile(
                  title: Text('ID Préstamo: ${prestamo.idPrestamo}'),
                  subtitle: Text('ISBN: ${prestamo.isbn}\nFecha: ${prestamo.fechaPrestamo}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // Lógica para devolver o eliminar préstamo (ajustar según tu lógica)
                      final success = await widget.apiService.deletePrestamo(prestamo.idPrestamo);
                      if (success) {
                        setState(() {
                          _prestamosFuture = widget.apiService.fetchPrestamos();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al eliminar el préstamo.')));
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
