import 'package:flutter/material.dart';
import '../../models/data_libro.dart';

class LibroItemWidget extends StatelessWidget {
  final DataLibro libro;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPrestar;

  const LibroItemWidget({
    Key? key,
    required this.libro,
    required this.onEdit,
    required this.onDelete,
    required this.onPrestar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          libro.nomLibro ?? 'Sin título',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Autor: ${libro.nomAutor ?? 'Desconocido'}\nCategoría: ${libro.nomCategoria ?? 'Sin categoría'}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.blue),
              onPressed: onPrestar,
            ),
          ],
        ),
      ),
    );
  }
}
