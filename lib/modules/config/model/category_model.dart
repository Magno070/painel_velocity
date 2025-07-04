class CategoryModel {
  final String idCategoryPlan;
  final String nomePlano;
  final String subTitulo;
  final String selectVisualizacao;
  final String imageLogoPlano;
  final List<String> images;

  CategoryModel(
      {required this.idCategoryPlan,
      required this.nomePlano,
      required this.subTitulo,
      required this.selectVisualizacao,
      required this.imageLogoPlano,
      required this.images});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      idCategoryPlan: json['_id'],
      nomePlano: json['nome'],
      subTitulo: json['subTitulo'],
      selectVisualizacao: json['visualizacao'],
      imageLogoPlano: json['logo'],
      images: List<String>.from(json['images']),
    );
  }
}
