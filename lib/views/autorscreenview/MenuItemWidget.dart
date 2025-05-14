import 'package:biblioteca97/models/autor.dart';
import 'package:flutter/material.dart';
import '../../models_ant/data_autor.dart';

class MenuItemWidget extends StatelessWidget {
  final Autor autor;
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
      title: Text(autor.autor_nom ?? ''),
      subtitle: Text('ID: ${autor.autor_id}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        //  IconButton(
        //    icon: Icon(Icons.edit),
        //    onPressed: () => onEdit(autor),
        //  ),
        //  IconButton(
        //    icon: Icon(Icons.delete),
        //    onPressed: () => onDelete(autor),
        //  ),
        ],
      ),
    );
  }
}
