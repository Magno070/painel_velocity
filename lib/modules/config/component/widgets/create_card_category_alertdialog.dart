import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/helpers/token.dart';
import 'package:painel_velocitynet/modules/config/model/category_model.dart';

class CreateCardCategoryAlertDialog extends StatefulWidget {
  final CategoryModel category;
  const CreateCardCategoryAlertDialog({super.key, required this.category});

  @override
  State<CreateCardCategoryAlertDialog> createState() =>
      _CreateCardCategoryAlertDialogState();
}

class _CreateCardCategoryAlertDialogState
    extends State<CreateCardCategoryAlertDialog> {
  List<CategoryModel> dataCategoryModel = [];
  FilePickerResult? result;
  List<Uint8List> images = [];

  uploadImage() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      setState(() {
        images.addAll(result!.files.map((file) => file.bytes!).toList());
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  updateCategoryImages(String id, String token) async {
    try {
      var request = http.MultipartRequest(
        "PATCH",
        Uri.parse('${ApiContants.baseApi}/category-plan/create-card'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      for (var image in images) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'images',
            image,
            filename: result!.files.first.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
        request.fields.addAll({"idCategory": id});
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        // print("Images updated successfully.");
      } else {
        // print("Failed to update images: ${response.statusCode}");
      }
    } catch (error) {
      // print("Error in request: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(
        0xff2F2F2F,
      ),
      title: const Text(
        textAlign: TextAlign.center,
        'Criar Card',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        Column(
          children: [
            InkWell(
                onTap: () {
                  uploadImage();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    textAlign: TextAlign.center,
                    'Adicionar imagem',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            if (result != null)
              if (images.isNotEmpty)
                SizedBox(
                  width: 600,
                  height: 500,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              images[index],
                              width: 250,
                              height: 500,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => removeImage(index),
                            ),
                          ),
                        ],
                      );
                    },
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
                    final navigatorPop = Navigator.pop(context, 'Criar');
                    if (images.isEmpty) {
                      const snackBar = SnackBar(
                        elevation: 2,
                        content: Text('Por favor selecione uma imagem!'),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      const snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Card criado com sucesso!'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      updateCategoryImages(
                        widget.category.idCategoryPlan,
                        await GetToken().getTokenFromLocalStorage(),
                      );
                      navigatorPop;
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
      ],
    );
  }
}
