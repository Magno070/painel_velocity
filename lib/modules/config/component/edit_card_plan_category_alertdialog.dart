import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/modules/config/model/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditCardPlanCategoryAlertDialog extends StatefulWidget {
  final CategoryModel category;
  const EditCardPlanCategoryAlertDialog({super.key, required this.category});

  @override
  State<EditCardPlanCategoryAlertDialog> createState() =>
      _EditCardPlanCategoryAlertDialogState();
}

class _EditCardPlanCategoryAlertDialogState
    extends State<EditCardPlanCategoryAlertDialog> {
  late String? selectedValue = widget.category.selectVisualizacao;
  late TextEditingController nomePlano =
      TextEditingController(text: widget.category.nomePlano);
  late TextEditingController subTitulo =
      TextEditingController(text: widget.category.subTitulo);

  FilePickerResult? result;
  Uint8List? resultBytes;

  uploadImage() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        resultBytes = result!.files.first.bytes;
      });
    }
  }

  Future<String> getTokenFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token ?? '';
  }

  List<CategoryModel> cardPlanCategory = [];
  Future<void> cardsCategoryPlans(
    String categoryId,
    token,
  ) async {
    final token = await getTokenFromLocalStorage();
    final response = await http.post(
      Uri.parse('${ApiContants.baseApi}/category-plan'),
      body: jsonEncode({"_id": categoryId}),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      setState(() {
        cardPlanCategory =
            jsonList.map((json) => CategoryModel.fromJson(json)).toList();
      });
    } else {
      // print('Erro ao buscar dados: ${response.statusCode}');
    }
  }

  void deleteItem(String cardId, String token, cardName) async {
    final url = Uri.parse("${ApiContants.baseApi}/category-plan/delete-card");

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"idCategory": cardId, "cardName": cardName}),
      );

      if (response.statusCode == 200) {
        setState(() {
          listImages.remove(cardName);
        });
      } else {
        if (kDebugMode) {
          // print('Erro ao excluir o item: ${response.statusCode}');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        // print('Erro na solicitação DELETE: $error');
      }
    }
  }

  updateDataCategoryPlan(
    String id,
    String token,
    String nome,
    String subTitulo,
    String visualizacao,
  ) async {
    try {
      var request = http.MultipartRequest(
        "PATCH",
        Uri.parse('${ApiContants.baseApi}/category-plan/patch'),
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
        "subTitulo": subTitulo,
        "visualizacao": visualizacao,
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

  final List<String> items = [
    'Site',
    'Simulador',
    'Ambos',
  ];

  List<dynamic> listImages = [];
  @override
  void initState() {
    super.initState();
    // print(widget.category.idCategoryPlan);
    cardsCategoryPlans(
        widget.category.idCategoryPlan, getTokenFromLocalStorage());
    listImages = widget.category.images;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: const Color(
          0xff2F2F2F,
        ),
        title: const Text(
          textAlign: TextAlign.center,
          'Cards Enviados',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            uploadImage();
                          },
                          child: Container(
                            width: 130,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white),
                            ),
                            child: result == null
                                ? SizedBox(
                                    width: 130,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        '${ApiContants.baseApi}/uploads/${widget.category.imageLogoPlano}',
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
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 260,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nome da categoria',
                                    style: GoogleFonts.getFont('Poppins',
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff5F5F5F),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 40,
                                    width: 250,
                                    child: TextFormField(
                                      controller: nomePlano,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      decoration: const InputDecoration(
                                        hintText: 'Start',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffCFCFCF),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SubTítulo',
                                    style: GoogleFonts.getFont('Poppins',
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff5F5F5F),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 40,
                                    width: 250,
                                    child: TextFormField(
                                      controller: subTitulo,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      decoration: const InputDecoration(
                                        hintText: 'Texto Exemplo',
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffCFCFCF),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Visualização',
                                    style: GoogleFonts.getFont('Poppins',
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    color: const Color(0xff5F5F5F),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        dropdownStyleData:
                                            const DropdownStyleData(
                                          decoration: BoxDecoration(
                                            color: Color(0xff5F5F5F),
                                          ),
                                        ),
                                        isExpanded: true,
                                        iconStyleData: const IconStyleData(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.green,
                                          ),
                                        ),
                                        hint: const Text(
                                          'Select',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                        items: items
                                            .map((String item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ))
                                            .toList(),
                                        value: selectedValue,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedValue = value;
                                          });
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          height: 40,
                                          width: 140,
                                        ),
                                        menuItemStyleData:
                                            const MenuItemStyleData(
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    listImages.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              'Sem cards',
                              style: TextStyle(
                                  color: Color(0xFF9C9C9C), fontSize: 20),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              width: 500,
                              height: 400,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                    children: [
                                      ...listImages.map((imageName) => Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 200,
                                                  height: 400,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      '${ApiContants.baseApi}/uploads/$imageName',
                                                      fit: BoxFit.contain,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                          Icons.error,
                                                          color: Colors.red,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 12, top: 5),
                                                child: IconButton(
                                                  icon: const Icon(Icons.delete,
                                                      color: Colors.white),
                                                  onPressed: () =>
                                                      showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      backgroundColor:
                                                          const Color(
                                                        0xff2F2F2F,
                                                      ),
                                                      title: const Text(
                                                        'Tem certeza de que deseja deletar o card?',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child: const Text(
                                                            'Cancelar',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            final scaffoldMessenger =
                                                                ScaffoldMessenger
                                                                    .of(context);
                                                            final navigatorPop =
                                                                Navigator.pop(
                                                                    context,
                                                                    'OK');
                                                            final token =
                                                                await getTokenFromLocalStorage();
                                                            deleteItem(
                                                                widget.category
                                                                    .idCategoryPlan,
                                                                token,
                                                                imageName);
                                                            const snackBar =
                                                                SnackBar(
                                                              elevation: 2,
                                                              content: Text(
                                                                  'Card deletado com sucesso!'),
                                                              backgroundColor:
                                                                  Colors.green,
                                                            );
                                                            scaffoldMessenger
                                                                .showSnackBar(
                                                                    snackBar);
                                                            navigatorPop;
                                                          },
                                                          child: const Text(
                                                            'Confirmar',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                ],
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
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final navigatorPop = Navigator.pop(context, 'Salvar');
                      final token = await getTokenFromLocalStorage();
                      updateDataCategoryPlan(
                          widget.category.idCategoryPlan,
                          token,
                          nomePlano.text,
                          subTitulo.text,
                          selectedValue!);
                      const snackBar = SnackBar(
                        elevation: 2,
                        content: Text('Categoria atualizada com sucesso!'),
                        backgroundColor: Colors.green,
                      );
                      scaffoldMessenger.showSnackBar(snackBar);
                      navigatorPop;
                    },
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
