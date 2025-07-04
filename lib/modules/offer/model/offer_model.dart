class OfferModel {
  final String id;
  final String titulo;
  final String decricao;
  final String valor;
  final String imagem;

  OfferModel(
      {required this.id,
      required this.titulo,
      required this.decricao,
      required this.valor,
      required this.imagem});

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['_id'],
      titulo: json['title'],
      decricao: json['description'],
      valor: json['value'],
      imagem: json['image'],
    );
  }
}
