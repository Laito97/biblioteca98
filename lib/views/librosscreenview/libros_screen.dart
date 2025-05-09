import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/data_libro.dart';
import 'LibroItemWidget.dart';

class LibrosScreen extends StatefulWidget {
  final ApiService apiService;

  const LibrosScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  _LibrosScreenState createState() => _LibrosScreenState();
}

class _LibrosScreenState extends State<LibrosScreen> {
  late Future<List<DataLibro>> libros;
  List<DataLibro> librosList = [];
  List<DataLibro> filteredLibros = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLibros();
    searchController.addListener(_onSearchChanged);
  }

  // Carga los libros desde la API
  void _loadLibros() {
    libros = widget.apiService.fetchLibros();
    libros.then((data) {
      setState(() {
        librosList = data;
        filteredLibros = data;
      });
    }).catchError((e) {
      print("Error al cargar los libros: $e");
    });
  }

  // Filtra los libros según el texto en el campo de búsqueda
  void _onSearchChanged() {
    setState(() {
      filteredLibros = librosList.where((libro) {
        return (libro.nomLibro?.toLowerCase() ?? '').contains(searchController.text.toLowerCase()) ||
            (libro.nomAutor?.toLowerCase() ?? '').contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  // Lógica para editar un libro
  void _onEdit(DataLibro libro) {
    TextEditingController nomLibroController = TextEditingController(text: libro.nomLibro);
    TextEditingController nomAutorController = TextEditingController(text: libro.nomAutor);
    TextEditingController existenciasController = TextEditingController(text: libro.existencias.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar Libro"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomLibroController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: nomAutorController,
              decoration: InputDecoration(labelText: 'Autor'),
            ),
            TextField(
              controller: existenciasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Existencias'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
          TextButton(
            onPressed: () async {
              // Actualizamos el libro
              libro.nomLibro = nomLibroController.text;
              libro.nomAutor = nomAutorController.text;
              libro.existencias = int.tryParse(existenciasController.text) ?? libro.existencias;

              bool success = await widget.apiService.updateLibro(libro);
              if (success) {
                setState(() {
                  _loadLibros(); // Recargamos los libros
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Libro editado con éxito")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al editar")));
              }
            },
            child: Text("Guardar Cambios"),
          ),
        ],
      ),
    );
  }

  // Lógica para eliminar un libro
  void _onDelete(DataLibro libro) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmar eliminación"),
        content: Text("¿Estás seguro de que deseas eliminar el libro '${libro.nomLibro}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Eliminar")),
        ],
      ),
    );

    if (confirm == true) {
      final success = await widget.apiService.deleteLibro(libro.isbn);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Libro eliminado")));
        _loadLibros(); // Recarga los libros
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al eliminar")));
      }
    }
  }

  // Lógica para prestar un libro
// Lógica para prestar un libro
  void _onPrestar(DataLibro libro) async {
    if (libro.existencias > 0) {
      setState(() {
        libro.existencias -= 1;
      });

      // Actualiza las existencias en el servidor
      final success = await widget.apiService.updateLibro(libro);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Has prestado el libro '${libro.nomLibro}'")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al actualizar el libro")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No hay más ejemplares disponibles")));
    }
  }


  // Lógica para agregar un libro
  void _onAddLibro() {
    TextEditingController nomLibroController = TextEditingController();
    TextEditingController nomAutorController = TextEditingController();
    TextEditingController existenciasController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Agregar Libro"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomLibroController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: nomAutorController,
              decoration: InputDecoration(labelText: 'Autor'),
            ),
            TextField(
              controller: existenciasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Existencias'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
          TextButton(
            onPressed: () async {
              DataLibro nuevoLibro = DataLibro(
                nomLibro: nomLibroController.text,
                nomAutor: nomAutorController.text,
                existencias: int.tryParse(existenciasController.text) ?? 0,
                isbn: '', // Aquí puede generarse o dejarse vacío si la API lo maneja
              );

              bool success = await widget.apiService.addLibro(nuevoLibro);
              if (success) {
                setState(() {
                  _loadLibros(); // Recargamos los libros
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Libro agregado")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al agregar libro")));
              }
            },
            child: Text("Agregar Libro"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Libros"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onAddLibro,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Buscar por autor o título",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DataLibro>>(
              future: libros,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay libros disponibles"));
                }

                return ListView.builder(
                  itemCount: filteredLibros.length,
                  itemBuilder: (context, index) {
                    final libro = filteredLibros[index];
                    return LibroItemWidget(
                      libro: libro,
                      onEdit: () => _onEdit(libro),
                      onDelete: () => _onDelete(libro),
                      onPrestar: () => _onPrestar(libro),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
