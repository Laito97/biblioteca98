import 'package:biblioteca97/models/persona.dart';
import 'package:biblioteca97/models/tipo_usuario.dart';
import 'package:biblioteca97/models/usuario.dart';
import 'package:biblioteca97/services/api_service.dart';
import 'package:flutter/material.dart';
import '../../services/api_client.dart';

class RegisterScreen extends StatefulWidget {
  final int? usuarioId; // Parámetro opcional para editar

  const RegisterScreen({Key? key, this.usuarioId}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  List<TipoUsuario> listaTipoUsuarios = [];
  late ApiService _apiService;

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isPasswordVisible = false;

  List<TipoUsuario> _tiposUsuario = [];
  TipoUsuario? _selectedTipoUsuario;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _listTipUserV2();

    if (widget.usuarioId != null) {
      _isEditing = true;
      _cargarDatosUsuario(widget.usuarioId!);
    }
  }

  Future<void> _cargarDatosUsuario(int id) async {
    try {
      Usuario usuario = await _apiService.getUsuarioById(id);
      _nombresController.text = usuario.persona?.nombres ?? '';
      _apellidosController.text = usuario.persona?.apellidos ?? '';
      _telefonoController.text = usuario.persona?.numContacto.toString() ?? '';
      _correoController.text = usuario.persona?.correo ?? '';
      _dniController.text = usuario.persona?.dni ?? '';
      _direccionController.text = usuario.persona?.direccion ?? '';
      _passwordController.text = usuario.password ?? '';

      final tipo = _tiposUsuario.firstWhere(
        (t) => t.id == usuario.tipoUsuario?.id,
        orElse: () => TipoUsuario(id: -1, nombre: 'No definido'),
      );

      setState(() {
        _selectedTipoUsuario = (tipo.id == -1) ? null : tipo;
      });
    } catch (e) {
      print("Error al cargar usuario: $e");
    }
  }

  Future<void> _listTipUserV2() async {
    try {
      listaTipoUsuarios = await _apiService.listTipUserV2();
      _tiposUsuario = List.from(listaTipoUsuarios);
      setState(() {});
    } catch (e) {
      print("Error al obtener tipos de usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Editar Usuario" : "Registro"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/agregar_usuario.png',
                  width: 200,
                  height: 120,
                ),
                const SizedBox(height: 30),

                _buildTextField(
                  controller: _nombresController,
                  hintText: 'Nombres',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _apellidosController,
                  hintText: 'Apellidos',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _telefonoController,
                  hintText: 'Número de contacto',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _correoController,
                  hintText: 'Correo electrónico',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _dniController,
                  hintText: 'DNI',
                  icon: Icons.credit_card,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _direccionController,
                  hintText: 'Dirección',
                  icon: Icons.home,
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 10),

                DropdownButtonFormField<TipoUsuario>(
                  value: _selectedTipoUsuario,
                  hint: const Text("Seleccione tipo de usuario"),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF6F6F6),
                    prefixIcon: const Icon(Icons.account_box),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _tiposUsuario.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo.nombre ?? 'Tipo ${tipo.id}'),
                    );
                  }).toList(),
                  onChanged: (TipoUsuario? value) {
                    setState(() {
                      _selectedTipoUsuario = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Seleccione un tipo de usuario';
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final persona = Persona(
                          nombres: _nombresController.text,
                          apellidos: _apellidosController.text,
                          numContacto: int.tryParse(_telefonoController.text) ?? 0,
                          correo: _correoController.text,
                          dni: _dniController.text,
                          direccion: _direccionController.text,
                        );

                        final tipoUsuario = _selectedTipoUsuario ?? TipoUsuario(id: 1);

                        final usuario = Usuario(
                          usuarioId: widget.usuarioId ?? 0,
                          persona: persona,
                          tipoUsuario: tipoUsuario,
                          password: _passwordController.text,
                        );

                        try {
                          bool exito;
                          if (_isEditing) {
                            exito = await _apiService.actualizarUsuarioV2(usuario);
                          } else {
                            exito = await _apiService.registrarUsuarioV2(usuario);
                          }

                          _showDialog(
                            exito
                                ? (_isEditing
                                    ? "Usuario actualizado con éxito"
                                    : "Usuario registrado con éxito")
                                : (_isEditing
                                    ? "No se pudo actualizar el usuario"
                                    : "No se pudo registrar el usuario"),
                          );
                        } catch (e) {
                          _showDialog("Error: $e");
                        }
                      }
                    },
                    child: Text(
                      _isEditing ? 'Actualizar' : 'Registrar',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo requerido';
        }
        return null;
      },
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Resultado"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (message.contains("éxito")) {
                _limpiarFormulario();
                if (_isEditing) {
                  Navigator.pop(context); // salir de editar y volver atrás
                }
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _limpiarFormulario() {
    _nombresController.clear();
    _apellidosController.clear();
    _correoController.clear();
    _telefonoController.clear();
    _dniController.clear();
    _direccionController.clear();
    _passwordController.clear();
    setState(() {
      _selectedTipoUsuario = null;
    });
  }
}
