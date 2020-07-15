import 'dart:convert';

import 'package:http/http.dart';
import 'package:receita/model/lista_compra.dart';
import 'package:receita/service/service.dart';

class ListaCompraService extends Service {
  ListaCompraService() : super('/lista-compra');

  Future<List<ListaCompra>> getListaCompras() async {
    final Response response =
        await client().get(urlEndpoint(), headers: getHeaders());
    List<ListaCompra> listaCompra = List();

    for (Map<String, dynamic> produtoMap in jsonDecode(response.body)) {
      listaCompra.add(ListaCompra.fromJson(produtoMap));
    }

    return listaCompra;
  }

  Future<ListaCompra> getListaComprasByid(int idListaCompras) async {
    final Response response =
        await client().get(urlEndpoint(), headers: getHeaders());
    return ListaCompra.fromJson(jsonDecode(response.body));
  }

  Future<ListaCompra> salvar(ListaCompra listaCompra) async {
    final Response response = await client().post(urlEndpoint(),
        headers: getHeaders(), body: jsonEncode(listaCompra.toJson()));

    return ListaCompra.fromJson(jsonDecode(response.body));
  }

  Future<ListaCompra> atualizar(ListaCompra listaCompra) async {
    final Response response = await client().put(
        urlEndpoint() + '/${listaCompra.idListaCompra}',
        headers: getHeaders(),
        body: jsonEncode(listaCompra.toJson()));

    return ListaCompra.fromJson(jsonDecode(response.body));
  }

  Future remover(int idListaCompra) async {
    await client().delete('/$idListaCompra', headers: getHeaders());
  }
}
