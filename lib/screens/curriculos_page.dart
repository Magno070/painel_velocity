import 'package:flutter/material.dart';
import 'package:velocity_admin_painel/models/screen_menu.dart';
import 'package:velocity_admin_painel/public/fonts/poppins.dart';

class CurriculosPage extends StatefulWidget {
  const CurriculosPage({super.key});

  @override
  State<CurriculosPage> createState() => _CurriculosPageState();
}

class _CurriculosPageState extends State<CurriculosPage> {
  late List<Map<String, String>> _curriculos;
  int? _expandedIndex; // Índice do ExpansionTile expandido

  @override
  void initState() {
    super.initState();
    _curriculos = List<Map<String, String>>.from(_initialCurriculosData);
  }

  void _deleteCurriculo(int index) {
    setState(() {
      _curriculos.removeAt(index);
      if (_expandedIndex == index) {
        _expandedIndex =
            null; // Se o item deletado for o expandido, reseta o índice
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenMenu(
      selectedItemId: 'CURRICULOS',
      pageTitleText: 'GERENCIAMENTO DE CURRÍCULOS',
      newChild: ListView.builder(
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
                            title: PoppinsBold('${curriculo['nome']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PoppinsNormal('${curriculo['vaga']}'),
                                PoppinsNormal(
                                  'Recebido em: ${curriculo['recebidoEm']}',
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
                                  PoppinsBold('Nome: '),
                                  PoppinsNormal('${curriculo['nome']}'),
                                  const SizedBox(height: 8),
                                  PoppinsBold('Cargo: '),
                                  PoppinsNormal('${curriculo['vaga']}'),
                                  const SizedBox(height: 8),
                                  PoppinsBold('Telefone: '),
                                  PoppinsNormal('${curriculo['tel']}'),
                                  const SizedBox(height: 8),
                                  PoppinsBold('Email: '),
                                  PoppinsNormal('${curriculo['email']}'),
                                  const SizedBox(height: 8),
                                  PoppinsBold('Descrição:'),
                                  PoppinsNormal(
                                    '${curriculo['descricao']}',
                                    size: 14,
                                  ),
                                  const SizedBox(height: 8),
                                  Divider(color: Colors.white),
                                  PoppinsNormal(
                                    'Recebido em: ${curriculo['recebidoEm']}',
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
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  minimumSize: const Size(100, 50),
                                ),
                                child: PoppinsBold('EXCLUIR', size: 18),
                              ),
                              SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(
                                        child: PoppinsBold(
                                          'Anexo não definido',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: PoppinsBold(
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
      ),
    );
  }
}

List<Map<String, String>> _initialCurriculosData = [
  {
    'nome': 'Magno Antonini da Luz Moraes',
    'vaga': 'Programador',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '20/07/2023 10:15',
  },
  {
    'nome': 'Magnoliaas Antonella Pereira',
    'vaga': 'Atendente',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '21/07/2023 11:30',
  },
  {
    'nome': 'Magnolioso Júnior da Silva',
    'vaga': 'Financeiro',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '22/07/2023 09:05',
  },
  {
    'nome': 'Magno Antonini da Luz Moraes',
    'vaga': 'Programador',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '20/07/2023 10:15',
  },
  {
    'nome': 'Magnoliaas Antonella Pereira',
    'vaga': 'Atendente',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '21/07/2023 11:30',
  },
  {
    'nome': 'Magnolioso Júnior da Silva',
    'vaga': 'Financeiro',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '22/07/2023 09:05',
  },
  {
    'nome': 'Magno Antonini da Luz Moraes',
    'vaga': 'Programador',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '20/07/2023 10:15',
  },
  {
    'nome': 'Magnoliaas Antonella Pereira',
    'vaga': 'Atendente',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '21/07/2023 11:30',
  },
  {
    'nome': 'Magnolioso Júnior da Silva',
    'vaga': 'Financeiro',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '22/07/2023 09:05',
  },
  {
    'nome': 'Magno Antonini da Luz Moraes',
    'vaga': 'Programador',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '20/07/2023 10:15',
  },
  {
    'nome': 'Magnoliaas Antonella Pereira',
    'vaga': 'Atendente',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '21/07/2023 11:30',
  },
  {
    'nome': 'Magnolioso Júnior da Silva',
    'vaga': 'Financeiro',
    'tel': '94991120558',
    'email': 'magnomicrosoftj@gmail.com',
    'descricao':
        'hasask skosd masodm aksokdsaocm, kmoaskmdoksd okasokdsalkdm askdopksapdl \n sakodkspld lkclxpcsp asijdoks okasokdm akjspldpsld kalksldk ksjakjdksj lkaslkck kjaskjdsk lksalkdlks lkaskdlks',
    'recebidoEm': '22/07/2023 09:05',
  },
];
