import 'package:flutter/material.dart';

class TvDataProvider extends ChangeNotifier {
  String id = '';
  String titulo = '';
  String descricao = '';
  String valor = '';
  String imagem = '';

  void updateData(String id, String titulo, String descricao, String valor,
      dynamic imagem) {
    id = id;
    titulo = titulo;
    descricao = descricao;
    valor = valor;
    imagem = imagem;

    notifyListeners();
  }
}
