// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/modules/create_complementos/complementos_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComplementEditAlertDialog extends StatefulWidget {
  final CreateComplementoModel complement;
  const ComplementEditAlertDialog({super.key, required this.complement});

  @override
  State<ComplementEditAlertDialog> createState() =>
      _ComplementAlertDialogState();
}

class _ComplementAlertDialogState extends State<ComplementEditAlertDialog> {
  List<CreateComplementoModel> dataComplementoModel = [];
  FilePickerResult? result;
  Uint8List? resultBytes;
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
      print('Erro ao buscar dados: ${response.statusCode}');
    }
  }

  late TextEditingController nome =
      TextEditingController(text: widget.complement.nomeComplemento);

  updateComplement(
    String id,
    String token,
    String nome,
  ) async {
    try {
      var request = http.MultipartRequest(
        "PATCH",
        Uri.parse('${ApiContants.baseApi}/complement/update'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      if (resultBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes('image', resultBytes!,
              filename: result!.files.first.name,
              contentType: MediaType('image', 'jpeg')),
        );
      }

      request.fields.addAll({
        "id": id,
        "nome": nome,
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        print("Dados atualizados com sucesso");
      } else {
        print("Falha ao atualizar os dados: ${response.statusCode}");
      }
    } catch (error) {
      print("Error in request: $error");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getComplemento();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        backgroundColor: const Color(0xff3D3D3D),
        title: const Text(
          'Editar complemento',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
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
                          ? SizedBox(
                              width: 130,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  "${ApiContants.baseApi}/uploads/${widget.complement.imageComplemento}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 130,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  resultBytes!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
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
                      controller: nome,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      decoration: const InputDecoration(
                          hintText: 'Ex: Instalação grátis',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xffCFCFCF)),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final navigatorPop = Navigator.pop(context, 'Salvar');
                  final scaffoldMessenser = ScaffoldMessenger.of(context);
                  if (nome.text.isNotEmpty) {
                    final token = await getTokenFromLocalStorage();
                    updateComplement(
                      widget.complement.idComplemento,
                      token,
                      nome.text,
                    );
                    scaffoldMessenser.showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Complemento atualizado com sucesso!'),
                      ),
                    );
                    navigatorPop;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Campo não pode ser alterado para vazio'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Salvar',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
