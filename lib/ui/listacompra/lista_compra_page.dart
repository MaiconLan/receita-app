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
        body: FutureBuilder<List<ListaCompra>>(
          future: _listaCompraBusiness.getListaCompras(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(
                        color: Colors.deepOrangeAccent, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao Carregar os Dados",
                    style: TextStyle(color: Colors.redAccent, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  return _listaComprasCard(context, snapshot.data);
                }
            }
          },
        )
        // ListView.builder(
        //     scrollDirection: Axis.vertical,
        //     itemCount: listaCompras.length,
        //     padding: EdgeInsets.all(10.0),
        //     itemBuilder: (context, index) {
        //       return _listaCompraCard(context, index);
        //     })
        );
  }

  Future carregarListaCompras() async {
    try {
      listaCompras =
          await _listaCompraBusiness.getListaCompras().whenComplete(() {
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

  Widget _listaComprasCard(
      BuildContext context, List<ListaCompra> listaCompras) {
    List<Widget> widgets = List();

    for (var value in listaCompras) {
      widgets.add(_listaCompraCard(context, value));
    }

    return SingleChildScrollView(
      child: Column(
        children: widgets,
      ),
    );
  }

  Widget _listaCompraCard(BuildContext context, ListaCompra listaCompra) {
    return GestureDetector(
      child: Card(
        color: Colors.deepOrangeAccent,
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      listaCompra.descricao,
                      style: TextStyle(
                          fontSize: 25.0,
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
      onHorizontalDragEnd: (detail) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Remover lista de compras?"),
                content: Text("Tem certeza que deseja remover?!"),
                actions: <Widget>[
                  FlatButton(
                    splashColor: Colors.red,
                    color: Colors.redAccent,
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                      textAlign: TextAlign.left,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    splashColor: Colors.green,
                    color: Colors.greenAccent,
                    child: Text(
                      "Sim",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: () {
                      _listaCompraBusiness
                          .removerReceita(listaCompra.idListaCompra);
                      Navigator.pop(context);
                      carregarListaCompras();
                    },
                  )
                ],
              );
            });
      },
      onTap: () {
        mostrarListaCompraPage(listaCompra: listaCompra);
      },
    );
  }

  void mostrarListaCompraPage({ListaCompra listaCompra}) async {
    try {
      final recListaCompra = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CadastroListaCompraPage(listaCompra)));

      if (recListaCompra != null) {
        carregarListaCompras();
      }
    } catch (e, s) {
      print(s.toString());
      _tratarErro(e.toString());
    }
  }

  _ListaCompraPageState() {
    carregarListaCompras();
  }
}
