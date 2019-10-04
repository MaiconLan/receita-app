import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:receita/business/lista_compra_business.dart';
import 'package:receita/model/lista_compra.dart';

class ListaCompraPage extends StatefulWidget {
  @override
  _ListaCompraPageState createState() => _ListaCompraPageState();
}

class _ListaCompraPageState extends State<ListaCompraPage> {
  ListaCompraBusiness _listaCompraBusiness = ListaCompraBusiness();
  List<ListaCompra> listaCompras = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              carregarListaCompras();
            });
          },
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: listaCompras.length,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) {
              return _listaCompraCard(context, index);
            }));
  }

  carregarListaCompras() async {
    listaCompras = await _listaCompraBusiness.obterListaComprasApi();
  }

  Widget listaToWidget(ListaCompra listaCompra) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Icon(Icons.camera), Text(listaCompra.descricao)],
      ),
    );
  }

  Widget _listaCompraCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(shape: BoxShape.circle),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      listaCompras[index].idListaCompra.toString() +
                          " - " +
                          listaCompras[index].descricao,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
