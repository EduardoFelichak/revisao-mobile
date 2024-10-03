import 'package:flutter/material.dart';
import 'package:revisao/screens/about.dart';
import 'package:revisao/screens/average.dart';
import 'package:revisao/screens/calculator.dart';
import 'package:revisao/screens/home.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.fromLTRB(10, 80, 0, 0),
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage())
            ),
          ),
          ListTile(
            leading: Icon(Icons.calculate),
            title: Text('Calculadora'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Calculator())
            ),
          ),
          ListTile(
            leading: Icon(Icons.gas_meter),
            title: Text('Cálculo de Média'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Average())
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Sobre'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => About())
            ),
          ),
        ],
      ),
    );
  }
}

