import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/models/plan_model.dart';

class EditDetails extends StatefulWidget {
  final List<Beneficio> beneficios;
  const EditDetails({super.key, required this.beneficios});

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  @override
  Widget build(BuildContext context) {
    if (widget.beneficios.isEmpty) {
      return Center(
        child: Text('Este plano não possui benefícios cadastrados.',
            style: GoogleFonts.poppins(color: Colors.white70)),
      );
    }
    return _buildBody(context, widget.beneficios);
  }

  Widget _buildBody(BuildContext context, List<Beneficio> beneficios) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Informações dos detalhes',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text('Adicionar detalhe',
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
        _buildCustomHeader(),
        const Divider(color: Colors.white54, height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: beneficios.length,
            itemBuilder: (context, index) {
              final beneficio = beneficios[index];
              return _buildCustomRow(beneficio, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      color: Colors.grey[850],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Número',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'Benefício',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomRow(Beneficio beneficio, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text('${index + 1}',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
          Expanded(
            flex: 4,
            child: Text(beneficio.nome,
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
