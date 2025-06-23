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

  void _onDeletePrestamo(DataPrestamo prestamo) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de eliminar el préstamo con ID '${prestamo.idPrestamo}'?"),
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
      final success = await _apiService.deletePrestamo(prestamo.idPrestamo);
      if (success) {
        await _fetchPrestamos();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Préstamo eliminado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el préstamo')),
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
                                return PrestamoItemWidget(
                                  prestamo: prestamo,
                                  onDelete: _onDeletePrestamo,
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}
