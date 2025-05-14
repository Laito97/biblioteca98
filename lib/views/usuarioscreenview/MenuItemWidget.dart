import 'package:biblioteca97/models/usuario.dart';
import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final Usuario usuario;


  MenuItemWidget({
    required this.usuario
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(usuario.usuarioNombre),
        subtitle: Text("ID: ${usuario.tipoUsuario.nombre}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   icon: Icon(Icons.edit),
            //   onPressed: () => onEdit(usuario),
            // ),
            // IconButton(
            //   icon: Icon(Icons.delete),
            //   onPressed: () => onDelete(usuario),
            // ),
          ],
        ),
      ),
    );
  }
}
