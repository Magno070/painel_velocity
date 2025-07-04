import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/models/plan_model.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/plan_service.dart';

class EditPlan extends StatefulWidget {
  final int index;
  final VoidCallback onPlanUpdated;
  final List<Plan> response;
  const EditPlan(
      {super.key,
      required this.index,
      required this.response,
      required this.onPlanUpdated});

  @override
  State<EditPlan> createState() => _EditPlanState();
}

class _EditPlanState extends State<EditPlan> {
  bool isUpdating = false;

  late final TextEditingController _nomeController;
  late final TextEditingController _velocidadeController;
  late final TextEditingController _valorController;

  final List<TextEditingController> _beneficioNomeControllers = [];
  final List<TextEditingController> _beneficioValorControllers = [];

  @override
  void initState() {
    super.initState();
    final plan = widget.response[widget.index];
    _nomeController = TextEditingController(text: plan.nome);
    _velocidadeController =
        TextEditingController(text: plan.velocidade.toString());
    _valorController = TextEditingController(text: plan.valor.toString());

    final List<Beneficio> beneficios = plan.beneficios;
    for (var beneficio in beneficios) {
      _beneficioNomeControllers
          .add(TextEditingController(text: beneficio.nome));
      _beneficioValorControllers
          .add(TextEditingController(text: beneficio.valor.toString()));
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _velocidadeController.dispose();
    _valorController.dispose();
    for (var controller in _beneficioNomeControllers) {
      controller.dispose();
    }
    for (var controller in _beneficioValorControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return TextButton(
      onPressed: () {
        _showAddPlanDialog(context);
      },
      child: Icon(
        Icons.edit,
        color: Colors.yellow[400]!,
      ),
    );
  }

  void _showAddPlanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          elevation: 3,
          shadowColor: Colors.white70,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 900,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Editar plano',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[400]!,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _editPlanControllers(),
                  _buildPlanTabs(),
                  const SizedBox(
                    height: 12,
                  ),
                  _editActions(dialogContext)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildPlanTabs() {
    Color tabColor = Colors.yellow[400]!;
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(
                child: Text(
              'Benefícios',
              style: GoogleFonts.poppins(color: tabColor, fontSize: 18),
            )),
            Tab(
                child: Text(
              'Detalhes',
              style: GoogleFonts.poppins(color: tabColor, fontSize: 18),
            )),
          ]),
          SizedBox(
            height: 350, // ajuste conforme necessário
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  child: _editBeneficiosController(),
                ),
                const Placeholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTextField(TextEditingController controller, String labelText,
      {String prefixText = ''}) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: GoogleFonts.poppins(color: Colors.yellow[400]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixText: prefixText,
            prefixStyle: GoogleFonts.poppins(color: Colors.white)),
        style: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }

  _editPlanControllers() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Informações do plano',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            _buildTextField(
              _nomeController,
              'Nome do plano',
            ),
            const SizedBox(width: 16),
            _buildTextField(_velocidadeController, 'Velocidade',
                prefixText: 'Mbps '),
            const SizedBox(width: 16),
            _buildTextField(_valorController, 'Valor', prefixText: 'R\$ '),
          ],
        )
      ],
    );
  }

  _editBeneficiosController() {
    final List<Beneficio> beneficios = widget.response[widget.index].beneficios;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Informações dos benefícios',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(
                  'Adicionar benefício',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: beneficios.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                shadowColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 60,
                          width: 200,
                          child: Image.memory(
                            base64Decode(beneficios[index].image),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          flex: 2,
                          child: _buildTextField(
                              _beneficioNomeControllers[index], 'Nome')),
                      const SizedBox(width: 16),
                      Expanded(
                          flex: 2,
                          child: _buildTextField(
                              _beneficioValorControllers[index], 'Valor',
                              prefixText: 'R\$ ')),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          size: 28,
                        ),
                        color: Colors.red,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _editActions(dialogContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text('CANCELAR',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: isUpdating
              ? null
              : () async {
                  final originalPlan = widget.response[widget.index];

                  final updatedPlan = Plan(
                    id: originalPlan.id,
                    nome: _nomeController.text.trim().isEmpty
                        ? originalPlan.nome
                        : _nomeController.text.trim(),
                    velocidade: _velocidadeController.text.trim().isEmpty
                        ? originalPlan.velocidade
                        : int.tryParse(_velocidadeController.text.trim()) ??
                            originalPlan.velocidade,
                    valor: _valorController.text.trim().isEmpty
                        ? originalPlan.valor
                        : double.tryParse(_valorController.text.trim()) ??
                            originalPlan.valor,
                    beneficios: _getUpdatedBeneficios(originalPlan.beneficios),
                  );
                  setState(() {
                    isUpdating = true;
                  });
                  try {
                    await PlanService().updatePlan(
                      updatedPlan.id,
                      updatedPlan.toJsonForUpdate(),
                    );
                    setState(() {
                      widget.response[widget.index] = updatedPlan;
                    });
                    widget.onPlanUpdated();
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text('Plano atualizado com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(dialogContext).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao atualizar plano: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    setState(() {
                      isUpdating = false;
                    });
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
          ),
          child: isUpdating
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'SALVAR',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }

  List<Beneficio> _getUpdatedBeneficios(List<Beneficio> original) {
    final List<Beneficio> result = [];
    for (int i = 0; i < _beneficioNomeControllers.length; i++) {
      result.add(Beneficio(
        nome: _beneficioNomeControllers[i].text.trim().isEmpty
            ? original[i].nome
            : _beneficioNomeControllers[i].text.trim(),
        valor: _beneficioValorControllers[i].text.trim().isEmpty
            ? original[i].valor
            : double.tryParse(_beneficioValorControllers[i].text.trim()) ??
                original[i].valor,
        image: original[i].image, // não muda aqui
      ));
    }
    return result;
  }
}
