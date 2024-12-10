import 'package:flutter/material.dart';
import 'package:revisao_mobile/screens/cliente/cliente_screen.dart';
import 'package:revisao_mobile/screens/home_screen.dart';
import 'package:revisao_mobile/screens/cliente/list_cliente_screen.dart';
import 'package:revisao_mobile/screens/pedido/list_pedido_screen.dart';
import 'package:revisao_mobile/screens/pedido/pedido_screen.dart';
import 'package:revisao_mobile/services/pedido_service.dart';

class MenuComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Text(
              'Revisão Sistemas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.people),
            title: Text('Clientes'),
            children: [
              ListTile(
                title: Text('Cadastrar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClienteScreen()),
                  );
                },
              ),
              ListTile(
                title: Text('Listar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListaClienteScreen()),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.shopping_basket_rounded),
            title: Text('Pedidos'),
            children: [
              ListTile(
                title: Text('Cadastrar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PedidoScreen()),
                  );
                },
              ),
              ListTile(
                title: Text('Listar'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListaPedidoScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
