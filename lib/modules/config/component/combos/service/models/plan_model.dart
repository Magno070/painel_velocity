class Plan {
  final String nome;
  final int velocidade;
  final double valor;
  final List<Beneficio> beneficios;

  Plan({
    required this.nome,
    required this.velocidade,
    required this.valor,
    required this.beneficios,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    var beneficiosList = json['beneficios'] as List? ?? [];
    List<Beneficio> beneficios = beneficiosList
        .map((beneficio) => Beneficio.fromJson(beneficio))
        .toList();

    return Plan(
      nome: json['nome'],
      velocidade: json['velocidade'].toInt(),
      valor: json['valor'].toDouble(),
      beneficios: beneficios,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'velocidade': velocidade,
      'valor': valor,
      'beneficios': beneficios.map((b) => b.toJson()).toList(),
    };
  }
}

class Beneficio {
  final String nome;
  final double valor;
  final String image;

  Beneficio({
    required this.nome,
    required this.valor,
    required this.image,
  });

  factory Beneficio.fromJson(Map<String, dynamic> json) {
    return Beneficio(
      nome: json['nome'],
      valor: json['valor'].toDouble(),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'valor': valor,
      'image': image,
    };
  }
}
