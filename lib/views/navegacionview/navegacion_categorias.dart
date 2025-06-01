import 'package:flutter/material.dart';

class NavegacionCategorias extends StatefulWidget {
  const NavegacionCategorias({super.key});

  @override
  State<NavegacionCategorias> createState() => _NavegacionCategoriasState();
}

class _NavegacionCategoriasState extends State<NavegacionCategorias> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Ficción', 'icon': Icons.menu_book},
    {'name': 'Romance', 'icon': Icons.favorite},
    {'name': 'Historia', 'icon': Icons.history_edu},
    {'name': 'Tecnología', 'icon': Icons.memory},
    {'name': 'Ciencia', 'icon': Icons.science},
    {'name': 'Aventura', 'icon': Icons.travel_explore},
  ];

  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categoriesToShow =
        showAll ? categories : categories.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 7,
            blurRadius: 25,
            offset: Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y botón "Ver más"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorías',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    showAll = !showAll;
                  });
                },
                child: Text(showAll ? 'Ver menos' : 'Ver más'),
              ),
            ],
          ),
          SizedBox(height: 10),

          if (!showAll)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: categoriesToShow.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(category['icon'], size: 16),
                    label: Text(category['name'], style: TextStyle(fontWeight: FontWeight.w400),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade50,
                      foregroundColor: Colors.black87,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categoriesToShow.map((category) {
                return ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(category['icon'], size: 18),
                  label: Text(category['name']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade50,
                    foregroundColor: Colors.black87,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
