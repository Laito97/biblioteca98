import 'package:flutter/material.dart';
import 'package:biblioteca97/models/usuario.dart';

class UsuarioProvider extends ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  void setUsuario(Usuario usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  void clearUsuario() {
    _usuario = null;
    notifyListeners();
  }
}
