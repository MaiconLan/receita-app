import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:receita/model/lista_compra.dart';
import 'package:receita/service/receita_service.dart';

import '../model/produto.dart';

class ListaCompraBusiness {
  ReceitaService receitaService = ReceitaService("/lista-compra");
  var _client = http_auth.BasicAuthClient('admin', 'admin');

  Future<List<Produto>> obterProdutos() async {
    http.Response response;

    response = await _client.get(receitaService.urlApi());

    return json.decode(response.body);
  }

  Future<Produto> obterProduto(int idProduto) async {
    http.Response response;

    response =
        await _client.get(receitaService.urlApi() + "/" + idProduto.toString());

    return Produto.fromJson(json.decode(response.body));
  }

  salvarProduto(recProduto) async {
    http.Response response;

    response = await _client.post(receitaService.urlApi());

    return json.decode(response.body);
  }

  Future<List<ListaCompra>> obterListaComprasApi() async {
    http.Response response;

    response = await _client.get(receitaService.urlApi());

    return (json.decode(response.body) as List).map((i) => ListaCompra.fromJson(i)).toList();
  }

  List<ListaCompra> obterListaCompras() {
    //http.Response response;

    //response = await _client.get(receitaService.urlApi());

     //return json.decode(response.body);
    List<ListaCompra> list = List();

    Produto produto1 = Produto();
    Produto produto2 = Produto();
    produto1.nome = "Queijo";
    produto2.nome = "Frango";

    ListaCompra listaCompra = ListaCompra();

    listaCompra.idListaCompra = 1;
    listaCompra.descricao = "Lasanha";
    listaCompra.produtos.add(produto1);
    listaCompra.produtos.add(produto2);
    list.add(listaCompra);


    ListaCompra listaCompra2 = ListaCompra();
    listaCompra2.descricao = "Feijoada";

    list.add(listaCompra2);

    return list;
  }
}
