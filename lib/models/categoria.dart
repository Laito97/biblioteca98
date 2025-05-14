
class Categoria {
  final int? categoria_id;
  final String? categoria_nom;


  Categoria({
    required this.categoria_id,
    required this.categoria_nom,

  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      categoria_id: json['categoria_id'],
      categoria_nom: json['categoria_nom'],
    );
  }
}
