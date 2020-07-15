import 'package:receita/model/lista_compra.dart';
import 'package:receita/service/lista_compra_service.dart';

class ListaCompraBusiness {
  ListaCompraService _listaCompraService = ListaCompraService();

  Future<ListaCompra> salvarListaCompra(ListaCompra listaCompra) async {
    if (listaCompra.idListaCompra == null)
      return await _listaCompraService.salvar(listaCompra);
    else
      return await _listaCompraService.atualizar(listaCompra);
  }

  Future<List<ListaCompra>> getListaCompras() async {
    return _listaCompraService.getListaCompras();
  }

  Future<ListaCompra> getListaCompra(int idListaCompra) {
    return _listaCompraService.getListaComprasByid(idListaCompra);
  }

  Future removerReceita(int idListaCompra) async {
    await _listaCompraService.remover(idListaCompra);
  }
}
