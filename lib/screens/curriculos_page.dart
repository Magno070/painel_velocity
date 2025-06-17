import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:velocity_admin_painel/services/models/candidato.dart';
import 'package:velocity_admin_painel/services/get_curriculos_service.dart';

import 'package:velocity_admin_painel/models/screen_menu.dart';
import 'package:velocity_admin_painel/public/fonts/poppins.dart';

class CurriculosPage extends StatefulWidget {
  const CurriculosPage({super.key});

  @override
  State<CurriculosPage> createState() => _CurriculosPageState();
}

class _CurriculosPageState extends State<CurriculosPage> {
  List<Usuario> _curriculos = []; // Alterado para List<Usuario>
  int? _expandedIndex; // Índice do ExpansionTile expandido
  bool _isLoading = true;
  String? _errorMessage;
  final ApiService _apiService = ApiService(); // Instância do serviço

  @override
  void initState() {
    super.initState();
    _fetchCurriculos();
  }

  Future<void> _fetchCurriculos() async {
    try {
      final candidatos = await _apiService.getCandidates();
      if (mounted) {
        // Verifica se o widget ainda está na árvore
        setState(() {
          _curriculos = candidatos;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _deleteCurriculo(int index) {
    setState(() {
      // TODO: Implementar a chamada à API para deletar o currículo no backend
      // Ex: _apiService.deleteCandidate(_curriculos[index].id).then((success) {
      //   if (success && mounted) {
      //     setState(() { _curriculos.removeAt(index); ... });
      //   }
      // });
      _curriculos.removeAt(index);
      if (_expandedIndex == index) {
        _expandedIndex =
            null; // Se o item deletado for o expandido, reseta o índice
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      bodyContent = Center(
        child: Poppins(
          'Erro ao carregar: $_errorMessage',
          color: Colors.red,
          size: 16,
        ),
      );
    } else if (_curriculos.isEmpty) {
      bodyContent = Center(
        child: Poppins('Nenhum currículo encontrado.', size: 16),
      );
    } else {
      bodyContent = _buildCurriculosList();
    }

    return ScreenMenu(
      selectedItemId: 'CURRICULOS',
      pageTitleText: 'GERENCIAMENTO DE CURRÍCULOS',
      newChild: bodyContent,
    );
  }

  Widget _buildCurriculosList() {
    return ListView.builder(
      itemCount: _curriculos.length,
      itemBuilder: (BuildContext context, int index) {
        final curriculo = _curriculos[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  color: Colors.grey[900],
                  child: Row(
                    children: [
                      Expanded(
                        child: ExpansionTile(
                          key: ValueKey(
                            'expansion_$index-${_expandedIndex == index}',
                          ),
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          leading: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                          title: Poppins(
                            curriculo.nome,
                            bold: true,
                          ), // Usa curriculo.nome
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Poppins(
                                curriculo.funcaoEsc,
                              ), // Usa curriculo.funcaoEsc
                              Poppins(
                                'Recebido em: ${DateFormat('dd/MM/yyyy HH:mm').format(curriculo.dataEnvio)}', // Formata dataEnvio
                                size: 14,
                              ),
                            ],
                          ),
                          expandedAlignment: Alignment.topLeft,
                          childrenPadding: const EdgeInsets.fromLTRB(
                            16.0,
                            0,
                            16.0,
                            16.0,
                          ),
                          onExpansionChanged: (expanded) {
                            setState(() {
                              if (expanded) {
                                _expandedIndex = index;
                              } else if (_expandedIndex == index) {
                                _expandedIndex = null;
                              }
                            });
                          },
                          initiallyExpanded:
                              _expandedIndex ==
                              index, // Expande apenas o índice desejado
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Poppins(bold: true, 'Nome: '),
                                Poppins(curriculo.nome),
                                const SizedBox(height: 8),
                                Poppins(bold: true, 'Cargo: '),
                                Poppins(curriculo.funcaoEsc),
                                const SizedBox(height: 8),
                                Poppins(bold: true, 'Telefone: '),
                                Poppins(curriculo.telefone),
                                const SizedBox(height: 8),
                                Poppins(bold: true, 'Email: '),
                                Poppins(curriculo.email),
                                const SizedBox(height: 8),
                                Divider(color: Colors.white),
                                Poppins(
                                  'Recebido em: ${DateFormat('dd/MM/yyyy HH:mm').format(curriculo.dataEnvio)}',
                                  size: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _deleteCurriculo(index);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                minimumSize: const Size(100, 50),
                              ),
                              child: Poppins(bold: true, 'EXCLUIR', size: 18),
                            ),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Poppins(
                                        bold: true,
                                        'Anexo: ${curriculo.anexo}',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green,
                              ),
                              child: Poppins(
                                bold: true,
                                'ANEXO',
                                color: Colors.green,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
