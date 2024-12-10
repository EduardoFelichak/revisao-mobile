import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revisao_mobile/components/menu_component.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: MenuComponent(),
      body: Center(
        child: Text(
          "Bem-vindo ao Revisão Sistemas",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}