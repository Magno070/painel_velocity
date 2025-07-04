import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:painel_velocitynet/modules/curriculos/service/curriculo_service.dart';
import 'package:painel_velocitynet/modules/curriculos/service/model/curriculo_model.dart';
import 'package:painel_velocitynet/modules/entity/menu_entity.dart';
import 'package:painel_velocitynet/modules/curriculos/widgets/attachment.dart';

class Curriculos extends StatefulWidget {
  static const route = 'Currículos';
  final MenuEntity menu;

  const Curriculos({super.key, required this.menu});

  @override
  State<Curriculos> createState() => _CurriculosState();
}

class _CurriculosState extends State<Curriculos> {
  final CurriculosApiService _apiService = CurriculosApiService();
  final List<Usuario> _curriculos = [];
  int? _indiceExpandido;
  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _carregarCurriculos();
  }

  Future<void> _carregarCurriculos() async {
    try {
      final candidatos = await _apiService.getCandidates();
      if (!mounted) return;
      setState(() {
        _curriculos.addAll(candidatos);
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = e.toString();
        _carregando = false;
      });
    }
  }

  Future<void> _deletarCurriculo(int index) async {
    final candidato = _curriculos[index];
    final confirmacao = await _showConfirmDialog(candidato.nome);
    if (confirmacao != true) return;

    try {
      final mensagem = await _apiService.deleteCandidate(candidato.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[900],
          content: Center(child: Text('Sucesso: $mensagem')),
        ),
      );
      setState(() {
        _curriculos.removeAt(index);
        if (_indiceExpandido == index) {
          _indiceExpandido = null;
        } else if (_indiceExpandido != null && _indiceExpandido! > index) {
          _indiceExpandido = _indiceExpandido! - 1;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao deletar: ${e.toString()}',
            style: GoogleFonts.poppins(color: Colors.red),
          ),
        ),
      );
    }
  }

  Future<bool?> _showConfirmDialog(String nome) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Confirmar exclusão',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Tem certeza que deseja excluir o currículo de $nome?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(_).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(color: Colors.green),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(_).pop(true),
            child: Text(
              'Excluir',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _construirConteudoPrincipal();
  }

  //~~___________________________________________________Círculos enquanto carrega
  Widget _construirConteudoPrincipal() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    } else if (_mensagemErro != null) {
      return Center(
        child: Text(
          'Erro ao carregar: $_mensagemErro',
          style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
        ),
      );
    } else if (_curriculos.isEmpty) {
      return Center(
        child: Text(
          'Nenhum currículo encontrado.',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      );
    }
    //~~_________________________________________________Currículos

    return ListView.builder(
      itemCount: _curriculos.length,
      itemBuilder: (_, index) => _ItemCurriculo(
        usuario: _curriculos[index],
        expandido: _indiceExpandido == index,
        aoExpandir: (expandir) {
          setState(() => _indiceExpandido = expandir ? index : null);
        },
        aoDeletar: () => _deletarCurriculo(index),
      ),
    );
  }
}
//~~_________________________________________________Modelo do card de cada currículo

class _ItemCurriculo extends StatelessWidget {
  final Usuario usuario;
  final bool expandido;
  final void Function(bool) aoExpandir;
  final VoidCallback aoDeletar;

  const _ItemCurriculo({
    required this.usuario,
    required this.expandido,
    required this.aoExpandir,
    required this.aoDeletar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 3,
      shadowColor: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: expandido ? Colors.green[800]! : Colors.transparent,
        ),
      ),
      color: Colors.grey[900],
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Colors.white)),
              ),
              child: ExpansionTile(
                key: ValueKey('expansion_${usuario.id}'),
                shape: Border.all(color: Colors.transparent),
                controlAffinity: ListTileControlAffinity.leading,
                initiallyExpanded: expandido,
                onExpansionChanged: aoExpandir,
                title: Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(
                      usuario.nome,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _linhaIconeTexto(Icons.work_outline, usuario.cargo),
                    _linhaIconeTexto(
                      Icons.calendar_month,
                      'Recebido em: ${DateFormat('dd/MM/yyyy HH:mm').format(usuario.dataEnvio)}',
                    ),
                  ],
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _linhaDetalhe('Nome:', usuario.nome),
                          _linhaDetalhe('Cargo:', usuario.cargo),
                          _linhaDetalhe('Telefone:', usuario.telefone),
                          _linhaDetalhe('Email:', usuario.email),
                          _linhaDetalhe(
                            'Data de nascimento:',
                            DateFormat(
                              'dd/MM/yyyy',
                            ).format(usuario.dataNascimento),
                          ),
                          _linhaDetalhe('Descrição:', usuario.descricao),
                          const Divider(color: Colors.white),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Recebido em: ${DateFormat('dd/MM/yyyy HH:mm').format(usuario.dataEnvio)}',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 8, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [_botaoDeletar(), _attachment(context)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botaoDeletar() {
    return ElevatedButton(
      onPressed: aoDeletar,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(8),
      ),
      child: Text(
        'EXCLUIR',
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _attachment(context) {
    return TextButton(
      onPressed: () => showAttachmentDialog(context),
      style: TextButton.styleFrom(foregroundColor: Colors.green),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attachment, color: Colors.green, size: 18),
          const SizedBox(width: 4),
          Text(
            'ANEXO',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _linhaIconeTexto(IconData icone, String texto) {
    return Row(
      children: [
        Icon(icone, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _linhaDetalhe(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            valor,
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
