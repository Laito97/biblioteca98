import 'package:flutter/material.dart';

class LibroDetalleView extends StatefulWidget {
  final String libroUrl;

  const LibroDetalleView({super.key, required this.libroUrl});

  @override
  State<LibroDetalleView> createState() => _LibroDetalleViewState();
}

class _LibroDetalleViewState extends State<LibroDetalleView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showImagePreview() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.libroUrl),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: _showImagePreview,
                  child: Container(
                    height: screenHeight / 3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.libroUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Título del Libro',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Autor del Libro',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Descripcion',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

      // Botones flotantes en el footer
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btn1',
            onPressed: () {
              // lógica para solicitar préstamo
            },
            icon: const Icon(Icons.library_books, color: Colors.white),
            label: const Text(
              'Solicitar préstamo',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'btn2',
            onPressed: () {
              // lógica para generar QR
            },
            icon: const Icon(Icons.qr_code, color: Colors.white),
            label: const Text(
              'Generar QR',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
