import 'package:biblioteca97/models/prestamo.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca97/models_ant/data_prestamo.dart';

class PrestamoItemWidget extends StatelessWidget {
  final Prestamo prestamo;
  final Function(DataPrestamo) onDelete;

  const PrestamoItemWidget({
    Key? key,
    required this.prestamo,
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
        title: Text(
          'ID Préstamo: ${prestamo.prestamo_id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Usuario ID: ${prestamo.usuario_creacion_id}\n"
          "ISBN: ${prestamo.libro.isbn}\n"
          "Fecha Préstamo: ${prestamo.fecha_solicitud_prestamo}",
        ),
        //trailing: IconButton(
        //  icon: const Icon(Icons.delete, color: Colors.red),
        //  onPressed: () => onDelete(prestamo),
        //),
      ),
    );
  }
}
