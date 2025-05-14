import 'package:flutter/material.dart';
import '../../models_ant/data_editorial.dart';

class MenuItemWidget extends StatelessWidget {
  final DataEditorial editorial;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MenuItemWidget({
    Key? key,
    required this.editorial,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(editorial.nomEditorial, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("ID: ${editorial.idEditorial}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
