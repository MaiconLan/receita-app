import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:receita/service/receita_service.dart';

import '../model/produto.dart';

class ProdutoBusiness {

  ReceitaService receitaService = ReceitaService("/produto");
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
}
