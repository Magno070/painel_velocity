class ItemDescription {
  final String id;
  final String titulo;
  final String texto;

  ItemDescription({
    required this.id,
    required this.titulo,
    required this.texto,
  });

  factory ItemDescription.fromJson(Map<String, dynamic> json) {
    return ItemDescription(
      id: json['_id'],
      titulo: json['name'],
      texto: json['description'],
    );
  }
}
