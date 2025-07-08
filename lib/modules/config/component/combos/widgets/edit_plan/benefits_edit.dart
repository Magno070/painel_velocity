import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

import 'package:painel_velocitynet/modules/config/component/combos/service/models/plan_model.dart';

class BenefitsEdit extends StatefulWidget {
  final List<Beneficio> initialBenefits;

  const BenefitsEdit({
    super.key,
    required this.initialBenefits,
  });

  @override
  State<BenefitsEdit> createState() => BenefitsEditState();
}

class BenefitsEditState extends State<BenefitsEdit> {
  //placeholder
  static const String _placeholderImageBase64 =
      'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7';

  late List<Beneficio> _localBenefits;
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _valueControllers = [];
  int? _pickingImageIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _localBenefits = List<Beneficio>.from(widget.initialBenefits);
    for (var benefit in _localBenefits) {
      _nameControllers.add(TextEditingController(text: benefit.nome));
      _valueControllers
          .add(TextEditingController(text: benefit.valor.toString()));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    for (final controller in _valueControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Beneficio> getUpdatedBeneficios() {
    final List<Beneficio> result = [];
    for (int i = 0; i < _localBenefits.length; i++) {
      final nome = _nameControllers[i].text.trim();

      if (nome.isEmpty) {
        continue;
      }

      final image = _localBenefits[i].image == _placeholderImageBase64
          ? ''
          : _localBenefits[i].image;

      // Limpa e normaliza o valor para aceitar "15,90" ou "R$ 15.90"
      final valueString = _valueControllers[i]
          .text
          .replaceAll(RegExp(r'[^0-9,]'), '') // Mantém apenas números e vírgula
          .replaceAll(',', '.'); // Troca vírgula por ponto para o parse

      result.add(
        Beneficio(
          nome: nome,
          valor: double.tryParse(valueString) ?? 0.0,
          image: image,
        ),
      );
    }
    return result;
  }

  void _addBenefit() {
    setState(() {
      _localBenefits
          .add(Beneficio(nome: '', valor: 0, image: _placeholderImageBase64));
      _nameControllers.add(TextEditingController());
      _valueControllers.add(TextEditingController());
    });

    // Rola para o final da lista após a UI ser reconstruída
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeBenefit(int index) {
    setState(() {
      _nameControllers[index].dispose();
      _valueControllers[index].dispose();
      _localBenefits.removeAt(index);
      _nameControllers.removeAt(index);
      _valueControllers.removeAt(index);
    });
  }

  Future<void> _pickImage(int index) async {
    if (_pickingImageIndex != null) return;

    setState(() {
      _pickingImageIndex = index;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final Uint8List originalBytes = result.files.single.bytes!;

        img.Image? originalImage = img.decodeImage(originalBytes);

        if (originalImage == null) {
          debugPrint('Erro: Não foi possível decodificar a imagem.');
          return;
        }

        img.Image resizedImage = img.copyResize(
          originalImage,
          width: 180,
          height: 40,
        );

        final compressedBytes = img.encodeJpg(resizedImage, quality: 85);
        final String base64Image = base64Encode(compressedBytes);

        setState(() {
          _localBenefits[index] =
              _localBenefits[index].copyWith(image: base64Image);
        });
      }
    } catch (e) {
      debugPrint('Erro ao selecionar ou processar a imagem: $e');
    } finally {
      if (mounted) setState(() => _pickingImageIndex = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Informações dos benefícios",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: _addBenefit,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: Text(
                    'Adicionar benefício',
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            itemCount: _localBenefits.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return SizedBox(
                height: 80,
                child: Card(
                  color: Colors.grey[850],
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _pickImage(index),
                            borderRadius: BorderRadius.circular(8),
                            child: _buildImageBenefit(
                                _localBenefits[index], index),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _buildTextField(
                                _nameControllers[index], 'Nome')),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: _buildTextField(
                                _valueControllers[index], 'Valor',
                                prefixText: 'R\$ ',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true))),
                        const SizedBox(
                          width: 16,
                        ),
                        IconButton(
                            onPressed: () => _removeBenefit(index),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ))
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildImageBenefit(Beneficio benefit, int index) {
    final bool isPlaceholder =
        benefit.image.isEmpty || benefit.image == _placeholderImageBase64;
    final bool isLoading = _pickingImageIndex == index;

    return SizedBox(
      width: 80,
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : isPlaceholder
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: Colors.white70),
                      SizedBox(height: 4),
                      Text('Adicionar',
                          style:
                              TextStyle(fontSize: 10, color: Colors.white70)),
                    ],
                  )
                : _buildDecodedImage(benefit.image),
      ),
    );
  }

  Widget _buildDecodedImage(String base64String) {
    try {
      final decodedBytes = base64Decode(base64String);
      return Image.memory(
        decodedBytes,
        fit: BoxFit.cover,
        gaplessPlayback: true, // Evita piscar ao trocar a imagem
      );
    } catch (e) {
      // Se a string base64 for inválida, mostra um ícone de erro.
      return const Tooltip(
        message: 'Erro ao carregar imagem',
        child: Icon(
          Icons.broken_image,
          color: Colors.redAccent,
        ),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {String prefixText = '', TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: Colors.yellow[400],
          ),
          prefixText: prefixText,
          prefixStyle: GoogleFonts.poppins(color: Colors.white)),
      style: GoogleFonts.poppins(color: Colors.white),
    );
  }
}
