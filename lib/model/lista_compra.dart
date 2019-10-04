import 'package:receita/model/produto.dart';

class ListaCompra {
  int idListaCompra;
  String descricao;
  List<Produto> produtos = List();


  ListaCompra();

  ListaCompra.fromJson(Map<String, dynamic> json)
      : idListaCompra = json['idListaCompra'],
        descricao = json['descricao'],
        produtos =
            (json['produtos'] as List).map((i) => Produto.fromJson(i)).toList();

  Map<String, dynamic> toJson() => {
        'idListaCompra': idListaCompra,
        'descricao': descricao,
        'tipo': produtos.map((i) => i.toJson()),
      };
}
