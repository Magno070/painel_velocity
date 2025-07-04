// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/models/plan_model.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/plan_service.dart';
import 'package:painel_velocitynet/modules/config/component/combos/widgets/add_plan.dart';
import 'package:painel_velocitynet/modules/config/component/combos/widgets/edit_plan.dart';

import 'package:painel_velocitynet/modules/config/component/combos/widgets/remove_plan.dart';

class ForYou extends StatefulWidget {
  const ForYou({super.key});

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  final PlanService _planService = PlanService();
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> plans = [];
  // int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = false;
      _errorMessage = null;
    });

    try {
      final plansData = await _planService.loadPlanData();
      setState(() {
        plans = plansData;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
          child: Text(
        _errorMessage!,
        style: GoogleFonts.poppins(color: Colors.white),
      ));
    }

    return Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Planos',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  AddPlan(
                    response: plans,
                    planService: _planService,
                    onPlanAdded: () {
                      setState(() {});
                    },
                  ),
                ]),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: DataTable(
                    border: TableBorder.all(color: Colors.white70),
                    headingTextStyle: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    headingRowHeight: 40,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.green[700]),
                    dataRowColor: MaterialStateProperty.all(Colors.grey[850]),
                    columns: buildPlanColumns(),
                    rows: buildPlanRows(),
                  ),
                ),
                // if (_expandedIndex != null && _expandedIndex! < plans.length)
                //   Expanded(
                //     child: Column(
                //       children: [
                //         Builder(
                //           builder: (context) {
                //             final beneficios =
                //                 (plans[_expandedIndex!] as Plan).beneficios;
                //             if (beneficios.isEmpty) {
                //               return Padding(
                //                 padding: const EdgeInsets.symmetric(
                //                     horizontal: 16.0),
                //                 child: Text('Nenhum benefício cadastrado.',
                //                     style: GoogleFonts.poppins(
                //                         color: Colors.white70)),
                //               );
                //             }
                //             return SingleChildScrollView(
                //               child: DataTable(
                //                   headingRowColor: MaterialStateProperty.all(
                //                       Colors.blue[700]),
                //                   headingRowHeight: 40,
                //                   border:
                //                       TableBorder.all(color: Colors.white70),
                //                   dataRowColor: MaterialStateProperty.all(
                //                       Colors.grey[850]),
                //                   columns: buildBeneficiosColumns(),
                //                   rows: _buildBeneficiosRows(beneficios)),
                //             );
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<String> columnTitles = [
    'Numero',
    'Nome',
    'Velocidade',
    'Valor',
    'Ações',
    // 'Benefícios',
  ];

  List<DataColumn> buildPlanColumns() {
    return columnTitles
        .map(
          (title) => DataColumn(
            label: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(minWidth: 90),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  List<DataRow> buildPlanRows() {
    return plans.asMap().entries.map<DataRow>((entry) {
      final index = entry.key;
      final plan = entry.value as Plan;
      return DataRow(
        color: MaterialStateProperty.all(
            index % 2 == 0 ? Colors.grey[900] : Colors.grey[850]),
        cells: [
          DataCell(Center(
            child: Text(
              '${index + 1}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
          DataCell(Center(
              child: Text(plan.nome,
                  style: GoogleFonts.poppins(color: Colors.white)))),
          DataCell(Center(
            child: Text('${plan.velocidade} Mbps',
                style: GoogleFonts.poppins(color: Colors.white)),
          )),
          DataCell(Center(
            child: Text('R\$${plan.valor}',
                style: GoogleFonts.poppins(
                    color: Colors.greenAccent, fontSize: 16)),
          )),
          DataCell(Center(
            child: Row(
              children: [
                EditPlan(
                  index: index,
                  response: plans as List<Plan>,
                  onPlanUpdated: () => setState(() {}),
                ),
                RemovePlan(
                  plans: plans as List<Plan>,
                  index: index,
                ),
              ],
            ),
          )),
          // DataCell(
          //   Center(
          //       child: IconButton(
          //           onPressed: () {
          //             setState(() {
          //               _expandedIndex = index;
          //             });
          //           },
          //           icon: _expandedIndex == index
          //               ? const Icon(
          //                   Icons.keyboard_arrow_right_rounded,
          //                   color: Colors.blue,
          //                   size: 32,
          //                 )
          //               : const Icon(
          //                   Icons.keyboard_arrow_down_rounded,
          //                   color: Colors.green,
          //                   size: 24,
          //                 ))),
          // ),
        ],
      );
    }).toList();
  }

  // final List<String> beneficiosTitles = [
  //   'Nome',
  //   'Valor',
  //   'Imagem',
  // ];

  // List<DataColumn> buildBeneficiosColumns() {
  //   return beneficiosTitles
  //       .map((title) => DataColumn(
  //               label: Container(
  //             alignment: Alignment.center,
  //             child: Text(
  //               title,
  //               style: GoogleFonts.poppins(color: Colors.white),
  //             ),
  //           )))
  //       .toList();
  // }

  // List<DataRow> _buildBeneficiosRows(List beneficios) {
  //   return beneficios
  //       .map<DataRow>((b) => DataRow(
  //             cells: [
  //               DataCell(Text(b.nome,
  //                   style: GoogleFonts.poppins(color: Colors.white))),
  //               DataCell(Text('R\$${b.valor}',
  //                   style: GoogleFonts.poppins(color: Colors.green[200]))),
  //               DataCell(SizedBox.expand(
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(2),
  //                   child: Image.memory(
  //                     base64Decode(b.image),
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //               )),
  //             ],
  //           ))
  //       .toList();
  // }
}
