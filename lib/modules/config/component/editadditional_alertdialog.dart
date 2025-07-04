import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/modules/config/component/additional_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditAdditionalAlertDialog extends StatefulWidget {
  final AdditionalModel additional;
  const EditAdditionalAlertDialog({super.key, required this.additional});

  @override
  State<EditAdditionalAlertDialog> createState() =>
      _EditAdditionalAlertDialogState();
}

class _EditAdditionalAlertDialogState extends State<EditAdditionalAlertDialog> {
  late TextEditingController nome =
      TextEditingController(text: widget.additional.nome);
  late TextEditingController valor = TextEditingController(
      text: 'R\$ ${widget.additional.preco.replaceAll(RegExp(r'[^\d.]'), '')}');

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

  updateAdditional(
    String id,
    String token,
    String nome,
    String preco,
  ) async {
    try {
      var request = http.MultipartRequest(
        "PATCH",
        Uri.parse('${ApiContants.baseApi}/additional/update'),
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
        "preco": preco,
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        // print("Dados atualizados com sucesso");
      } else {
        // print("Falha ao atualizar os dados: ${response.statusCode}");
      }
    } catch (error) {
      // print("Error in request: $error");
      return null;
    }
  }

  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  String formatCurrency(String value) {
    String cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');
    double parsedValue = double.tryParse(cleanedValue)! / 100;
    return _currencyFormat.format(parsedValue);
  }

  List<dynamic> dataAdditional = [];
  Future<void> getAdditional() async {
    final token = await getTokenFromLocalStorage();
    final response = await http.get(
      Uri.parse('${ApiContants.baseApi}/additional'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        dataAdditional = json.decode(response.body);
      });
    } else {
      // print('Erro ao buscar dados: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdditional();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        backgroundColor: const Color(0xff3D3D3D),
        title: const Text(
          'Editar Benefício',
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
                    child: resultBytes == null
                        ? SizedBox(
                            width: 130,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "${ApiContants.baseApi}/uploads/${widget.additional.image}",
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
                      controller: nome,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Ex: Premiere',
                        hintStyle:
                            TextStyle(fontSize: 14, color: Color(0xffCFCFCF)),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome não pode estar vazio';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff5F5F5F),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: 200,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      final formattedValue = formatCurrency(value);
                      valor.value = TextEditingValue(
                        text: formattedValue,
                        selection: TextSelection.collapsed(
                          offset: formattedValue.length,
                        ),
                      );
                    },
                    controller: valor,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'R\$ 99,99',
                      hintStyle:
                          TextStyle(fontSize: 10, color: Color(0xffCFCFCF)),
                      contentPadding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 10),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Valor não pode estar vazio';
                      }
                      return null;
                    },
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
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navigatorPop = Navigator.pop(context, 'Salvar');
                  if (nome.text.isNotEmpty && valor.text.isNotEmpty) {
                    final token = await getTokenFromLocalStorage();
                    updateAdditional(widget.additional.idAdditional, token,
                        nome.text, valor.text);
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Benefício atualizado com sucesso!'),
                      ),
                    );
                    navigatorPop;
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content:
                            Text('Nenhum campo pode ser alterado para vazio'),
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
