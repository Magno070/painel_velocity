class Usuario {
  final String id;
  final String nome;
  final String telefone;
  final String email;
  final DateTime dataNascimento;
  final String cargo;
  final String descricao;
  final String? anexo; // Pode ser nulo
  final DateTime dataEnvio;

  Usuario({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.dataNascimento,
    required this.cargo,
    required this.descricao,
    this.anexo,
    required this.dataEnvio,
  });

  static Usuario? fromJson(Map<String, dynamic> json) {
    // Retorna null se os dados do JSON forem inválidos ou incompletos (exceto anexo)
    try {
      final String id = json['_id'];
      final String nome = json['nome'];
      final String telefone = json['telefone'];
      final String email = json['email'];
      final DateTime dataNascimento = DateTime.parse(json['dataNascimento']);
      final String cargo = json['funcaoEsc'];
      final String descricao = json['conteSobreVoce'];
      // Pode ser null, já garantido pela API como String se não for null
      final String? anexo = json['anexo'];
      final DateTime dataEnvio = DateTime.parse(json['dataEnvio']);

      return Usuario(
        id: id,
        nome: nome,
        telefone: telefone,
        email: email,
        dataNascimento: dataNascimento,
        cargo: cargo,
        descricao: descricao,
        anexo: anexo,
        dataEnvio: dataEnvio,
      );
    } catch (e) {
      // - Falha ao parsear as datas.
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'dataNascimento': dataNascimento.toIso8601String(),
      'cargo': cargo,
      'conteSobreVoce': descricao,
      'anexo': anexo,
      'dataEnvio': dataEnvio.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, telefone: $telefone, dataNascimento: $dataNascimento, cargo: $cargo, descrição: $descricao, anexo: $anexo, dataEnvio: $dataEnvio,)';
  }
}
