/*
 *  main.dart
 *  Exemplo completo de bottom‑sheet rolável com DraggableScrollableSheet
 *  ────────────────────────────────────────────────────────────────────
 *  Basta colar este arquivo num projeto Flutter (2.10+). Ele roda em
 *  Web, Android e iOS.  Não há dependências externas além de:
 *    google_fonts: ^6.0.0
 *  (adicione no pubspec.yaml se quiser usar as fontes do exemplo)
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom‑sheet Edit Plan',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
//  MODELOS SIMPLES  (mock – sem integração com API)
// ─────────────────────────────────────────────────────────────────────
class Plan {
  final int id;
  String nome;
  int velocidade;
  double valor;
  List<Beneficio> beneficios;

  Plan({
    required this.id,
    required this.nome,
    required this.velocidade,
    required this.valor,
    required this.beneficios,
  });

  Plan copyWith({
    String? nome,
    int? velocidade,
    double? valor,
    List<Beneficio>? beneficios,
  }) {
    return Plan(
      id: id,
      nome: nome ?? this.nome,
      velocidade: velocidade ?? this.velocidade,
      valor: valor ?? this.valor,
      beneficios: beneficios ?? this.beneficios,
    );
  }
}

class Beneficio {
  String nome;
  double valor;
  String image; // base64

  Beneficio({required this.nome, required this.valor, required this.image});

  Beneficio copyWith({String? nome, double? valor, String? image}) {
    return Beneficio(
      nome: nome ?? this.nome,
      valor: valor ?? this.valor,
      image: image ?? this.image,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
//  PÁGINA INICIAL COM LISTA DE PLANOS FAKE
// ─────────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Plan> planos;

  @override
  void initState() {
    super.initState();
    // dados de exemplo
    planos = List.generate(
      3,
      (i) => Plan(
        id: i,
        nome: 'Plano ${['Bronze', 'Prata', 'Ouro'][i]}',
        velocidade: (i + 1) * 200,
        valor: 79.90 + i * 20,
        beneficios: List.generate(
          2,
          (b) => Beneficio(
            nome: 'Benefício ${b + 1}',
            valor: 10 * (b + 1),
            image: _fakeBase64, // mesma imagem para todos
          ),
        ),
      ),
    );
  }

  void _abrirEdicao(int index) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditPlanSheet(
        plan: planos[index],
        onPlanUpdated: (novoPlano) {
          setState(() => planos[index] = novoPlano);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planos')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: planos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => ListTile(
          tileColor: Colors.grey[850],
          title: Text(planos[i].nome, style: GoogleFonts.poppins(fontSize: 18)),
          subtitle: Text(
            '${planos[i].velocidade} Mbps — R\$ ${planos[i].valor.toStringAsFixed(2)}',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: Colors.yellow),
            onPressed: () => _abrirEdicao(i),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
//  BOTTOM‑SHEET DE EDIÇÃO
// ─────────────────────────────────────────────────────────────────────
class EditPlanSheet extends StatefulWidget {
  final Plan plan;
  final ValueChanged<Plan> onPlanUpdated;
  const EditPlanSheet({
    super.key,
    required this.plan,
    required this.onPlanUpdated,
  });

  @override
  State<EditPlanSheet> createState() => _EditPlanSheetState();
}

class _EditPlanSheetState extends State<EditPlanSheet> {
  late final TextEditingController _nomeCtl;
  late final TextEditingController _velocCtl;
  late final TextEditingController _valorCtl;
  late final List<TextEditingController> _benNomeCtl;
  late final List<TextEditingController> _benValorCtl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.plan;
    _nomeCtl = TextEditingController(text: p.nome);
    _velocCtl = TextEditingController(text: p.velocidade.toString());
    _valorCtl = TextEditingController(text: p.valor.toString());
    _benNomeCtl = [
      for (var b in p.beneficios) TextEditingController(text: b.nome)
    ];
    _benValorCtl = [
      for (var b in p.beneficios)
        TextEditingController(text: b.valor.toString())
    ];
  }

  @override
  void dispose() {
    _nomeCtl.dispose();
    _velocCtl.dispose();
    _valorCtl.dispose();
    for (final c in _benNomeCtl) c.dispose();
    for (final c in _benValorCtl) c.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    setState(() => isSaving = true);
    await Future.delayed(const Duration(seconds: 1)); // simula chamada HTTP

    final novo = widget.plan.copyWith(
      nome: _nomeCtl.text.trim(),
      velocidade: int.tryParse(_velocCtl.text.trim()) ?? widget.plan.velocidade,
      valor: double.tryParse(_valorCtl.text.trim()) ?? widget.plan.valor,
      beneficios: List.generate(
        _benNomeCtl.length,
        (i) => widget.plan.beneficios[i].copyWith(
          nome: _benNomeCtl[i].text.trim(),
          valor: double.tryParse(_benValorCtl[i].text.trim()) ??
              widget.plan.beneficios[i].valor,
        ),
      ),
    );

    widget.onPlanUpdated(novo);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (ctx, scrollCtl) => Material(
          color: Colors.grey[900],
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: ListView(
              controller: scrollCtl,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Editar plano',
                          style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow[400])),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _secaoTitulo('Dados do plano'),
                Row(children: [
                  _campo(_nomeCtl, 'Nome'),
                  const SizedBox(width: 12),
                  _campo(_velocCtl, 'Velocidade', prefix: 'Mbps '),
                  const SizedBox(width: 12),
                  _campo(_valorCtl, 'Valor', prefix: 'R\$ '),
                ]),
                const SizedBox(height: 24),
                _secaoTitulo('Benefícios'),
                ListView.builder(
                  shrinkWrap: true,
                  controller: ScrollController(),
                  itemCount: _benNomeCtl.length,
                  itemBuilder: (_, i) => _cardBeneficio(i),
                ),
                const SizedBox(height: 32),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('CANCELAR'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: isSaving ? null : _salvar,
                    child: isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('SALVAR'),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _secaoTitulo(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t,
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
      );

  Widget _campo(TextEditingController ctl, String label,
          {String prefix = ''}) =>
      Expanded(
        child: TextFormField(
          controller: ctl,
          decoration: InputDecoration(
            labelText: label,
            prefixText: prefix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      );

  Widget _cardBeneficio(int i) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        color: Colors.grey[850],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            // imagem exemplo em base64 (quadrado colorido)
            SizedBox(
              width: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    Image.memory(base64Decode(_fakeBase64), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            _campo(_benNomeCtl[i], 'Nome'),
            const SizedBox(width: 12),
            _campo(_benValorCtl[i], 'Valor', prefix: 'R\$ '),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────
//  IMAGEM BASE64 “FAKE” (quadrado colorido) só para preencher o exemplo
// ─────────────────────────────────────────────────────────────────────
const _fakeBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAABSElEQVR4Xu3XsQkCMQwEUYH//2b'
    'AUlJsAgbEoPcmrrOtE6TSObx81/windowsk0l9pEbJKQyxwHzpB6xgLrtgDhBoAQ4gaIEOIGiBDi'
    'BoiDeKis7Lm9/DtN4Fu/D0uPYKeBu8Wf/g3YdfAzcC/4f0wlo06QIEOIGiBDiBoiDeEDPQuxdDE'
    'Loj3hCt5KJZ11RKfpGDbWZXy5u/d7T6X0HrXumtu/atk9tRbRZBXBxt8EzVOsTB3tfUCIEMEHQI'
    'GkCBBCghBGBvQvnDADjhjSkhCFBDhCQQ4QQIEOEMECHFdhVQghBBhBAghBBAghBAghBBAghBAgh'
    'BBAghBCkZLAK3COn+qK+xN5RJ5V3PFdz6gqhXyyxj8Jt+uPCJCGEEEEMIQRggpAQgghBAghBBAg'
    'hBAghBBAghBBAghBBAghBBAghBAt/AGv1LH8mpuNvAAAAAElFTkSuQmCC';
