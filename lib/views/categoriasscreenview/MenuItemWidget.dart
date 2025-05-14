import 'package:biblioteca97/models/categoria.dart';
import 'package:flutter/material.dart';
import '../../models_ant/data_categoria.dart';  // Asegúrate de que el archivo correcto sea importado

class MenuItemWidget extends StatelessWidget {
  final Categoria categoria;  // Cambié DataAutor por DataCategoria
  final Function(DataCategoria) onEdit;
  final Function(DataCategoria) onDelete;

  MenuItemWidget({
    required this.categoria,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(categoria.categoria_nom ?? ''),  // Usamos nomCategoria de DataCategoria
      subtitle: Text('ID: ${categoria.categoria_id}'),  // Usamos idCategoria de DataCategoria
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //IconButton(
          //  icon: Icon(Icons.edit),
          //  onPressed: () => onEdit(categoria),
          //),
          //IconButton(
          //  icon: Icon(Icons.delete),
          //  onPressed: () => onDelete(categoria),
          //),
        ],
      ),
    );
  }
}
