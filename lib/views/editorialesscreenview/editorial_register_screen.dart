import 'package:biblioteca97/models/editorial.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';

class EditorialRegisterScreen extends StatefulWidget {
  final Editorial? editorialEditar;

  const EditorialRegisterScreen({Key? key, this.editorialEditar}) : super(key: key);

  @override
  State<EditorialRegisterScreen> createState() => _EditorialRegisterScreenState();
}

class _EditorialRegisterScreenState extends State<EditorialRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  late ApiService _apiService;

  bool get isEditMode => widget.editorialEditar != null;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());

    if (isEditMode) {
      _nombreController.text = widget.editorialEditar!.editorial_nom ?? '';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _guardarEditorial() async {
    if (!_formKey.currentState!.validate()) return;

    final editorial = Editorial(
      editorial_id: widget.editorialEditar?.editorial_id,
      editorial_nom: _nombreController.text.trim(),
    );

    bool resultado = false;

    if (isEditMode) {
      resultado = await _apiService.registrarEditorialV2(editorial); // Asegúrate de tener este método
    } else {
      resultado = await _apiService.registrarEditorialV2(editorial);
    }

    if (resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditMode
              ? 'Editorial actualizada correctamente'
              : 'Editorial registrada correctamente'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar la editorial')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Editar Editorial' : 'Registrar Editorial'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/agregar_usuario.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    hintText: 'Nombre de la Editorial',
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    prefixIcon: const Icon(Icons.business),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa el nombre de la editorial';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onPressed: _guardarEditorial,
                    child: Text(
                      isEditMode ? 'ACTUALIZAR' : 'REGISTRAR',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
