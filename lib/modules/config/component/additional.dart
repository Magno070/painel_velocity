import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/helpers/token.dart';
import 'package:painel_velocitynet/modules/config/component/additional_model.dart';
import 'package:painel_velocitynet/modules/config/component/editadditional_alertdialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Additional extends StatefulWidget {
  const Additional({super.key});

  @override
  State<Additional> createState() => _AdditionalState();
}

class _AdditionalState extends State<Additional> {
  final TextEditingController nome = TextEditingController();
  final MoneyMaskedTextController valor = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  FilePickerResult? result;
  late Uint8List resultBytes;

  final _formKey = GlobalKey<FormState>();

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

  createAdditionalBenefit(
    String nome,
    String preco,
    String token,
  ) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${ApiContants.baseApi}/additional/create'),
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
      request.fields.addAll({
        'name': nome,
        'preco': preco,
      });

      await request.send();
      setState(() {
        getAdditional();
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

  deletarAdditional(String id, token) async {
    var url = Uri.parse('${ApiContants.baseApi}/additional/delete');
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
          getAdditional();
        });
        // print("Complemento deletado com sucesso.");
      } else {
        // print('Falha ao deletar recurso: ${response.statusCode}');
      }
    } catch (e) {
      // print('Erro ao conectar ao servidor: $e');
    }
  }

  bool _isImageSelected() {
    return result != null;
  }

  @override
  void initState() {
    super.initState();
    getAdditional();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Adicionais',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
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
                      width: 400,
                      child: TextFormField(
                        controller: nome,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Ex: Premiere',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xffCFCFCF)),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff5F5F5F),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 200,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: valor,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: const InputDecoration(
                          hintText: 'R\$ 99,99',
                          hintStyle:
                              TextStyle(fontSize: 10, color: Color(0xffCFCFCF)),
                          contentPadding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 10),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor insira um valor valido*';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(23),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    onPressed: () async {
                      final scaffoldMesseger = ScaffoldMessenger.of(context);

                      if (_formKey.currentState!.validate() &&
                          _isImageSelected()) {
                        String precoFormatado = valor.text
                            .replaceAll('R\$ ', '')
                            .replaceAll('.', '')
                            .replaceAll(',', '.');

                        createAdditionalBenefit(
                          nome.text,
                          precoFormatado,
                          await GetToken().getTokenFromLocalStorage(),
                        );

                        scaffoldMesseger.showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Benefício cadastrado com sucesso!'),
                          ),
                        );
                        setState(() {
                          result = null;
                        });
                        nome.clear();
                        valor.updateValue(0);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                'Nome, valor e imagem não podem estar vazios'),
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
              ),
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  itemCount: dataAdditional.length,
                  itemBuilder: (context, index) {
                    final item = dataAdditional[index];
                    final preco = item['preco']['\$numberDecimal'].toString();
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 5, bottom: 5),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(
                            0xff2F2F2F,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 35,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                          fit: BoxFit.cover,
                                          '${ApiContants.baseApi}/uploads/${item['image']}'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    item['nome'],
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      'R\$ $preco',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Colors.green),
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            EditAdditionalAlertDialog(
                                              additional: AdditionalModel(
                                                idAdditional:
                                                    dataAdditional[index]['_id']
                                                        .toString(),
                                                nome: dataAdditional[index]
                                                        ['nome']
                                                    .toString(),
                                                image: dataAdditional[index]
                                                        ['image']
                                                    .toString(),
                                                preco: dataAdditional[index]
                                                        ['preco']
                                                    .toString(),
                                                idPlans: '',
                                              ),
                                            )),
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
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        backgroundColor:
                                            const Color(0xff3D3D3D),
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
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              deletarAdditional(
                                                  dataAdditional[index]['_id'],
                                                  GetToken()
                                                      .getTokenFromLocalStorage);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                      'Benefício excluido com sucesso!'),
                                                ),
                                              );
                                              Navigator.pop(context, 'Excluir');
                                            },
                                            child: const Text(
                                              'Excluir',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    child: Container(
                                      width: 35,
                                      height: 40,
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
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
