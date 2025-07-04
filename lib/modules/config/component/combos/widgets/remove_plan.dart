import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/combos/service/models/plan_model.dart';

class RemovePlan extends StatelessWidget {
  final List<Plan> plans;
  final int index;

  const RemovePlan({super.key, required this.plans, required this.index});

  void _showRemoveConfirmationDialog(BuildContext context, int index) {
    final plan = plans[index];
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Confirmar Remoção',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, color: Colors.red[800])),
          content: Text(
              'Tem certeza que deseja remover o plano "${plan.nome}"?',
              style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('CANCELAR',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                plans.removeAt(index);
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                foregroundColor: Colors.white,
              ),
              child: Text('REMOVER',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.redAccent),
      onPressed: () => _showRemoveConfirmationDialog(context, index),
    );
  }
}
