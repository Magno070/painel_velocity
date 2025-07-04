class TvModel {
  final String id;
  final String titulo;
  final String decricao;
  final String valor;
  final String imagem;

  TvModel({
    required this.id,
    required this.titulo,
    required this.decricao,
    required this.valor,
    required this.imagem,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) {
    return TvModel(
      id: json['_id'],
      titulo: json['title'],
      decricao: json['description'],
      valor: json['value'],
      imagem: json['image'],
    );
  }
}
