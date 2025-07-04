import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/helpers/token.dart';
import 'package:painel_velocitynet/modules/plans/controller/plans_controller.dart';
import 'package:painel_velocitynet/modules/plans/model/plans_model.dart';
import 'package:painel_velocitynet/service/slider/image_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Plans extends StatefulWidget {
  const Plans({super.key});

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  List<PlansModel> dados = [];

  getPlans() async {
    var plans = await PlansController().getPlans();
    var jsonData = json.decode(plans);

    List<PlansModel> newJson = [];

    for (var item in jsonData) {
      newJson.add(PlansModel.fromJson(item));
    }

    setState(() {
      dados = newJson;
    });
  }

  @override
  void initState() {
    super.initState();
    getPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.start,
        direction: Axis.vertical,
        children: [
          Flexible(
            child: Container(
              width: 1416,
              padding: const EdgeInsets.only(
                top: 27,
                bottom: 50,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(
                  0xff181919,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Connect',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize:
                          MediaQuery.of(context).size.width < 800 ? 22 : 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Flexible(
                    child: SizedBox(
                      width: 1200,
                      // color: Colors.red,
                      child: ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: [
                          // Text(
                          //   'Título',
                          //   style: GoogleFonts.getFont('Poppins',
                          //       color: Colors.white,
                          //       fontSize: 22,
                          //       fontWeight: FontWeight.w600),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //         height: 50,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(10),
                          //           color: const Color(0xff3D3D3D),
                          //         ),
                          //         width: double.infinity,
                          //         child: TextField(
                          //           style: const TextStyle(color: Colors.white),
                          //           // obscureText: true,
                          //           decoration: InputDecoration(
                          //             // fillColor: Colors.red,
                          //             hintText: '',
                          //             hintStyle: GoogleFonts.getFont('Poppins',
                          //                 color: const Color(0xff969696),
                          //                 fontSize: 15,
                          //                 fontWeight: FontWeight.w600),
                          //             border: const OutlineInputBorder(
                          //                 borderSide: BorderSide.none),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 20,
                          //     ),
                          //     Container(
                          //       height: MediaQuery.of(context).size.width < 600
                          //           ? 51
                          //           : 50,
                          //       decoration: const BoxDecoration(
                          //         borderRadius: BorderRadius.all(Radius.zero),
                          //       ),
                          //       child: ElevatedButton(
                          //         style: ButtonStyle(
                          //           padding: const MaterialStatePropertyAll(
                          //             EdgeInsets.only(left: 20, right: 20),
                          //           ),
                          //           shape: MaterialStateProperty.all(
                          //             RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(10),
                          //             ),
                          //           ),
                          //           backgroundColor: MaterialStateProperty.all(
                          //               const Color(0xff46964A)),
                          //         ),
                          //         onPressed: () {},
                          //         child: Text(
                          //           'Salvar',
                          //           style: GoogleFonts.getFont('Poppins',
                          //               color: Colors.white,
                          //               fontSize: 18,
                          //               fontWeight: FontWeight.w500),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 45,
                          // ),
                          Row(
                            children: [
                              Container(
                                width: 200,
                                height: MediaQuery.of(context).size.width < 600
                                    ? 400
                                    : 400,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                ),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    padding: const WidgetStatePropertyAll(
                                        EdgeInsets.only(left: 20, right: 20)),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Colors.white),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    backgroundColor: WidgetStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  onPressed: () async {
                                    var token = await GetToken()
                                        .getTokenFromLocalStorage();
                                    ImageService().uploadImage(
                                        "plans", token, 'POST', '');
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add,
                                        size: 45,
                                      ),
                                      Text(
                                        maxLines: 2,
                                        'Adicionar\n Imagem',
                                        style: GoogleFonts.getFont('Poppins',
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // color: Colors.red,
                                  padding: const EdgeInsets.only(left: 50),
                                  width: 900,
                                  height: 400,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: dados.length,
                                      itemBuilder: (context, index) {
                                        var plano = dados[index];
                                        return Column(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                // color: Colors.amber,
                                                height: 290,
                                                width: 320,
                                                child: Image.network(
                                                  '${ApiContants.baseApi}/uploads/${plano.name}',
                                                  errorBuilder: (context,
                                                      exception, stackTrace) {
                                                    if (kDebugMode) {
                                                      print(
                                                          'Erro ao carregar imagem: $exception');
                                                    }
                                                    return const Text(
                                                        'Erro ao carregar imagem');
                                                  },
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 35,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.zero),
                                                // color: Colors.green
                                              ),
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      WidgetStateProperty.all(
                                                          const Color(
                                                              0xFF4D73F1)),
                                                ),
                                                onPressed: () {},
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const PhosphorIcon(
                                                      PhosphorIconsRegular
                                                          .pencil,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      'Selecionar imagem',
                                                      style:
                                                          GoogleFonts.getFont(
                                                              'Poppins',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 35,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.zero),
                                                // color: Colors.green
                                              ),
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      WidgetStateProperty.all(
                                                    const Color(0xffF14D4D),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  // final itemId = dados[0].id;
                                                  PlansController().deletePlans(
                                                      plano.id,
                                                      await GetToken()
                                                          .getTokenFromLocalStorage());
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const PhosphorIcon(
                                                      PhosphorIconsRegular
                                                          .trash,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      'Deletar imagem',
                                                      style:
                                                          GoogleFonts.getFont(
                                                              'Poppins',
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                    const SizedBox(
                                                      width: 35,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
