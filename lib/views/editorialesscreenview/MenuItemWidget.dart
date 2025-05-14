import 'package:biblioteca97/models/editorial.dart';
import 'package:flutter/material.dart';
import '../../models_ant/data_editorial.dart';

class MenuItemWidget extends StatelessWidget {
  final Editorial editorial;
  final Function(DataEditorial) onEdit;
  final Function(DataEditorial) onDelete;

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
        title: Text(editorial.editorial_nom ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("ID: ${editorial.editorial_id}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          //  IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          //  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
