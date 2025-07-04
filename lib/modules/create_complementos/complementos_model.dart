class CreateComplementoModel {
  final String idComplemento;
  final String nomeComplemento;
  final String imageComplemento;
  bool isChecked;
  final String? idPlan;

  CreateComplementoModel(
      {required this.idComplemento,
      required this.nomeComplemento,
      required this.imageComplemento,
      this.isChecked = false,
      this.idPlan});

  factory CreateComplementoModel.fromJson(Map<String, dynamic> json) {
    return CreateComplementoModel(
      idComplemento: json['_id'].toString(),
      nomeComplemento: json['nome'],
      imageComplemento: json['image'],
      isChecked: false,
      idPlan: json['idPlan'],
    );
  }
}
