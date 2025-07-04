// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/modules/entity/menu_entity.dart';
import 'package:painel_velocitynet/service/slider/image_service.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class IdleSlide extends StatefulWidget {
  static const route = 'Slide';

  const IdleSlide({super.key});

  @override
  State<IdleSlide> createState() => _SlideState();
}

class _SlideState extends State<IdleSlide> {
  bool dataLimite(String dataLimite) {
    final dataAtual = DateTime.now();
    final limitDate = DateFormat('dd/MM/yyyy').parse(dataLimite);
    return dataAtual.isAfter(limitDate);
  }

  DateTime _dateTime = DateTime.now();

  Future<void> atualizarDataSlider(
      String itemId, String novaData, String token) async {
    Uri url = Uri.parse('${ApiContants.baseApi}/slider');
    novaData = DateFormat('dd/MM/yyyy').format(_dateTime);

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode({"id": itemId, "date": novaData}),
      );
      if (response.statusCode == 200) {
        print('DataSlider do item $itemId atualizado com sucesso!');
      } else {
        print(
            'Erro ao atualizar DataSlider do item $itemId, status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao atualizar DataSlider do item $itemId: $error');
    }
  }

  //FUNÇÃO PARA ABRIR O CALENDARIO
  _showDatePicker(int index) {
    showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((value) async {
      if (value != null) {
        setState(() {
          _dateTime = value;
        });

        final token = await getTokenFromLocalStorage();
        final itemId = dados[index]['_id'];
        final novaData = _dateTime.toString();
        atualizarDataSlider(itemId, novaData, token);
      }
    });
  }

  //PEGAR O TOKEN DO LOCAL STORAGE
  List<dynamic> dados = [];
  Future<String> getTokenFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token ?? '';
  }

  //GET PARA RECEBER OS DADOS DA API SLIDER-ALL
  Future getSlide() async {
    Uri url = Uri.parse("${ApiContants.baseApi}/slider-all");
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        dados = jsonDecode(response.body);
      });
    }
  }

  void deleteItem(String itemId, String token) async {
    final url = Uri.parse("${ApiContants.baseApi}/slider");

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"id": itemId}),
      );

      if (response.statusCode == 200) {
        getSlide();
      } else {
        if (kDebugMode) {
          print('Erro ao excluir o item: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Erro na solicitação DELETE: $error');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getSlide();
    // formatDate(formatarData);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Container(
              width: double.infinity,
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
                    'Gerenciamento de slides',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize:
                          MediaQuery.of(context).size.width < 800 ? 18 : 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Flexible(
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.zero),
                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: const WidgetStatePropertyAll(
                                    EdgeInsets.all(20),
                                  ),
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  backgroundColor: WidgetStateProperty.all(
                                      const Color(0xff181919)),
                                ),
                                onPressed: () async {
                                  final token =
                                      await getTokenFromLocalStorage();
                                  ImageService()
                                      .uploadImage("slider", token, 'POST', '');
                                  getSlide();
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      size: 45,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      maxLines: 2,
                                      'Adicionar imagem',
                                      style: GoogleFonts.getFont('Poppins',
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 800,
                          // color: Colors.cyan,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: dados.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width < 1400
                                      ? 3
                                      : 4,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                            ),
                            itemBuilder: (context, index) {
                              final imageUrl = dados[index]['name'];
                              return Column(
                                key: Key(imageUrl),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: Colors.green,
                                      width: 300,
                                      child: Image.network(
                                        '${ApiContants.baseApi}/uploads/$imageUrl',
                                        errorBuilder:
                                            (context, exception, stackTrace) {
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 35,
                                    width: 280,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                      // color: Colors.green
                                    ),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                          dataLimite(dados[index]['dateSlider'])
                                              ? const Color(0xffF14D4D)
                                              : const Color(0xff008d69),
                                        ),
                                      ),
                                      onPressed: () async {
                                        final token =
                                            await getTokenFromLocalStorage();
                                        final itemId = dados[index]['_id'];
                                        final selectedDate =
                                            _showDatePicker(index);
                                        if (selectedDate != null) {
                                          final novaData =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(selectedDate);

                                          atualizarDataSlider(
                                              itemId, novaData, token);
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const PhosphorIcon(
                                            PhosphorIconsRegular.alarm,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              dados[index]['dateSlider'],
                                              style: GoogleFonts.getFont(
                                                  'Poppins',
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width <
                                                              1200
                                                          ? 13
                                                          : 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
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
                                    width: 280,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                      // color: Colors.green
                                    ),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                                const Color(0xffF14D4D)),
                                      ),
                                      onPressed: () async {
                                        final token =
                                            await getTokenFromLocalStorage();
                                        final itemId = dados[index]['_id'];
                                        deleteItem(itemId, token);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          PhosphorIcon(
                                            PhosphorIconsRegular.trash,
                                            color: Colors.white,
                                            size: MediaQuery.of(context)
                                                        .size
                                                        .width <
                                                    1300
                                                ? 20
                                                : 25,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1300
                                                  ? 'rrrr'
                                                  : 'Deletar imagem',
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                                  .size
                                                                  .width <
                                                              1400
                                                          ? 14
                                                          : 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SliderPage extends StatelessWidget {
  const SliderPage({
    Key? key,
    required this.menu,
  }) : super(key: key);
  static const route = '/slide';
  final MenuEntity menu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFF000000 | (math.Random().nextDouble() * 0xFFFFFF).toInt()),
      body: Center(child: Text(menu.name)),
    );
  }
}
