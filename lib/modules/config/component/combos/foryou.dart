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
  List<Plan> plans = [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = true;
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
        ),
      );
    }

    return Container(
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Planos',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                AddPlan(
                  response: plans,
                  planService: _planService,
                  onPlanAdded: _loadPlans, // Usar _loadPlans diretamente
                ),
              ],
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 3,
            shadowColor: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 20,
                      horizontalMargin: 20,
                      border: TableBorder.all(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white70,
                      ),
                      headingTextStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      dataTextStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      headingRowHeight: 50,
                      dataRowMinHeight: 48,
                      headingRowColor: const WidgetStatePropertyAll(
                        Color.fromARGB(255, 76, 76, 76),
                      ),
                      dataRowColor:
                          WidgetStatePropertyAll<Color?>(Colors.grey[850]),
                      columns: buildPlanColumns(),
                      rows: buildPlanRows(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List<String> columnTitles = [
    'Número',
    'Nome',
    'Velocidade',
    'Valor',
    'Benefícios',
    'Ações',
  ];

  List<DataColumn> buildPlanColumns() {
    return columnTitles.map((title) {
      return DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }).toList();
  }

  List<DataRow> buildPlanRows() {
    return plans.asMap().entries.map<DataRow>((entry) {
      final index = entry.key;
      final plan = entry.value;

      return DataRow(
        cells: [
          DataCell(Center(child: Text('${index + 1}'))),
          DataCell(Center(child: Text(plan.nome))),
          DataCell(Center(child: Text('${plan.velocidade} Mbps'))),
          DataCell(
            Center(
              child: Text(
                'R\$${plan.valor}',
                style: GoogleFonts.poppins(
                  color: Colors.greenAccent,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          DataCell(Center(child: Text(plan.beneficios.length.toString()))),
          DataCell(
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EditPlan(
                    index: index,
                    response: plans,
                    onPlanUpdated: _loadPlans,
                  ),
                  const SizedBox(width: 8),
                  RemovePlan(
                    plans: plans,
                    index: index,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
