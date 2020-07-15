import 'package:flutter/material.dart';
import 'package:receita/business/lista_compra_business.dart';

import 'listacompra/lista_compra_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ListaCompraBusiness listaCompraBusiness = ListaCompraBusiness();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: _icons.elementAt(_selectedIndex),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text("Lista de Compras")),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), title: Text("Receitas")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), title: Text("Perfil")),
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

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    ListaCompraPage(),
    Text(
      'Index 2: Receitas',
      style: optionStyle,
    ),
    Text(
      'Index 1: Perfil',
      style: optionStyle,
    ),
  ];

  static List<Icon> _icons = <Icon>[
    Icon(Icons.shopping_cart),
    Icon(Icons.receipt),
    Icon(Icons.account_box),
  ];
}
