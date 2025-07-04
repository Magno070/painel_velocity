class CreatePlanModel {
  final String id;
  final String nome;
  final String imageLogo;
  final String imagesCard;
  final String decricao;
  final String idCategoria;
  final String complementar;
  final String preco;

  CreatePlanModel({
    required this.id,
    required this.nome,
    required this.imageLogo,
    required this.imagesCard,
    required this.decricao,
    required this.idCategoria,
    required this.complementar,
    required this.preco,
  });

  factory CreatePlanModel.fromJson(Map<String, dynamic> json) {
    return CreatePlanModel(
      id: json['_id'],
      nome: json['nome'],
      imageLogo: json['images'],
      imagesCard: json['images'],
      decricao: json['descricao'],
      idCategoria: json['idCategoria'],
      complementar: json['complementar'],
      preco: json['preco'],
    );
  }
}
