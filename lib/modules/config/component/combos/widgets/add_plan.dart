import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/models/plan_model.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/plan_service.dart';

class AddPlan extends StatefulWidget {
  final List<dynamic> response;
  final VoidCallback onPlanAdded;
  final PlanService planService;
  const AddPlan(
      {super.key,
      required this.response,
      required this.onPlanAdded,
      required this.planService});

  @override
  State<AddPlan> createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
  bool isUploading = false;
  String? errorMessage;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _velocidadeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final List<Map<String, dynamic>> _tempBeneficios = [];

  Future<void> _uploadPlan(BuildContext dialogContext) async {
    if (_nomeController.text.isEmpty ||
        _velocidadeController.text.isEmpty ||
        _valorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Preencha todos os campos obrigatórios'),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    setState(() {
      isUploading = true;
    });
    final navigatorPop = Navigator.of(dialogContext).pop();

    try {
      final newPlan = {
        'nome': _nomeController.text,
        'velocidade': int.tryParse(_velocidadeController.text) ?? 0,
        'valor': double.tryParse(_valorController.text) ?? 0.0,
        'beneficios': _tempBeneficios
            .map((b) =>
                {'nome': b['nome'], 'valor': b['valor'], 'image': b['image']})
            .toList(),
      };

      if (kDebugMode) {
        print(newPlan);
      }

      await widget.planService.createPlan(newPlan);
      widget.response.add(Plan.fromJson(newPlan));
      widget.onPlanAdded();

      if (mounted) {
        navigatorPop;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Plano ${_nomeController.text} criado com sucesso!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar plano: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _velocidadeController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: 3,
        shadowColor: Colors.green[900],
      ),
      onPressed: () => _showAddPlanDialog(context),
      icon: const Icon(Icons.add, size: 18),
      label: Text('Adicionar plano', style: GoogleFonts.poppins(fontSize: 14)),
    );
  }

  void _showAddPlanDialog(BuildContext context) {
    _nomeController.clear();
    _velocidadeController.clear();
    _valorController.clear();
    _tempBeneficios.clear();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              backgroundColor: Colors.grey[900],
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Adicionar novo plano',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[100],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.green[900]),
                    const SizedBox(height: 16),

                    // Formulário do plano
                    _buildPlanoFormSection(),
                    const SizedBox(height: 24),

                    // Seção de benefícios
                    _buildBeneficiosSection(setStateDialog),
                    const SizedBox(height: 24),

                    // Botões de ação
                    _buildActionButtons(dialogContext),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlanoFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações do plano',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.green[200],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do plano',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[900]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[800]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _velocidadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Velocidade',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[900]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[800]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixText: 'Mbps',
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[900]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[800]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixText: 'R\$ ',
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBeneficiosSection(StateSetter setStateDialog) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Benefícios inclusos',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green[200],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddBeneficioDialog(context, setStateDialog),
              icon: const Icon(Icons.add, size: 18),
              label: Text('Adicionar benefício',
                  style: GoogleFonts.poppins(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[800],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 6,
                shadowColor: Colors.green[900],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_tempBeneficios.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('Nenhum benefício adicionado',
                  style: GoogleFonts.poppins(color: Colors.grey[400])),
            ),
          ),
        if (_tempBeneficios.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _tempBeneficios.map((beneficio) {
              return Chip(
                backgroundColor: Colors.green[900],
                label: Text(beneficio["nome"],
                    style: GoogleFonts.poppins(color: Colors.white)),
                avatar: CircleAvatar(
                  backgroundColor: Colors.green[800],
                  child: beneficio["image"] != null
                      ? ClipOval(
                          child: Image.memory(
                            base64Decode(beneficio["image"]),
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.image, size: 16, color: Colors.white),
                ),
                deleteIcon:
                    const Icon(Icons.close, size: 16, color: Colors.white),
                onDeleted: () {
                  setStateDialog(() {
                    _tempBeneficios.remove(beneficio);
                  });
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext dialogContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () =>
              isUploading ? null : Navigator.of(dialogContext).pop(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text('CANCELAR',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: isUploading
              ? null
              : () {
                  _uploadPlan(dialogContext);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 6,
            shadowColor: Colors.green[900],
          ),
          child: isUploading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text('ADICIONAR PLANO',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _showAddBeneficioDialog(
      BuildContext context, StateSetter setStateDialog) {
    final nomeController = TextEditingController();
    final valorController = TextEditingController();
    Uint8List? imageBytes;
    String? fileName;

    showDialog(
      context: context,
      builder: (beneficioContext) {
        return StatefulBuilder(
          builder: (context, setStateLocal) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.grey[900],
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adicionar benefício',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[100],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Formulário do benefício
                      TextFormField(
                        controller: nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome do benefício',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey[850],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green[900]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green[800]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: valorController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Valor',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey[850],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green[900]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green[800]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixText: 'R\$ ',
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 24),

                      // Upload de image
                      Text(
                        'imagem do benefício (opcional)',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          try {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.image,
                              allowMultiple: false,
                            );

                            if (result != null && result.files.isNotEmpty) {
                              final file = result.files.first;
                              setStateLocal(() {
                                imageBytes = file.bytes;
                                fileName = file.name;
                              });
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao carregar imagem: $e'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green[900]!,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: imageBytes != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      imageBytes!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.image,
                                          size: 40, color: Colors.white54),
                                      const SizedBox(height: 8),
                                      Text('Clique para adicionar uma imagem',
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey[400])),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      if (fileName != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(fileName!,
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: Colors.grey[400])),
                        ),
                      const SizedBox(height: 32),

                      // Botões
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.of(beneficioContext).pop(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[300],
                            ),
                            child: Text('CANCELAR',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (nomeController.text.isEmpty ||
                                  valorController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Preencha nome e valor do benefício'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              _tempBeneficios.add({
                                "nome": nomeController.text,
                                "valor":
                                    double.tryParse(valorController.text) ??
                                        0.0,
                                "image": imageBytes != null
                                    ? base64Encode(imageBytes!)
                                    : null,
                              });

                              setStateDialog(() {});
                              Navigator.of(beneficioContext).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[800],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              elevation: 6,
                              shadowColor: Colors.green[900],
                            ),
                            child: Text('ADICIONAR',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
