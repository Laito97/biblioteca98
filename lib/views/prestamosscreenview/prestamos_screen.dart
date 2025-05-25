import 'package:flutter/material.dart';
import 'package:biblioteca97/models/prestamo.dart';
import 'package:biblioteca97/models_ant/data_prestamo.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'PrestamoItemWidget.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart' as custom_nav; // Asegúrate del path correcto

class PrestamosScreen extends StatefulWidget {
  final ApiService apiService;

  PrestamosScreen({required this.apiService});

  @override
  _PrestamosScreenState createState() => _PrestamosScreenState();
}

class _PrestamosScreenState extends State<PrestamosScreen> {
  late ApiService _apiService;
  late Future<List<Prestamo>> _prestamosFuture;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService;
    _fetchPrestamos();
  }

  Future<void> _fetchPrestamos() async {
    setState(() {
      _prestamosFuture = _apiService.listPrestamosV2();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Préstamos'),
        backgroundColor: Colors.red, // Puedes cambiar el color si es necesario
      ),
      drawer: const custom_nav.NavigationDrawer(), // Aquí reutilizas tu NavigationDrawer
      body: FutureBuilder<List<Prestamo>>(
        future: _prestamosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los préstamos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay préstamos disponibles.'));
          } else {
            List<Prestamo> prestamos = snapshot.data!;
            return ListView.builder(
              itemCount: prestamos.length,
              itemBuilder: (context, index) {
                final prestamo = prestamos[index];
                return PrestamoItemWidget(
                  prestamo: prestamo,
                  onDelete: _onDeletePrestamo,
                );
              },
            );
          }
        },
      ),
    );
  }

  void _onDeletePrestamo(DataPrestamo prestamo) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de eliminar el préstamo con ID '${prestamo.idPrestamo}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _apiService.deletePrestamo(prestamo.idPrestamo);
      if (success) {
        _fetchPrestamos();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Préstamo eliminado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el préstamo')),
        );
      }
    }
  }
}
