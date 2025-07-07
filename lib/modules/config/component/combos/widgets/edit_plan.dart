import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:painel_velocitynet/modules/config/component/combos/service/models/plan_model.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/plan_service.dart';
import 'package:painel_velocitynet/modules/config/component/combos/widgets/edit_plan/benefits_edit.dart'
    as benefits_edit;
import 'package:painel_velocitynet/modules/config/component/combos/widgets/edit_plan/deitails_edit.dart';

class EditPlan extends StatefulWidget {
  final int index;
  final VoidCallback onPlanUpdated;
  final List<Plan> response;

  const EditPlan({
    super.key,
    required this.index,
    required this.response,
    required this.onPlanUpdated,
  });

  @override
  State<EditPlan> createState() => _EditPlanState();
}

class _EditPlanState extends State<EditPlan>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late final TextEditingController _nomeController;
  late final TextEditingController _velocidadeController;
  late final TextEditingController _valorController;
  late final TabController _tabController;
  final GlobalKey<benefits_edit.BenefitsEditState> _benefitsKey =
      GlobalKey<benefits_edit.BenefitsEditState>();

  @override
  void initState() {
    super.initState();
    final plan = widget.response[widget.index];
    _nomeController = TextEditingController(text: plan.nome);
    _velocidadeController =
        TextEditingController(text: plan.velocidade.toString());
    _valorController = TextEditingController(text: plan.valor.toString());

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _velocidadeController.dispose();
    _valorController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveEditedPlan(BuildContext dialogContext) async {
    try {
      final original = widget.response[widget.index];
      final updated = Plan(
        id: original.id,
        nome: _nomeController.text.trim().isEmpty
            ? original.nome
            : _nomeController.text.trim(),
        velocidade: int.tryParse(_velocidadeController.text.trim()) ??
            original.velocidade,
        valor: double.tryParse(_valorController.text.trim()) ?? original.valor,
        beneficios: _benefitsKey.currentState?.getUpdatedBeneficios() ??
            original.beneficios,
      );

      await PlanService().updatePlan(updated.id, updated.toJsonForUpdate());

      if (!mounted) return;
      setState(() => widget.response[widget.index] = updated);
      widget.onPlanUpdated();

      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(
            content: Text('Plano atualizado com sucesso!'),
            backgroundColor: Colors.green),
      );
      Navigator.of(dialogContext).pop();
    } catch (e) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
            content: Text('Erro ao atualizar plano: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: Colors.yellow),
          )
        : IconButton(
            onPressed: () async {
              setState(() => _isLoading = true);
              await Future.delayed(const Duration(milliseconds: 50));
              await _showEditModal(context);
              if (mounted) setState(() => _isLoading = false);
            },
            icon: Icon(Icons.edit, color: Colors.yellow[400]),
          );
  }

  Future<void> _showEditModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      builder: (BuildContext dialogContext) {
        bool localIsUpdating = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(dialogContext, localIsUpdating),
                  const SizedBox(height: 16),
                  _buildPlanControllers(),
                  const SizedBox(height: 16),
                  Expanded(child: SingleChildScrollView(child: _buildTabs())),
                  const SizedBox(height: 8),
                  _buildActions(
                      dialogContext,
                      setModalState,
                      () => localIsUpdating = true,
                      () => localIsUpdating = false),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isUpdating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Editar plano',
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.yellow[400])),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: isUpdating ? null : () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildPlanControllers() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Informações do plano',
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildTextField(_nomeController, 'Nome do plano'),
            const SizedBox(width: 16),
            _buildTextField(_velocidadeController, 'Velocidade',
                prefixText: 'Mbps '),
            const SizedBox(width: 16),
            _buildTextField(_valorController, 'Valor', prefixText: 'R\$ '),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    final beneficios = widget.response[widget.index].beneficios;

    return SizedBox(
      height: beneficios.length * 100,
      child: Column(
        children: [
          TabBar(
            dividerHeight: 0,
            controller: _tabController,
            labelColor: Colors.black,
            labelStyle:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.poppins(fontSize: 16),
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.yellow[400],
            ),
            tabs: const [
              Tab(child: Text('Benefícios')),
              Tab(child: Text('Detalhes')),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildBeneficios(), _buildDetails()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficios() {
    return benefits_edit.BenefitsEdit(
      key: _benefitsKey,
      initialBenefits: widget.response[widget.index].beneficios,
    );
  }

  Widget _buildDetails() {
    return EditDetails(
      beneficios: widget.response[widget.index].beneficios,
    );
  }

  Widget _buildActions(
    BuildContext context,
    StateSetter setModalState,
    VoidCallback startLoading,
    VoidCallback stopLoading,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('CANCELAR',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.white70)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () async {
            setModalState(() => startLoading());
            await _saveEditedPlan(context);
            if (mounted) setModalState(() => stopLoading());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[500],
            foregroundColor: Colors.black,
          ),
          child: Text('SALVAR',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {String prefixText = ''}) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.yellow[400]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          prefixText: prefixText,
          prefixStyle: GoogleFonts.poppins(color: Colors.white),
        ),
        style: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }
}
