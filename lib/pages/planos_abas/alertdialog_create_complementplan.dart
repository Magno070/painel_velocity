// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/helpers/token.dart';
import 'package:painel_velocitynet/modules/config/component/plans_model.dart';
import 'package:painel_velocitynet/modules/create_complementos/complementos_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertDialogCreateComplementPlan extends StatefulWidget {
  final PlansModel plans;
  const AlertDialogCreateComplementPlan({super.key, required this.plans});

  @override
  State<AlertDialogCreateComplementPlan> createState() =>
      _AlertDialogCreateComplementPlanState();
}

class _AlertDialogCreateComplementPlanState
    extends State<AlertDialogCreateComplementPlan> {
  final _formKey = GlobalKey<FormState>();
  String? selectedImage;
  List<CreateComplementoModel> dataComplementoModel = [];
  late TextEditingController nomeComplemento = TextEditingController(text: '');

  FilePickerResult? result;
  late Uint8List resultBytes;

  uploadImage() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        resultBytes = result!.files.first.bytes!;
      });
    }
  }

  createComplemento(String nome, String idPlano, String token) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${ApiContants.baseApi}/complement/create'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          resultBytes,
          filename: result!.files.first.name,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      request.fields.addAll({'nome': nome, 'idPlan': idPlano});

      await request.send();
      setState(() {
        getComplemento();
      });
    } catch (error) {
      // print("Erro na requisição: $error");
      return null;
    }
  }

  Future<String> getTokenFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token ?? '';
  }

  List<dynamic> dataComplemento = [];
  Future<void> getComplemento() async {
    final token = await getTokenFromLocalStorage();
    final response = await http.get(
      Uri.parse('${ApiContants.baseApi}/complement'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        dataComplemento = json.decode(response.body);
      });
    } else {
      // print('Erro ao buscar dados: ${response.statusCode}');
    }
  }

  deletarComplemento(String id, token) async {
    var url = Uri.parse('${ApiContants.baseApi}/complement/delete');
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
        getComplemento();
        // print("Complemento deletado com sucesso.");
      } else {
        // print('Falha ao deletar recurso: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao conectar ao servidor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        backgroundColor: const Color(0xff3D3D3D),
        title: const Text(
          'Criar complemento',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          SizedBox(
            width: 400,
            height: 130,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          uploadImage();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.white),
                          ),
                          child: result == null
                              ? const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: Colors.white,
                                    )
                                  ],
                                )
                              : SizedBox(
                                  width: 130,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      resultBytes,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff5F5F5F),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 50,
                          width: 400,
                          child: TextFormField(
                            controller: nomeComplemento,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Ex: Instalação grátis',
                              hintStyle: TextStyle(
                                  fontSize: 14, color: Color(0xffCFCFCF)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     padding: const EdgeInsets.all(23),
                      //     backgroundColor: Colors.green,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(5),
                      //     ),
                      //   ),
                      //   onPressed: () async {},
                      //   child: const Text(
                      //     'Criar',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        final navigatorPop = Navigator.pop(context, 'OK');

                        if (nomeComplemento.text.isNotEmpty && result != null) {
                          createComplemento(
                            nomeComplemento.text,
                            widget.plans.idSimulador,
                            await GetToken().getTokenFromLocalStorage(),
                          );

                          nomeComplemento.clear();
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content:
                                  Text('Complemento cadastrado com sucesso!'),
                            ),
                          );
                          setState(() {
                            result = null;
                          });
                          navigatorPop;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content:
                                  Text('Nome e imagem não podem estar vazios'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Criar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
