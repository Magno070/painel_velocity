import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/helpers/token.dart';
import 'package:painel_velocitynet/modules/config/config_provider/config_provider.dart';
import 'package:painel_velocitynet/modules/config/model/category_model.dart';
import 'package:provider/provider.dart';

class CreateCategoryAlertDialog extends StatefulWidget {
  const CreateCategoryAlertDialog({super.key});

  @override
  State<CreateCategoryAlertDialog> createState() =>
      _CreateCategoryAlertDialogState();
}

class _CreateCategoryAlertDialogState extends State<CreateCategoryAlertDialog> {
  List<CategoryModel> dataCategoryModel = [];
  TextEditingController nomePlano = TextEditingController();
  TextEditingController subTitulo = TextEditingController();
  FilePickerResult? result;
  late Uint8List resultBytes;
  String? selectedValue;
  final List<String> items = [
    'Site',
    'Simulador',
    'Ambos',
  ];
  String? selectedImage;
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

  createCategoryPlan(
    nome,
    subtutlo,
    selectVisualizacao,
    token,
  ) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('${ApiContants.baseApi}/category-plan/create'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        http.MultipartFile.fromBytes('image', resultBytes,
            filename: result!.files.first.name,
            contentType: MediaType('image', 'jpeg')),
      );
      request.fields.addAll({
        'nome': nome,
        'subTitulo': subtutlo,
        'visualizacao': selectVisualizacao
      });

      await request.send();
    } catch (error) {
      // print("Erro na requisição: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        textAlign: TextAlign.center,
        'Criar Categoria',
        style: GoogleFonts.getFont('Poppins',
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
      ),
      backgroundColor: const Color(0xff3D3D3D),
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          width: 430,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
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
                              ? const Center(
                                  child: Text(
                                    'Adicionar\nicone da categoria',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
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
                                    dropdownStyleData: const DropdownStyleData(
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
                                          fontSize: 14, color: Colors.white),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      height: 40,
                                      width: 140,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
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
              ),
              SizedBox(
                width: 420,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 190,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text(
                          'Fechar',
                          style: TextStyle(color: Color(0xff6F6F6F)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: () async {
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          final navigatorPop = Navigator.pop(context, 'Salvar');
                          final provider = Provider.of<ConfigProvider>(context,
                              listen: false);
                          if (nomePlano.text.isNotEmpty &&
                              subTitulo.text.isNotEmpty &&
                              selectedValue != null &&
                              selectedValue!.isNotEmpty) {
                            createCategoryPlan(
                              nomePlano.text,
                              subTitulo.text,
                              selectedValue!,
                              await GetToken().getTokenFromLocalStorage(),
                            );
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Categoria criada com sucesso!'),
                              ),
                            );
                            navigatorPop;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Os campos não podem ser vazios'),
                              ),
                            );
                          }

                          provider.loadCategory();
                        },
                        child: const Text(
                          'Salvar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
