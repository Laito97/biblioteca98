import 'package:flutter/material.dart';

import 'package:biblioteca97/models/prestamo.dart';
import 'package:biblioteca97/models_ant/data_prestamo.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'package:biblioteca97/services/api_client.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
import 'PrestamoItemWidget.dart';

class PrestamosScreen extends StatefulWidget {
  const PrestamosScreen({super.key});

  @override
  _PrestamosScreenState createState() => _PrestamosScreenState();
}

class _PrestamosScreenState extends State<PrestamosScreen> {
  late ApiService _apiService;
  List<Prestamo> prestamos = [];
  List<Prestamo> filteredPrestamos = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchPrestamos();
  }

  Future<void> _fetchPrestamos() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      prestamos = await _apiService.listPrestamosV2();
      filteredPrestamos = prestamos;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error al obtener préstamos: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _filterPrestamos(String query) {
    final resultados = prestamos.where((prestamo) {
      final id = prestamo.prestamo_id?.toString() ?? '';
      return id.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredPrestamos = resultados;
    });
  }

  // Aquí mostramos el diálogo cuando pulsamos el item
  void _mostrarOpcionesPrestamo(Prestamo prestamo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Opciones para préstamo ID ${prestamo.prestamo_id}'),
        content: const Text('¿Qué desea hacer?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _onDeletePrestamo(prestamo);
            },
            child: const Text('Eliminar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  // Función para eliminar el préstamo (usando tu DataPrestamo no es necesario, usamos Prestamo)
  void _onDeletePrestamo(Prestamo prestamo) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de eliminar el préstamo con ID '${prestamo.prestamo_id}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Aquí se asume que tienes el usuarioModificacionId de alguna manera
        // Por ahora, lo pongo fijo como 1, cámbialo según corresponda
        await _apiService.deletePrestamoById(prestamo.prestamo_id, 1);
        await _fetchPrestamos();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Préstamo eliminado')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el préstamo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préstamos'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Agregar préstamo',
            onPressed: () {
              Navigator.pushNamed(context, '/registrar-prestamo');
            },
          ),
        ],
      ),
      drawer: NavegacionDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(child: Text('Error al cargar los préstamos.'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          labelText: 'Buscar por ID de préstamo',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: _filterPrestamos,
                      ),
                    ),
                    Expanded(
                      child: filteredPrestamos.isEmpty
                          ? const Center(child: Text('No se encontraron resultados'))
                          : ListView.builder(
                              itemCount: filteredPrestamos.length,
                              itemBuilder: (context, index) {
                                final prestamo = filteredPrestamos[index];
                                return GestureDetector(
                                  onTap: () => _mostrarOpcionesPrestamo(prestamo),
                                  child: PrestamoItemWidget(
                                    prestamo: prestamo,
                                    onDelete: (_) {}, // Se mantiene pero no se usa aquí
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
