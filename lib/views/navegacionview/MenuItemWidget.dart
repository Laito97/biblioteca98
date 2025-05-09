import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final String menuTitle;
  final IconData menuIcon;
  final VoidCallback onTap;

  MenuItemWidget({
    required this.menuTitle,
    required this.menuIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.blueAccent,  // Cambié el color a azul para un estilo más uniforme
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(  // Agregué padding para que los elementos dentro del Card no estén pegados a los bordes
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                menuIcon,
                size: 60,  // Aumenté un poco el tamaño del ícono para mejor visibilidad
                color: Colors.white,
              ),
              SizedBox(height: 8),  // Espaciado entre el icono y el texto
              Text(
                menuTitle.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,  // Ajusté el tamaño de la fuente para que sea más legible
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
