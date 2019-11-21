import 'package:flutter/material.dart';
import 'package:receita/business/lista_compra_business.dart';
import 'package:receita/model/lista_compra.dart';
import 'package:receita/model/produto.dart';
import 'package:receita/ui/util/ui_utils.dart';

class CadastroListaCompraPage extends StatefulWidget {
  final ListaCompra listaCompra;

  CadastroListaCompraPage(this.listaCompra);

  @override
  _CadastroListaCompraPageState createState() =>
      _CadastroListaCompraPageState();
}

class _CadastroListaCompraPageState extends State<CadastroListaCompraPage> {
  ListaCompraBusiness listaCompraBusiness = ListaCompraBusiness();
  List<Widget> _produtos = List();

  final _nameFocus = FocusNode();
  bool _editado = false;

  ListaCompra _editedListaCompra;

  final _descricaoListaCompraController = TextEditingController();
  final _descricaoProdutoController = TextEditingController();

  Map<int, TextEditingController> nomeProdutoControllers = Map();
  Map<int, TextEditingController> descricaoProdutoControllers = Map();

  @override
  void initState() {
    super.initState();

    if (widget.listaCompra == null) {
      _editedListaCompra = ListaCompra();
    } else {
      _editedListaCompra = widget.listaCompra;
      _descricaoListaCompraController.text = _editedListaCompra.descricao;
      _descricaoProdutoController.text = "";
    }

    _atualizarListaProdutos();
    _editado = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title:
                Text(_editedListaCompra.descricao ?? "Nova lista de compras"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
            onPressed: () {
              if (_editedListaCompra.descricao != null &&
                  _editedListaCompra.descricao.isNotEmpty) {
                Navigator.pop(context, _editedListaCompra);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Lista de Compras",
                      style: TextStyle(
                          fontSize: 26.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _descricaoListaCompraController,
                      focusNode: _nameFocus,
                      decoration: InputDecoration(
                          labelText: "Nome da lista",
                          labelStyle:
                              TextStyle(fontSize: 22.0, color: Colors.red)),
                      onChanged: (text) {
                        _editado = true;
                        setState(() {
                          _editedListaCompra.descricao = text;
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Produtos",
                        style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: _produtos,
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.deepOrangeAccent,
                          size: 30.0,
                        ),
                        splashColor: Colors.blue,
                        highlightColor: Colors.red,
                        onPressed: () {
                          setState(() {
                            _produtos.add(getNomeProdutoTextField(Produto()));
                          });
                        },
                        color: Colors.green,
                        focusColor: Colors.purple,
                      ),
                    )
                  ],
                ),
              ])),
        ));
  }

  Widget getNomeProdutoTextField(Produto produto) {
    final _nomeProdutoController = TextEditingController();

    if (produto.idProduto != null) {
      nomeProdutoControllers.putIfAbsent(
          produto.idProduto, () => _nomeProdutoController);
      _nomeProdutoController.text = produto.nome;
    }

    return TextFormField(
      validator: (nome) => nome.isEmpty ? 'Insira o nome do produto' : null,
      controller: _nomeProdutoController,
      decoration: InputDecoration(
          labelText: "Nome do produto",
          labelStyle: TextStyle(fontSize: 22.0, color: Colors.red)),
      onSaved: (text) {
        _editado = true;
      },
    );
  }

  TextFormField getDescricaoProdutoTextField(Produto produto) {
    final _descricaoProdutoController = TextEditingController();

    if (produto.idProduto != null) {
      nomeProdutoControllers.putIfAbsent(
          produto.idProduto, () => _descricaoProdutoController);
      _descricaoProdutoController.text = produto.descricao;
    }

    return TextFormField(
      validator: (nome) =>
          nome.isEmpty ? 'Insira a descrição do produto' : null,
      controller: _descricaoProdutoController,
      decoration: InputDecoration(labelText: "Descrição"),
      onSaved: (text) {
        _editado = true;
      },
    );
  }

  _atualizarListaProdutos() {

    for (Produto produto in _editedListaCompra.produtos) {
      _produtos.add(getNomeProdutoTextField(produto));
    }

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
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
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
}
