
class Editorial {
  final int? editorial_id;
  final String? editorial_nom;


  Editorial({
    required this.editorial_id,
    required this.editorial_nom,

  });

  factory Editorial.fromJson(Map<String, dynamic> json) {
    return Editorial(
      editorial_id: json['editorial_id'],
      editorial_nom: json['editorial_nom'],
    );
  }
}

