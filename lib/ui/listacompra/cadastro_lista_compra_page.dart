import 'package:flutter/material.dart';
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
  List<Widget> _produtosWidget = List();

  final _formKey = GlobalKey<FormState>();

  bool _editado = false;

  ListaCompra _editedListaCompra;

  final _descricaoListaCompraController = TextEditingController();

  Map<dynamic, TextEditingController> nomeProdutoControllers = Map();
  Map<dynamic, TextEditingController> descricaoProdutoControllers = Map();

  @override
  void initState() {
    super.initState();

    if (widget.listaCompra == null) {
      _editedListaCompra = ListaCompra();
    } else {
      _editedListaCompra = widget.listaCompra;
      _descricaoListaCompraController.text = _editedListaCompra.descricao;
    }

    _carregarProdutosFromListaCompra();
    _editado = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                title: Text(
                    _editedListaCompra.descricao ?? "Nova lista de compras"),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.save),
                backgroundColor: Colors.red,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _editedListaCompra.descricao =
                        _descricaoListaCompraController.text;

                    listaCompraBusiness.salvarListaCompra(_editedListaCompra);

                    Navigator.pop(context, _editedListaCompra);
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
                        TextFormField(
                          controller: _descricaoListaCompraController,
                          validator: (value) => value.isEmpty
                              ? 'Insira a descricao da lista'
                              : null,
                          decoration: InputDecoration(
                              labelText: "Nome da lista",
                              labelStyle:
                                  TextStyle(fontSize: 22.0, color: Colors.red)),
                          onSaved: (text) {
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
                      children: _produtosWidget,
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
                                var produto = Produto();
                                _editado = true;
                                _editedListaCompra.produtos.add(produto);
                                _atualizarProdutosWidget();
                              });
                            },
                            color: Colors.green,
                            focusColor: Colors.purple,
                          ),
                        )
                      ],
                    ),
                  ])),
            )));
  }

  Widget getNomeProdutoTextField(Produto produto) {
    produto.controller.text = produto.nome;
    return TextField(
      controller: produto.controller,
      decoration: InputDecoration(
          labelText: "Nome do produto",
          labelStyle: TextStyle(fontSize: 22.0, color: Colors.red)),
      onChanged: (value) {
        setState(() {
          _editado = true;
          produto.nome = value;
        });
      },
    );
  }

  @deprecated
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

  _carregarProdutosFromListaCompra() {
    _produtosWidget.clear();
    if (_editedListaCompra.produtos == null)
      _editedListaCompra.produtos = List();

    setState(() {
      for (Produto produto in _editedListaCompra.produtos) {
        _produtosWidget.add(getNomeProdutoTextField(produto));
      }
    });
  }

  _atualizarProdutosWidget() {
    _produtosWidget.clear();
    if (_editedListaCompra.produtos == null)
      _editedListaCompra.produtos = List();

    for (Produto produto in _editedListaCompra.produtos) {
      _produtosWidget.add(getNomeProdutoTextField(produto));
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
