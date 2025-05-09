import 'package:flutter/material.dart';
import '../../models/data_autor.dart';

class MenuItemWidget extends StatelessWidget {
  final DataAutor autor;
  final Function(DataAutor) onEdit;
  final Function(DataAutor) onDelete;

  MenuItemWidget({
    required this.autor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(autor.nomAutor),
      subtitle: Text('ID: ${autor.idAutor}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onEdit(autor),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(autor),
          ),
        ],
      ),
    );
  }
}
