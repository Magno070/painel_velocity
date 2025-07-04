class AdditionalModel {
  final String idAdditional;
  final String nome;
  final String image;
  final String preco;
  final String idPlans;

  AdditionalModel(
      {required this.idAdditional,
      required this.nome,
      required this.image,
      required this.preco,
      required this.idPlans});

  factory AdditionalModel.fromJson(Map<String, dynamic> json) {
    return AdditionalModel(
        idAdditional: json['_id'],
        nome: json['nome'],
        image: json['image'],
        preco: json['preco']['\$numberDecimal'],
        idPlans: json['id']);
  }
}
