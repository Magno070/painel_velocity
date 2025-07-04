// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/models/plan_model.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/plan_service.dart';
import 'package:painel_velocitynet/modules/config/component/combos/widgets/add_plan.dart';
import 'package:painel_velocitynet/modules/config/component/combos/widgets/edit_plan.dart';
import 'dart:convert';

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
  int? _expandedIndex;

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
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tabela de planos
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 900),
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.all(Colors.green[900]),
                        dataRowColor:
                            MaterialStateProperty.all(Colors.grey[850]),
                        columnSpacing: 24,
                        columns: [
                          DataColumn(
                            label: Text('Nome',
                                style: GoogleFonts.poppins(
                                    color: Colors.green[200],
                                    fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Velocidade',
                                style: GoogleFonts.poppins(
                                    color: Colors.green[200],
                                    fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Valor',
                                style: GoogleFonts.poppins(
                                    color: Colors.green[200],
                                    fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Editar',
                                style: GoogleFonts.poppins(
                                    color: Colors.green[200],
                                    fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Excluir',
                                style: GoogleFonts.poppins(
                                    color: Colors.green[200],
                                    fontWeight: FontWeight.bold)),
                          ),
                          DataColumn(
                            label: Text('Benefícios',
                                style: GoogleFonts.poppins(
                                    color: Colors.green[200],
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                        rows: plans.asMap().entries.map<DataRow>((entry) {
                          final index = entry.key;
                          final plan = entry.value as Plan;
                          return DataRow(
                            color: MaterialStateProperty.all(index % 2 == 0
                                ? Colors.grey[900]
                                : Colors.grey[850]),
                            cells: [
                              DataCell(Text(plan.nome,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white))),
                              DataCell(Text('${plan.velocidade} Mbps',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white))),
                              DataCell(Text('R\$${plan.valor}',
                                  style: GoogleFonts.poppins(
                                      color: Colors.green[200]))),
                              DataCell(EditPlan(
                                index: index,
                                response: plans as List<Plan>,
                                onPlanUpdated: () => setState(() {}),
                              )),
                              DataCell(RemovePlan(
                                plans: plans as List<Plan>,
                                index: index,
                              )),
                              DataCell(IconButton(
                                icon: Icon(
                                    _expandedIndex == index
                                        ? Icons.arrow_forward_ios
                                        : Icons.chevron_right,
                                    color: Colors.green[200]),
                                onPressed: () {
                                  setState(() {
                                    _expandedIndex =
                                        _expandedIndex == index ? null : index;
                                  });
                                },
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                // Painel de detalhes à direita
                if (_expandedIndex != null && _expandedIndex! < plans.length)
                  Container(
                    width: 380,
                    margin: const EdgeInsets.only(left: 24),
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[900]!, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Benefícios do plano',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[200])),
                        ),
                        Builder(
                          builder: (context) {
                            final beneficios =
                                (plans[_expandedIndex!] as Plan).beneficios;
                            if (beneficios.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text('Nenhum benefício cadastrado.',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white70)),
                              );
                            }
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(minWidth: 320),
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(
                                      Colors.green[900]),
                                  dataRowColor: MaterialStateProperty.all(
                                      Colors.grey[850]),
                                  columns: [
                                    DataColumn(
                                        label: Text('Imagem',
                                            style: GoogleFonts.poppins(
                                                color: Colors.green[200],
                                                fontWeight: FontWeight.bold))),
                                    DataColumn(
                                        label: Text('Nome',
                                            style: GoogleFonts.poppins(
                                                color: Colors.green[200],
                                                fontWeight: FontWeight.bold))),
                                    DataColumn(
                                        label: Text('Valor',
                                            style: GoogleFonts.poppins(
                                                color: Colors.green[200],
                                                fontWeight: FontWeight.bold))),
                                  ],
                                  rows: beneficios
                                      .map<DataRow>((b) => DataRow(
                                            cells: [
                                              DataCell(Container(
                                                width: 48,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[700],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: b.image.isNotEmpty
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                        child: Image.memory(
                                                          base64Decode(b.image),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : const Icon(Icons.image,
                                                        color: Colors.white54,
                                                        size: 20),
                                              )),
                                              DataCell(Text(b.nome,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white))),
                                              DataCell(Text('R\$${b.valor}',
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          Colors.green[200]))),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
