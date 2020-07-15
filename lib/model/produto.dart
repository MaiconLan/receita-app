// To parse this JSON data, do
//
//     final produto = produtoFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/widgets.dart';

class Produto {
  int idProduto;
  String descricao;
  bool check;

  TextEditingController controller = TextEditingController();

  Produto({
    this.idProduto,
    this.descricao,
  });

  factory Produto.fromRawJson(String str) => Produto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
    idProduto: json["idProduto"] == null ? null : json["idProduto"],
    descricao: json["descricao"] == null ? null : json["descricao"],
  );

  Map<String, dynamic> toJson() => {
    "idProduto": idProduto == null ? null : idProduto,
    "descricao": descricao == null ? null : descricao,
  };
}
