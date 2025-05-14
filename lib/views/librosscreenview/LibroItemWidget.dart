import 'package:biblioteca97/models/libro.dart';
import 'package:flutter/material.dart';
import '../../models_ant/data_libro.dart';

class LibroItemWidget extends StatelessWidget {
  final Libro libro;
  final Function(DataLibro) onEdit;
  final Function(DataLibro) onDelete;
  final Function(DataLibro) onPrestar;

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
          libro.libro_nom ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Autor: ${libro.autor?.autor_nom ?? 'Desconocido'}\n"
          "Categoría: ${libro.categoria?.categoria_nom ?? 'Sin categoría'}\n"
          "Existencias: ${libro.existencias ?? 0}\n"
          "ISBN: ${libro.isbn ?? 'No disponible'}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          //  IconButton(
          //    icon: const Icon(Icons.edit),
          //    onPressed: () => onEdit(libro),
          //  ),
          //  IconButton(
          //    icon: const Icon(Icons.delete, color: Colors.red),
          //    onPressed: () => onDelete(libro),
          //  ),
          //  IconButton(
          //    icon: const Icon(Icons.bookmark, color: Colors.blue),
          //    onPressed: () => onPrestar(libro),
          //  ),
          ],
        ),
      ),
    );
  }
}
