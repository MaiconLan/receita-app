import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import 'package:receita/exception/app_exception.dart';
import 'package:receita/model/lista_compra.dart';
import 'package:receita/service/receita_service.dart';
import 'package:receita/util/config.dart';

import '../model/produto.dart';

class ListaCompraBusiness {
  ReceitaService receitaService = ReceitaService("/lista-compra");
  var _client = http_auth.BasicAuthClient('admin', 'admin');

  Future<List<Produto>> obterProdutos() async {
    http.Response response;

    response = await _client
        .get(receitaService.urlApi())
        .timeout(Duration(seconds: 2));

    return json.decode(response.body);
  }

  Future<Produto> obterProduto(int idProduto) async {
    http.Response response;

    response = await _client
        .get(receitaService.urlApi() + "/" + idProduto.toString())
        .timeout(Duration(seconds: 2));

    return Produto.fromJson(json.decode(response.body));
  }

  salvarListaCompra(ListaCompra listaCompra) async {
    http.Response response;

    if(listaCompra.idListaCompra == null)
      response = await _client.post(receitaService.urlApi(), headers: receitaService.getHeaders(), body: jsonEncode(listaCompra))
                              .timeout(Config.SERVICE_TIMEOUT);
    else
      response = await _client
          .put(receitaService.urlApi() + "/${listaCompra.idListaCompra} ", headers: receitaService.getHeaders(), body: jsonEncode(listaCompra))
          .timeout(Config.SERVICE_TIMEOUT);

    _validarStatusCode(response);

    return json.decode(response.body);
  }

  Future<List<ListaCompra>> obterListaComprasApi() async {
    http.Response response;

    response = await _client
        .get(receitaService.urlApi())
        .timeout(Config.SERVICE_TIMEOUT);

    _validarStatusCode(response);
    return (json.decode(response.body) as List)
        .map((i) => ListaCompra.fromJson(i))
        .toList();

  }

  Future<ListaCompra> obterListaCompra(int idListaCompra) async {
    http.Response response;

    response = await _client
        .get(receitaService.urlApi())
        .timeout(Config.SERVICE_TIMEOUT);

    _validarStatusCode(response);
      return json.decode(response.body).map((i) => ListaCompra.fromJson(i));
  }

  _validarStatusCode(response) {
    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)
      return true;

    if (response.statusCode == HttpStatus.badRequest) {
      var mensagem = jsonDecode(response.body);
      throw new AppException("Bad Request", mensagem);

    }

    throw new AppException("Erro Genérico", "Ops, ocorreu um erro ao realizar a busca!");
  }

  Future removerReceita(int idReceita) async {
    http.Response response;

    response = await _client
        .delete(receitaService.urlApi() + "/$idReceita")
        .timeout(Config.SERVICE_TIMEOUT);

    _validarStatusCode(response);
  }
}
