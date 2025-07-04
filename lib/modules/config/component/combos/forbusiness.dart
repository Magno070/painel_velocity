// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:painel_velocitynet/modules/config/component/widgets/combos/add_plan.dart';

// class ForBusiness extends StatefulWidget {
//   const ForBusiness({super.key});

//   @override
//   State<ForBusiness> createState() => _ForBusinessState();
// }

// class _ForBusinessState extends State<ForBusiness> {
//   bool isUploading = false;
//   bool isUploadingImage = false;
//   String? errorMessage;

//   final TextEditingController _nomeController = TextEditingController();
//   final TextEditingController _velocidadeController = TextEditingController();
//   final TextEditingController _valorController = TextEditingController();

//   Map<String, dynamic> response = {
//     "planos": [
//       {
//         "nome": "Plano 500 Mbps",
//         "velocidade": 500,
//         "valor_total": 89.90,
//         "beneficios": [
//           {
//             "nome": "Globoplay",
//             "valor": 10.00,
//             "imagem": "base64_encoded_image1"
//           },
//           {"nome": "Max", "valor": 15.00, "imagem": "base64_encoded_image2"},
//           {
//             "nome": "Disney+",
//             "valor": 12.00,
//             "imagem": "base64_encoded_image3"
//           },
//         ]
//       },
//       {
//         "nome": "Plano 300 Mbps",
//         "velocidade": 300,
//         "valor_total": 69.90,
//         "beneficios": [
//           {
//             "nome": "Globoplay",
//             "valor": 10.00,
//             "imagem": "base64_encoded_image1"
//           },
//         ]
//       },
//       {
//         "nome": "Plano 300 Mbps",
//         "velocidade": 300,
//         "valor_total": 69.90,
//         "beneficios": []
//       },
//     ]
//   };

//   @override
//   void dispose() {
//     _nomeController.dispose();
//     _velocidadeController.dispose();
//     _valorController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<dynamic> planos = response["planos"]!;

//     return Scaffold(
//       backgroundColor: Colors.grey[850],
//       floatingActionButton: const AddPlan(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Para empresas',
//               style: GoogleFonts.poppins(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: planos.length,
//                 itemBuilder: (context, index) {
//                   final plan = planos[index];
//                   final beneficios = plan["beneficios"] as List<dynamic>? ?? [];

//                   return Card(
//                     elevation: 4,
//                     margin: const EdgeInsets.only(bottom: 20),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Cabeçalho do plano
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     plan["nome"].toString(),
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blue[900],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     '${plan["velocidade"]} Mbps',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 16,
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.blue[50],
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   'R\$${plan["valor_total"].toStringAsFixed(2)}',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.blue[900],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                           // Divisor
//                           Divider(color: Colors.grey[300], thickness: 1),
//                           const SizedBox(height: 8),
//                           // Título benefícios
//                           beneficios.isNotEmpty
//                               ? Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Benefícios Inclusos:',
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.blue[800],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     // Grid de benefícios
//                                     Wrap(
//                                       spacing: 12,
//                                       runSpacing: 12,
//                                       children: beneficios.map<Widget>((b) {
//                                         return Container(
//                                           width: 180,
//                                           padding: const EdgeInsets.all(12),
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.grey
//                                                     .withOpacity(0.2),
//                                                 spreadRadius: 1,
//                                                 blurRadius: 5,
//                                                 offset: const Offset(0, 2),
//                                               ),
//                                             ],
//                                           ),
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 width: 50,
//                                                 height: 50,
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.grey[200],
//                                                   borderRadius:
//                                                       BorderRadius.circular(8),
//                                                 ),
//                                                 child: const Icon(Icons.image,
//                                                     color: Colors.grey),
//                                               ),
//                                               const SizedBox(width: 12),
//                                               Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     b["nome"].toString(),
//                                                     style: GoogleFonts.poppins(
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(height: 4),
//                                                   Text(
//                                                     'R\$${b["valor"].toStringAsFixed(2)}',
//                                                     style: GoogleFonts.poppins(
//                                                       color: Colors.green[700],
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }).toList(),
//                                     ),
//                                   ],
//                                 )
//                               : Text(
//                                   'Nenhum benefício selecionado',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.blue[800],
//                                   ),
//                                 ),

//                           // Botões de ação
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               TextButton(
//                                 onPressed: () {},
//                                 style: TextButton.styleFrom(
//                                   foregroundColor: Colors.blue[800],
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 10),
//                                 ),
//                                 child: Text(
//                                   'EDITAR',
//                                   style: GoogleFonts.poppins(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               ElevatedButton(
//                                 onPressed: () {},
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.red[50],
//                                   foregroundColor: Colors.red[700],
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20, vertical: 10),
//                                 ),
//                                 child: Text(
//                                   'REMOVER',
//                                   style: GoogleFonts.poppins(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ForBusiness extends StatelessWidget {
  const ForBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
