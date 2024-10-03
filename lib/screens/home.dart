import 'package:flutter/material.dart';
import 'package:revisao/components/navbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        title: Text(
          'Revisão Sistemas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Caminho para sua logo
              width: 300, // Largura da imagem
              height: 300, // Altura da imagem
            ),
            SizedBox(height: 20), // Espaçamento entre a imagem e o texto
            Text(
              'Bem-vindo',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
