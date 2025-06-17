class Usuario {
  final String id;
  final String nome;
  final String telefone;
  final String email;
  final String funcaoEsc;
  final String? anexo; // Pode ser nulo
  final DateTime dataEnvio;
  final int v;

  Usuario({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.funcaoEsc,
    this.anexo,
    required this.dataEnvio,
    required this.v,
  });

  // Retorna null se os dados do JSON forem inválidos ou incompletos (exceto anexo)
  static Usuario? fromJson(Map<String, dynamic> json) {
    final id = json['_id'];
    final nome = json['nome'];
    final telefone = json['telefone'];
    final email = json['email'];
    final funcaoEsc = json['funcaoEsc'];
    final dataEnvioString = json['dataEnvio'];
    final v = json['__v'];
    final anexo = json['anexo'];

    // Verifica se os campos obrigatórios são nulos ou do tipo incorreto
    if (id == null ||
        nome == null ||
        telefone == null ||
        email == null ||
        funcaoEsc == null ||
        dataEnvioString == null ||
        v == null) {
      return null; // Ignora este JSON
    }

    // Verifica o tipo do anexo se estiver presente
    if (anexo != null && anexo is! String) {
      return null; // Ignora se o anexo tiver tipo inválido
    }

    DateTime parsedDataEnvio;
    try {
      parsedDataEnvio = DateTime.parse(dataEnvioString);
    } catch (e) {
      return null; // Ignora se a data não puder ser parseada
    }

    return Usuario(
      id: id,
      nome: nome,
      telefone: telefone,
      email: email,
      funcaoEsc: funcaoEsc,
      anexo: anexo as String?,
      dataEnvio: parsedDataEnvio,
      v: v,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      // Os campos nome, telefone, email, funcaoEsc agora são String, não String?
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'funcaoEsc': funcaoEsc,
      'anexo': anexo,
      'dataEnvio': dataEnvio.toIso8601String(),
      '__v': v,
    };
  }

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, funcaoEsc: $funcaoEsc, dataEnvio: $dataEnvio)';
  }
}
