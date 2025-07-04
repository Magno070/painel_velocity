import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/helpers/token.dart';
import 'package:painel_velocitynet/modules/config/component/additional.dart';
import 'package:painel_velocitynet/modules/config/component/complement.dart';
import 'package:painel_velocitynet/modules/config/component/plans_model.dart';
import 'package:painel_velocitynet/pages/planos_abas/alertdialog_editplan.dart';
import 'package:painel_velocitynet/pages/planos_abas/create_plans.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Planos extends StatefulWidget {
  const Planos({super.key});

  @override
  State<Planos> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Planos> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  Future<String> getTokenFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token ?? '';
  }

  List<dynamic> dataPlans = [];
  Future<void> getPlans() async {
    final token = await getTokenFromLocalStorage();
    final response = await http.get(
      Uri.parse('${ApiContants.baseApi}/plans'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        dataPlans = responseData;
      });
    } else {
      // print('Erro ao buscar dados: ${response.statusCode}');
    }
  }

  deletePlan(String id, token) async {
    var url = Uri.parse('${ApiContants.baseApi}/plans/delete');
    try {
      final token = await getTokenFromLocalStorage();

      var response = await http.delete(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"id": id}));
      if (response.statusCode == 200) {
        setState(() {
          getPlans();
        });
        // print("Complemento deletado com sucesso.");
      } else {
        // print('Falha ao deletar recurso: ${response.statusCode}');
      }
    } catch (e) {
      // print('Erro ao conectar ao servidor: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: NavigationRail(
              indicatorColor: Colors.transparent,
              backgroundColor: const Color(
                0xff181919,
              ),
              extended: true,
              selectedIndex: _currentIndex,
              groupAlignment: BorderSide.strokeAlignInside,
              labelType: NavigationRailLabelType.none,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                });
              },
              destinations: [
                NavigationRailDestination(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  icon: Image.asset(
                    'images/plano.png',
                    color: Colors.white,
                    width: 20,
                  ),

                  // PhosphorIcon(
                  //   PhosphorIcons.regular.slideshow,
                  //   size: 25,
                  //   color: const Color(0xff969696),
                  // ),

                  label: Text(
                    'Planos',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                NavigationRailDestination(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    icon: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                    // icon: PhosphorIcon(
                    //   PhosphorIcons.regular.globe,
                    //   size: 25,
                    //   color: const Color(0xff969696),
                    // ),
                    label: Text(
                      'Adicionais',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )),
                NavigationRailDestination(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  icon: const Icon(
                    Icons.add_box,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Complementos',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                NavigationRailDestination(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  icon: const Icon(
                    size: 20,
                    Icons.router,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Roteadores',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                planos(),
                const Additional(),
                const Complement(),
                const Text(
                  'Roteadores',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          // PreviewCard(),
        ],
      ),
    );
  }

  Widget planos() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Planos',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      backgroundColor: Colors.green),
                  onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => const CreatePlans()),
                  child: const Text(
                    '+ Criar Plano',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: dataPlans.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(
                        (0xff212121),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(100)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  '${ApiContants.baseApi}/uploads/${dataPlans[index]['imagem']}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              dataPlans[index]['nome'],
                              style: GoogleFonts.getFont(
                                'Poppins',
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  side: const BorderSide(color: Colors.green),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialogEditPlan(
                                        plans: PlansModel(
                                            idSimulador: dataPlans[index]
                                                ['_id'],
                                            nome: dataPlans[index]['nome'],
                                            descricao: dataPlans[index]
                                                ['descricao'],
                                            idCategoria: dataPlans[index]
                                                ['idCategoria'],
                                            complementar: List<String>.from(
                                                dataPlans[index]['complementar']
                                                    .map((comp) => comp[
                                                        'id'])), // Ajuste aqui
                                            preco: dataPlans[index]['preco']
                                                ['\$numberDecimal'],
                                            imagem: dataPlans[index]['imagem'],
                                            planoBase: dataPlans[index]
                                                ['planoBase'])),
                              ),
                              child: const Text(
                                'Editar',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: const Color(0xff3D3D3D),
                                  title: const Text(
                                    'Deletar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    'Deseja mesmo deletar este item?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        deletePlan(
                                            dataPlans[index]['_id'],
                                            GetToken()
                                                .getTokenFromLocalStorage);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                'Plano excluido com sucesso!'),
                                          ),
                                        );
                                        Navigator.pop(context, 'Excluir');
                                      },
                                      child: const Text(
                                        'Excluir',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.red,
                                  ),
                                ),
                                child: const Icon(
                                  size: 20,
                                  Icons.delete_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
