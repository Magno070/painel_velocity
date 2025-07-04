import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:painel_velocitynet/modules/config/component/category_item.dart';
import 'package:painel_velocitynet/modules/config/config_provider/config_provider.dart';
import 'package:painel_velocitynet/modules/config/component/create_category_alert_dialog.dart';
import 'package:painel_velocitynet/modules/config/model/category_model.dart';
import 'package:provider/provider.dart';

class CategoryComponent extends StatefulWidget {
  const CategoryComponent({super.key});

  @override
  State<CategoryComponent> createState() => _CategoryComponentState();
}

class _CategoryComponentState extends State<CategoryComponent> {
  List<CategoryModel> category = [];

  @override
  void initState() {
    super.initState();
    context.read<ConfigProvider>().loadCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorias',
                style: GoogleFonts.getFont('Poppins',
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: Colors.green),
                  onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            const CreateCategoryAlertDialog(),
                      ),
                  child: const Text(
                    '+ Criar Categoria',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
        Consumer<ConfigProvider>(
          builder: (context, controler, _) {
            return Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controler.category.length,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryItem(category: controler.category[index]);
                },
              ),
            );
          },
        )
      ],
    );
  }
}
