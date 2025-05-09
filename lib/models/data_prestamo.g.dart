// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_prestamo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataPrestamo _$DataPrestamoFromJson(Map<String, dynamic> json) => DataPrestamo(
  idPrestamo: json['id_prestamo'] as String,
  isbn: json['isbn'] as String,
  idUsuario: json['id_usuario'] as String,
  fechaPrestamo: json['fecha_prestamo'] as String,
);

Map<String, dynamic> _$DataPrestamoToJson(DataPrestamo instance) =>
    <String, dynamic>{
      'id_prestamo': instance.idPrestamo,
      'isbn': instance.isbn,
      'id_usuario': instance.idUsuario,
      'fecha_prestamo': instance.fechaPrestamo,
    };
