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
                    _editedListaCompra.idListaCompra == null ? "Nova lista" : "Editar lista"),
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.save),
                backgroundColor: Colors.green,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _editedListaCompra.descricao =
                        _descricaoListaCompraController.text;

                    await listaCompraBusiness
                        .salvarListaCompra(_editedListaCompra);

                    Navigator.pop(context, _editedListaCompra);
                  }
                },
              ),
              body: SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextFormField(

                          onEditingComplete: () {
                            setState(() {
                              _editado = true;
                            });
                          },
                          controller: _descricaoListaCompraController,
                          validator: (value) => value.isEmpty
                              ? 'Insira o nome da lista'
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
                            iconSize: 10.0,
                            icon: Icon(
                              Icons.add,
                              color: Colors.greenAccent,
                              size: 30.0,
                            ),
                            splashColor: Colors.blue,
                            highlightColor: Colors.red,
                            onPressed: () {
                              var focusNode = new FocusNode();
                              var produto = Produto();

                              setState(() {
                                _editado = true;
                                _addProdutoWidget(produto);
                                FocusScope.of(context).unfocus();
                                FocusScope.of(context).requestFocus(focusNode);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ])),
            )));
  }

  Widget getNomeProdutoTextField(Produto produto, {FocusNode focusNode}) {
    produto.controller.text = produto.descricao;
    return GestureDetector(
      onHorizontalDragEnd: _remove(),
      child: TextField(
        focusNode: focusNode,
        controller: produto.controller,
        decoration: InputDecoration(
            labelText: "Nome do produto",
            labelStyle: TextStyle(fontSize: 22.0, color: Colors.red)),
        onChanged: (value) {
          setState(() {
            _editado = true;
            produto.descricao = value;
          });
        },
      ),
    );
  }

  _remove(){

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

  _addProdutoWidget(Produto produto, {FocusNode focusNode}) {
    _produtosWidget.add(getNomeProdutoTextField(produto, focusNode: focusNode));
    _editedListaCompra.produtos.add(produto);
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
}
