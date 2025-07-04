// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:painel_velocitynet/constantes/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:painel_velocitynet/modules/plans/widget/plans.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Testando extends StatefulWidget {
  const Testando({super.key});

  @override
  State<Testando> createState() => _TestandoState();
}

class _TestandoState extends State<Testando>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  Future<String> getTokenFromLocalStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token ?? '';
  }

  List<dynamic> categoryPlans = [];
  bool _isLoading = true;

  Future<void> fCategoryPlans() async {
    try {
      final token = await getTokenFromLocalStorage();
      final response = await http.get(
        Uri.parse('${ApiContants.baseApi}/category-plan'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categoryPlans = data;
          _tabController =
              TabController(length: categoryPlans.length, vsync: this);
          _isLoading = false;
        });
      } else {
        print('Erro ao buscar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao realizar requisição: $e');
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fCategoryPlans();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Container(
          color: Colors.black,
          width: 1400,
          child: TabBar(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            controller: _tabController,
            dividerColor: Colors.black,
            indicatorColor: Colors.transparent,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            indicator: const BoxDecoration(color: Color(0xff181919)),
            tabs: categoryPlans
                .map((plan) => Tab(
                      child: Container(
                        padding: const EdgeInsets.only(left: 100, right: 100),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xff2F2F2F), width: 1),
                            left:
                                BorderSide(color: Color(0xff2F2F2F), width: 1),
                            right:
                                BorderSide(color: Color(0xff2F2F2F), width: 1),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                        child: Row(
                          children: [
                            // SizedBox(
                            //   width: 50,
                            //   height: 50,
                            //   child: Image.network(
                            //     '${ApiContants.baseApi}/category-plan/${plan['logo']}',
                            //   ),
                            // ),
                            Text(
                              plan['nome'],
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: categoryPlans
                .map(
                  (plan) => const Plans(),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
