// To parse this JSON data, do
//
//     final produto = produtoFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/widgets.dart';

class Produto {
  int idProduto;
  String nome;
  String descricao;
  Tipo tipo;
  bool check;

  TextEditingController controller = TextEditingController();

  Produto({
    this.idProduto,
    this.nome,
    this.descricao,
    this.tipo,
  });

  factory Produto.fromRawJson(String str) => Produto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
    idProduto: json["idProduto"] == null ? null : json["idProduto"],
    nome: json["nome"] == null ? null : json["nome"],
    descricao: json["descricao"] == null ? null : json["descricao"],
    tipo: json["tipo"] == null ? null : Tipo.fromJson(json["tipo"]),
  );

  Map<String, dynamic> toJson() => {
    "idProduto": idProduto == null ? null : idProduto,
    "nome": nome == null ? null : nome,
    "descricao": descricao == null ? null : descricao,
    "tipo": tipo == null ? null : tipo.toJson(),
  };
}

class Tipo {
  int idTipo;
  String nome;

  Tipo({
    this.idTipo,
    this.nome,
  });

  factory Tipo.fromRawJson(String str) => Tipo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tipo.fromJson(Map<String, dynamic> json) => Tipo(
    idTipo: json["idTipo"] == null ? null : json["idTipo"],
    nome: json["nome"] == null ? null : json["nome"],
  );

  Map<String, dynamic> toJson() => {
    "idTipo": idTipo == null ? null : idTipo,
    "nome": nome == null ? null : nome,
  };
}
