import 'package:flutter/material.dart';
import 'package:revisao/components/navbar.dart';

class Average extends StatefulWidget {
  @override
  _AverageState createState() => _AverageState();
}

class _AverageState extends State<Average> {
  final TextEditingController _litrosController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  List<Map<String, double>> medias = [];

  void _calcularMedia() {
    final litros = double.tryParse(_litrosController.text);
    final distancia = double.tryParse(_distanciaController.text);

    _litrosController.text = '';
    _distanciaController.text = '';

    if (litros != null && distancia != null && litros > 0) {
      setState(() {
        medias.add({
          'distancia': distancia, // chave correta
          'litros': litros,       // chave correta
          'media': distancia / litros // chave correta
        });
      });
    }
  }

  void _removerItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover Item'),
          content: Text('Tem certeza que deseja remover este item?'),
          actions: [
            TextButton(
              child: Text('NÃO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('SIM'),
              onPressed: () {
                setState(() {
                  medias.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(
          'Calculadora de Consumo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _distanciaController,
              decoration: InputDecoration(
                labelText: 'Km Rodados',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _litrosController,
              decoration: InputDecoration(
                labelText: 'Litros de Combustível',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularMedia,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: Text(
                'Calcular e Adicionar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: medias.length,
                itemBuilder: (context, index) {
                  final media = medias[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Km: ${media['distancia']!.toStringAsFixed(2)} km'),
                          Text('Litros: ${media['litros']!.toStringAsFixed(2)} L'),
                          Text('Média: ${media['media']!.toStringAsFixed(2)} km/L'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removerItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
