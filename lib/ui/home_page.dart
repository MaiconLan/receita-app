import 'package:flutter/material.dart';
import 'package:receita/business/lista_compra_business.dart';
import 'package:receita/business/produto_business.dart';
import 'package:receita/model/lista_compra.dart';

import 'listacompra/cadastro_lista_compra_page.dart';
import 'listacompra/lista_compra_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProdutoBusiness produtoBusiness = ProdutoBusiness();
  ListaCompraBusiness listaCompraBusiness = ListaCompraBusiness();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receitas e Lista de Compras"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), title: Text("Perfil")),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), title: Text("Receitas")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text("Lista de Compras")),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _mostrarProdutoPage({ListaCompra listaCompra}) async {
    final recProduto = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroListaCompraPage(
                  listaCompra
                )));

    if (recProduto != null) {
      await produtoBusiness.salvarProduto(recProduto);
      _atualizarListaCompras();
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Perfil',
      style: optionStyle,
    ),
    Text(
      'Index 1: Receitas',
      style: optionStyle,
    ),
    ListaCompraPage(),
  ];

  _atualizarListaCompras() {}
}
