import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receita/model/produto.dart';

import '../business/produto_business.dart';

class ProdutoPage extends StatefulWidget {
  final Produto produto;

  ProdutoPage({this.produto});

  @override
  _ProdutoPageState createState() => _ProdutoPageState();
}

class _ProdutoPageState extends State<ProdutoPage> {

  void getProdutos() async {
    //produto = produtoBusiness.obterProdutos();
  }

  void getProduto(int idProduto) async {
    produto = produtoBusiness.obterProduto(idProduto);
  }

  Future<Produto> produto;

  ProdutoBusiness produtoBusiness = ProdutoBusiness();

  TextEditingController idProdutoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Receitas"),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.green, fontSize: 25.0),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Id do produto",
                  labelStyle: TextStyle(color: Colors.green)),
              controller: idProdutoController,
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  getProduto(int.parse(idProdutoController.text));
                });
              },
            ),
            Expanded(
              child: FutureBuilder<Produto>(
                future: produto,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Container(
                          child: Column(
                            children: <Widget>[
                              Text("Ocorreu um erro, perdão!"),
                              Text("${snapshot.error}")
                            ],
                          ),
                        );
                      } else {
                        return _createProdutoTable(snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ));
  }

  Widget _createProdutoTable(AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(child: _produtos(snapshot));
        });
  }

  Widget _produtos(AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        Text("Id: ${snapshot.data.idProduto}"),
        Text("Nome: ${snapshot.data.nome}"),
        Text("Descrição: ${snapshot.data.descricao}"),
        Text("Id Tipo: ${snapshot.data.tipo.idTipo}"),
        Text("Tipo: ${snapshot.data.tipo.nome}"),
      ],
    );
  }
}
