import 'package:flutter/material.dart';
import 'package:revisao/components/navbar.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        title: Text(
          'Sobre',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sobre o Desenvolvedor',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red, // Título em vermelho
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Este aplicativo foi desenvolvido por Eduardo, um desenvolvedor de 20 anos. O app inclui duas funcionalidades principais: '
                  'uma calculadora normal e uma calculadora de média de consumo de combustível. O objetivo é oferecer uma experiência simples e eficaz.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
            Text(
              'Obrigado por usar este aplicativo!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
