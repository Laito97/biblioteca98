import 'package:flutter/material.dart';
import '../../models/data_usuario.dart';

class MenuItemWidget extends StatelessWidget {
  final DataUsuario usuario;
  final Function(DataUsuario) onEdit;
  final Function(DataUsuario) onDelete;

  MenuItemWidget({
    required this.usuario,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(usuario.nomUsuario),
        subtitle: Text("ID: ${usuario.idUsuario}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => onEdit(usuario),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => onDelete(usuario),
            ),
          ],
        ),
      ),
    );
  }
}
