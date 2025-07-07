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
  final _planService = PlanService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Plan> _plans = [];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    try {
      _plans = await _planService.loadPlanData();
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------- UI ----------
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(),
          _plansTable(),
        ],
      ),
    );
  }

  // ---------- sub‑widgets ----------
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
            response: _plans,
            planService: _planService,
            onPlanAdded: _fetchPlans,
          ),
        ],
      ),
    );
  }

  Widget _plansTable() {
    return Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
              dataRowColor: WidgetStatePropertyAll(Colors.grey[850]),
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- helpers ----------
  final _columnTitles = [
    'Número',
    'Nome',
    'Velocidade',
    'Valor',
    'Benefícios',
    'Ações',
  ];

  List<DataColumn> _buildColumns() => _columnTitles
      .map(
        (title) => DataColumn(
          label: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )
      .toList();

  List<DataRow> _buildRows() => _plans.asMap().entries.map((entry) {
        final index = entry.key;
        final plan = entry.value;

        return DataRow(
          cells: [
            DataCell(Center(child: Text('${index + 1}'))),
            DataCell(Center(child: Text(plan.nome))),
            DataCell(Center(child: Text('${plan.velocidade} Mbps'))),
            DataCell(
              Center(
                child: Text(
                  'R\$${plan.valor}',
                  style: GoogleFonts.poppins(color: Colors.greenAccent),
                ),
              ),
            ),
            DataCell(Center(child: Text('${plan.beneficios.length}'))),
            DataCell(
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EditPlan(
                      index: index,
                      response: _plans,
                      onPlanUpdated: _fetchPlans,
                    ),
                    const SizedBox(width: 8),
                    RemovePlan(plans: _plans, index: index),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList();
}
