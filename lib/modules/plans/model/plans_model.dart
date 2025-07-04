class PlansModel {
  final String id;
  final String name;

  PlansModel({
    required this.id,
    required this.name,
  });

  factory PlansModel.fromJson(Map<String, dynamic> json) {
    return PlansModel(
      id: json['_id'],
      name: json['name'],
    );
  }
}
