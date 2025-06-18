import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:velocity_admin_painel/models/campo_anexo.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';
import 'package:velocity_admin_painel/public/fonts/poppins.dart';
import 'package:velocity_admin_painel/services/models/candidato.dart';
import 'package:velocity_admin_painel/services/api_curriculos_service.dart';

class CurriculosPage extends StatefulWidget {
  const CurriculosPage({super.key});

  @override
  State<CurriculosPage> createState() => _CurriculosPageState();
}

class _CurriculosPageState extends State<CurriculosPage> {
  final ApiService _apiService = ApiService();
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
    final confirmacao = await _mostrarDialogoConfirmacao(candidato.nome);
    if (confirmacao != true) return;

    try {
      final mensagem = await _apiService.deleteCandidate(candidato.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[900],
          content: Center(child: Poppins('Sucesso: $mensagem')),
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
          content: Poppins(
            'Erro ao deletar: ${e.toString()}',
            color: Colors.red,
          ),
        ),
      );
    }
  }

  Future<bool?> _mostrarDialogoConfirmacao(String nome) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Poppins('Confirmar exclusão', size: 20, bold: true),
            content: Poppins(
              'Tem certeza que deseja excluir o currículo de $nome?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Poppins('Cancelar', color: Colors.green),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Poppins('Excluir', color: Colors.red),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMenu(
      selectedItemId: 'CURRICULOS',
      pageTitleText: 'GERENCIAMENTO DE CURRÍCULOS',
      newChild: _construirConteudoPrincipal(),
    );
  }

  Widget _construirConteudoPrincipal() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    } else if (_mensagemErro != null) {
      return Center(
        child: Poppins('Erro ao carregar: $_mensagemErro', color: Colors.red),
      );
    } else if (_curriculos.isEmpty) {
      return Center(child: Poppins('Nenhum currículo encontrado.', size: 16));
    }
    return ListView.builder(
      itemCount: _curriculos.length,
      itemBuilder:
          (_, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: _ItemCurriculo(
              usuario: _curriculos[index],
              expandido: _indiceExpandido == index,
              aoExpandir: (expandir) {
                setState(() => _indiceExpandido = expandir ? index : null);
              },
              aoDeletar: () => _deletarCurriculo(index),
            ),
          ),
    );
  }
}

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: expandido ? Colors.white70 : Colors.transparent,
        ),
      ),
      color: Colors.grey[900],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
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
                  Expanded(child: Poppins(usuario.nome, bold: true)),
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
                    const SizedBox(height: 8),
                    _linhaDetalhe('Nome:', usuario.nome),
                    _linhaDetalhe('Cargo:', usuario.cargo),
                    _linhaDetalhe('Telefone:', usuario.telefone),
                    _linhaDetalhe('Email:', usuario.email),
                    _linhaDetalhe(
                      'Data de nascimento:',
                      DateFormat('dd/MM/yyyy').format(usuario.dataNascimento),
                    ),
                    _linhaDetalhe('Descrição:', usuario.descricao),
                    const Divider(color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Poppins(
                        'Recebido em: ${DateFormat('dd/MM/yyyy HH:mm').format(usuario.dataEnvio)}',
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(children: [_botaoDeletar(), _anexoButton(context)]),
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
      child: Poppins(bold: true, 'EXCLUIR'),
    );
  }

  Widget _anexoButton(context) {
    return TextButton(
      onPressed: () => mostrarAnexoDialog(context),
      style: TextButton.styleFrom(foregroundColor: Colors.green),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.attachment, color: Colors.green, size: 18),
          SizedBox(width: 4),
          Poppins(bold: true, 'ANEXO', color: Colors.green),
        ],
      ),
    );
  }

  Widget _linhaIconeTexto(IconData icone, String texto) {
    return Row(
      children: [
        Icon(icone, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Poppins(texto, color: Colors.white70)),
      ],
    );
  }

  Widget _linhaDetalhe(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Poppins(label, bold: true),
          Poppins(valor, color: Colors.white70),
        ],
      ),
    );
  }
}
