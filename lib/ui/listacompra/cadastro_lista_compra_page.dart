import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:receita/business/lista_compra_business.dart';
import 'package:receita/model/lista_compra.dart';
import 'package:receita/model/produto.dart';

class CadastroListaCompraPage extends StatefulWidget {
  final ListaCompra listaCompra;

  CadastroListaCompraPage(this.listaCompra);

  @override
  _CadastroListaCompraPageState createState() =>
      _CadastroListaCompraPageState();
}

class _CadastroListaCompraPageState extends State<CadastroListaCompraPage> {
  ListaCompraBusiness listaCompraBusiness = ListaCompraBusiness();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _editado = false;

  ListaCompra _editedListaCompra;

  Produto _editedProduto;

  final _descricaoListaCompraController = TextEditingController();
  final _descricaoProdutoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editedProduto = Produto();

    if (widget.listaCompra == null) {
      _editedListaCompra = ListaCompra();
      _editedListaCompra.produtos = List();
    } else {
      _editedListaCompra = widget.listaCompra;
      _descricaoListaCompraController.text = _editedListaCompra.descricao;
    }

    _refresh();
    _editado = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Form(
            key: _formKey,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.red,
                title: Text(_editedListaCompra.idListaCompra == null
                    ? "Nova lista"
                    : "Editar lista"),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.save),
                backgroundColor: Colors.green,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _editedListaCompra.descricao =
                        _descricaoListaCompraController.text;

                    try {
                      await listaCompraBusiness
                          .salvarListaCompra(_editedListaCompra);

                      Navigator.pop(context, _editedListaCompra);
                    } catch (e) {
                      print('TESTE');
                      print(e.toString());
                      _tratarErro(jsonDecode(e.toString()));

                    }
                  }
                },
              ),
              body: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Nome",
                                labelStyle: TextStyle(
                                    color: Colors.redAccent, fontSize: 15.0)),
                            controller: _descricaoListaCompraController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(17.0, 17.0, 7.0, 1.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text(
                              "Produtos",
                              style: TextStyle(
                                  fontSize: 26.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  labelText: "Produto",
                                  labelStyle: TextStyle(
                                      color: Colors.redAccent, fontSize: 15.0)),
                              controller: _descricaoProdutoController,
                            ),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.blueAccent,
                          child: Text("Adicionar"),
                          textColor: Colors.white,
                          onPressed: _adicionarProduto,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 10.0),
                        itemCount: _editedListaCompra.produtos != null
                            ? _editedListaCompra.produtos.length
                            : 0,
                        itemBuilder: buildItem),
                  ))
                ],
              ),
            )));
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(microseconds: 5));

    if (_editedListaCompra.produtos == null) return null;

    setState(() {
      _editedListaCompra.produtos.sort((a, b) {
        if (a.pego && !b.pego)
          return 1;
        else if (!a.pego && b.pego)
          return -1;
        else
          return 0;
      });
    });

    return null;
  }

  void _adicionarProduto() {
    if(_descricaoProdutoController.text.isEmpty)
      throw new Exception('Digite o nome do prduto!');

    setState(() {

      _editedProduto.nome = _descricaoProdutoController.text;
      _editedProduto.pego = false;
      _editedListaCompra.produtos.add(_editedProduto);

      _descricaoProdutoController.text = "";
      _editedProduto = Produto();
    });
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(
          _editedListaCompra.produtos[index].nome,
        ),
        value: _editedListaCompra.produtos[index].pego,
        secondary: CircleAvatar(
          backgroundColor: _editedListaCompra.produtos[index].pego
              ? Colors.greenAccent
              : Colors.deepOrangeAccent,
          child: Icon(
              _editedListaCompra.produtos[index].pego
                  ? Icons.check
                  : Icons.error,
              color: _editedListaCompra.produtos[index].pego
                  ? Colors.blueAccent
                  : Colors.white),
        ),
        onChanged: (c) {
          setState(() {
            _editedListaCompra.produtos[index].pego = c;
            _editado = true;
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _editado = true;
          var produto = _editedListaCompra.produtos[index];
          _editedListaCompra.produtos.remove(produto);

          final snack = SnackBar(
            content: Text("Produto \"${produto.nome}\" removido!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _editedListaCompra.produtos.add(produto);
                });
              },
            ),
            duration: Duration(seconds: 2, microseconds: 5),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<bool> _requestPop() {
    if (_editado) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair, as alterações serão desfeitas!"),
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
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });

      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  _tratarErro(error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: new Text(jsonDecode(error)['mensagemUsuario']),
      duration: new Duration(seconds: 4),
    ));
  }
}
