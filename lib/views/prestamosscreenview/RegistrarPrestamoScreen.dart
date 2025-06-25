import 'package:biblioteca97/utils/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biblioteca97/models/usuario.dart';
import 'package:biblioteca97/models/libro.dart';
import 'package:biblioteca97/models/prestamo_estado.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'package:biblioteca97/services/api_client.dart';

class RegistrarPrestamoScreen extends StatefulWidget {
  const RegistrarPrestamoScreen({Key? key}) : super(key: key);

  @override
  State<RegistrarPrestamoScreen> createState() => _RegistrarPrestamoScreenState();
}

class _RegistrarPrestamoScreenState extends State<RegistrarPrestamoScreen> {
  late ApiService apiService;

  List<Usuario> usuarios = [];
  List<Libro> libros = [];
  List<PrestamoEstado> estados = [];

  Usuario? usuarioSolicita;
  Libro? libroSeleccionado;
  PrestamoEstado? estadoSeleccionado;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(client: ApiClient());
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final listUsuarios = await apiService.listUserV2();
      final listLibros = await apiService.listLibrosV2();
      final listEstados = await apiService.listEstadosPrestamoV2();

      setState(() {
        usuarios = listUsuarios;
        libros = listLibros;
        estados = listEstados;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando datos: $e')),
      );
    }
  }

  String formatDateTime(DateTime dt) {
    return "${dt.year.toString().padLeft(4, '0')}-"
           "${dt.month.toString().padLeft(2, '0')}-"
           "${dt.day.toString().padLeft(2, '0')} "
           "${dt.hour.toString().padLeft(2, '0')}:"
           "${dt.minute.toString().padLeft(2, '0')}:"
           "${dt.second.toString().padLeft(2, '0')}";
  }

  void registrarPrestamo() async {
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    if (usuarioSolicita == null || libroSeleccionado == null || estadoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos')),
      );
      return;
    }
    if (usuarioProvider.usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay usuario logueado')),
      );
      return;
    }

    final now = DateTime.now();
    final fechaSolicitud = formatDateTime(now);
    final fechaDevolucion = formatDateTime(now.add(const Duration(days: 7)));

    final Map<String, dynamic> prestamoJson = {
      "libro_id": libroSeleccionado!.libro_id,
      "usuario_solicita_prestamo": usuarioSolicita!.usuarioId,
      "usuario_aprueba_prestamo": usuarioProvider.usuario!.usuarioId,
      "fecha_solicitud_prestamo": fechaSolicitud,
      "fecha_devolucion_prestamo": fechaDevolucion,
      "prestamo_estado_id": estadoSeleccionado!.estado_id,
      "usuario_creacion_id": usuarioProvider.usuario!.usuarioId,
    };

    final success = await apiService.registrarPrestamoV2(prestamoJson);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Préstamo registrado correctamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar préstamo')),
      );
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.person),
      filled: true,
      fillColor: const Color(0xFFF6F6F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Préstamo'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  Image.asset(
                    'assets/agregar_usuario.png',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<Usuario>(
                    decoration: _inputDecoration('Usuario que solicita'),
                    value: usuarioSolicita,
                    items: usuarios
                        .map((u) => DropdownMenuItem<Usuario>(
                              value: u,
                              child: Text(u.persona?.nombres ?? 'Usuario ${u.usuarioId}'),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => usuarioSolicita = val),
                    validator: (value) => value == null ? 'Por favor selecciona usuario' : null,
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<Libro>(
                    decoration: _inputDecoration('Libro'),
                    value: libroSeleccionado,
                    items: libros
                        .map((l) => DropdownMenuItem<Libro>(
                              value: l,
                              child: Text(l.libro_nom ?? 'Libro ${l.libro_id}'),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => libroSeleccionado = val),
                    validator: (value) => value == null ? 'Por favor selecciona libro' : null,
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<PrestamoEstado>(
                    decoration: _inputDecoration('Estado del préstamo'),
                    value: estadoSeleccionado,
                    items: estados
                        .map((e) => DropdownMenuItem<PrestamoEstado>(
                              value: e,
                              child: Text(e.estado_nombre ?? 'Estado ${e.estado_id}'),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => estadoSeleccionado = val),
                    validator: (value) => value == null ? 'Por favor selecciona estado' : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    enabled: false,
                    initialValue: usuarioProvider.usuario?.usuarioNombre ?? 'No logueado',
                    decoration: _inputDecoration('Usuario que aprueba (tú)'),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      onPressed: registrarPrestamo,
                      child: const Text(
                        'REGISTRAR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
