// To parse this JSON data, do
//
//     final listaCompra = listaCompraFromJson(jsonString);

import 'dart:convert';

import 'package:receita/model/produto.dart';

class ListaCompra {
  int idListaCompra;
  String descricao;
  List<Produto> produtos;

  ListaCompra({
    this.idListaCompra,
    this.descricao,
    this.produtos,
  });

  factory ListaCompra.fromRawJson(String str) => ListaCompra.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListaCompra.fromJson(Map<String, dynamic> json) => ListaCompra(
    idListaCompra: json["idListaCompra"] == null ? null : json["idListaCompra"],
    descricao: json["descricao"] == null ? null : json["descricao"],
    produtos: json["produtos"] == null ? null : List<Produto>.from(json["produtos"].map((x) => Produto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "idListaCompra": idListaCompra == null ? null : idListaCompra,
    "descricao": descricao == null ? null : descricao,
    "produtos": produtos == null ? null : List<dynamic>.from(produtos.map((x) => x.toJson())),
  };
}
