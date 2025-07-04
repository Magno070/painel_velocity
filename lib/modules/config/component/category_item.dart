import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:painel_velocitynet/modules/config/component/edit_card_plan_category_alertdialog.dart';
import 'package:painel_velocitynet/modules/config/component/widgets/create_card_category_alertdialog.dart';
import 'package:painel_velocitynet/modules/config/model/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryItem extends StatefulWidget {
  final CategoryModel category;
  const CategoryItem({super.key, required this.category});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  List<CategoryModel> dataCategoryModel = [];
  Future<String> getTokenFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token ?? '';
  }

  void deleteItem(
    String cardId,
    String token,
  ) async {
    final url = Uri.parse("${ApiContants.baseApi}/category-plan/delete");

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "id": cardId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          dataCategoryModel;
        });
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
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
                  widget.category.imageLogoPlano == ""
                      ? Container(
                          width: 35,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(100)),
                        )
                      : SizedBox(
                          width: 35,
                          height: 40,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: Image.network(
                              fit: BoxFit.cover,
                              '${ApiContants.baseApi}/uploads/${widget.category.imageLogoPlano}',
                            ),
                          ),
                        ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.category.nomePlano,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          CreateCardCategoryAlertDialog(
                              category: CategoryModel(
                        idCategoryPlan: widget.category.idCategoryPlan,
                        nomePlano: widget.category.nomePlano,
                        subTitulo: widget.category.subTitulo,
                        selectVisualizacao: widget.category.selectVisualizacao,
                        imageLogoPlano: widget.category.imageLogoPlano,
                        images: widget.category.images,
                      )),
                    ),
                    child: const Text(
                      'Criar card',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          EditCardPlanCategoryAlertDialog(
                        category: CategoryModel(
                          idCategoryPlan: widget.category.idCategoryPlan,
                          imageLogoPlano: widget.category.imageLogoPlano,
                          nomePlano: widget.category.nomePlano,
                          selectVisualizacao:
                              widget.category.selectVisualizacao,
                          subTitulo: widget.category.subTitulo,
                          images: widget.category.images,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Editar',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  IconButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: const Color(
                          0xff2F2F2F,
                        ),
                        title: const Text(
                          'Deseja excluir esta categoria?',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final navigatorPop = Navigator.pop(context, 'Ok');
                              final scaffolMessenger =
                                  ScaffoldMessenger.of(context);

                              final token = await getTokenFromLocalStorage();
                              deleteItem(widget.category.idCategoryPlan, token);
                              const snackBar = SnackBar(
                                elevation: 2,
                                content:
                                    Text('Categoria excluida com sucesso!'),
                                backgroundColor: Colors.green,
                              );
                              scaffolMessenger.showSnackBar(snackBar);
                              navigatorPop;
                            },
                            child: const Text(
                              'Excluir',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
