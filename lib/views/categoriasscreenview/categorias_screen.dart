import 'package:biblioteca97/views/navegacionview/navegacion_drawer.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca97/models/categoria.dart';
import '../../models_ant/data_categoria.dart';
import '../../services/api_client.dart';
import '../../services/api_service.dart';
import 'MenuItemWidget.dart';
import 'package:biblioteca97/views/navegacionview/navegacion_screen.dart' as custom_nav;
import 'categoria_register_screen.dart';

class CategoriaScreen extends StatefulWidget {
  @override
  _CategoriaScreenState createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {
  late ApiService _apiService;
  List<Categoria> listaCategorias = [];
  List<Categoria> filteredCategorias = [];

  bool isEditing = false;
  late DataCategoria categoriaEditando;

  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(client: ApiClient());
    _fetchCategorias();
  }

  Future<void> _fetchCategorias() async {
    try {
      listaCategorias = await _apiService.listCategoriasV2();
      filteredCategorias = listaCategorias;
      setState(() {});
    } catch (e) {
      print("Error al obtener categorías: $e");
    }
  }

  void _filterCategorias(String query) {
    final resultados = listaCategorias.where((categoria) {
      return (categoria.categoria_nom ?? '')
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCategorias = resultados;
    });
  }

  void editarCategoria(DataCategoria categoria) {
    setState(() {
      isEditing = true;
      categoriaEditando = categoria;
      idController.text = categoria.idCategoria;
      nomController.text = categoria.nomCategoria;
    });
    _showAddUpdateDialog();
  }

  void eliminarCategoria(DataCategoria categoria) async {
    print('Eliminando categoría: ${categoria.nomCategoria}');
    try {
      bool result = await _apiService.deleteCategoria(categoria.idCategoria);
      if (result) {
        _fetchCategorias();
      } else {
        print("Error al eliminar categoría.");
      }
    } catch (e) {
      print("Error al eliminar categoría: $e");
    }
  }

  void _showAddUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar Categoría' : 'Agregar Categoría'),
          content: _buildForm(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                isEditing ? _updateCategoria() : _addCategoria();
              },
              child: Text(isEditing ? 'Actualizar' : 'Agregar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: idController,
          decoration: InputDecoration(labelText: 'ID Categoría'),
          readOnly: isEditing,
        ),
        TextField(
          controller: nomController,
          decoration: InputDecoration(labelText: 'Nombre Categoría'),
        ),
      ],
    );
  }

  Future<void> _addCategoria() async {
    final categoria = DataCategoria(
      idCategoria: DateTime.now().millisecondsSinceEpoch.toString(),
      nomCategoria: nomController.text,
    );

    try {
      await _apiService.addCategoria(categoria);
      _fetchCategorias();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error al agregar categoría: $e");
    }
  }

  Future<void> _updateCategoria() async {
    final categoria = DataCategoria(
      idCategoria: idController.text,
      nomCategoria: nomController.text,
    );

    try {
      await _apiService.updateCategoria(categoria);
      _fetchCategorias();
      Navigator.of(context).pop();
    } catch (e) {
      print("Error al actualizar categoría: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriaRegisterScreen(),
                ),
              ).then((_) {
                _fetchCategorias();
              });
            },
          ),
        ],
      ),
      drawer: NavegacionDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Categoría',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCategorias,
            ),
          ),
          Expanded(
            child: filteredCategorias.isEmpty
                ? Center(child: Text('No se encontraron resultados'))
                : ListView.builder(
                    itemCount: filteredCategorias.length,
                    itemBuilder: (context, index) {
                      final categoria = filteredCategorias[index];
                      return MenuItemWidget(
                        categoria: categoria,
                        onEdit: editarCategoria,
                        onDelete: eliminarCategoria,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
