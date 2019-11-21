import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:receita/business/lista_compra_business.dart';
import 'package:receita/model/lista_compra.dart';

import 'cadastro_lista_compra_page.dart';

class ListaCompraPage extends StatefulWidget {
  @override
  _ListaCompraPageState createState() => _ListaCompraPageState();
}

class _ListaCompraPageState extends State<ListaCompraPage> {
  ListaCompraBusiness _listaCompraBusiness = ListaCompraBusiness();
  List<ListaCompra> listaCompras = List();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          tooltip: "Adicionar",
          focusColor: Colors.green,
          child: Icon(Icons.add_circle),
          backgroundColor: Colors.blue,
          onPressed: () {
            mostrarListaCompraPage(listaCompra: ListaCompra());
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
    try {
      listaCompras =
          await _listaCompraBusiness.obterListaComprasApi().whenComplete(() {
        setState(() {});
      });
    } catch (e) {
      _tratarErro(e.toString());
      listaCompras.clear();
    }
  }

  _tratarErro(String error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: new Text(error),
      duration: new Duration(seconds: 4),
    ));
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
        color: Colors.deepOrangeAccent,
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
                      listaCompras[index].descricao,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        mostrarListaCompraPage(listaCompra: listaCompras[index]);
      },
    );
  }

  void mostrarListaCompraPage({ListaCompra listaCompra}) async {
    final recListaCompra = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroListaCompraPage(listaCompra)));

    if (recListaCompra != null) {
      try {
        await _listaCompraBusiness.salvarListaCompra(recListaCompra);
      } catch (e, s) {
        print(s.toString());
        _tratarErro(e.toString());
      }

      carregarListaCompras();
    }
  }

  _ListaCompraPageState() {
    carregarListaCompras();
  }
}
