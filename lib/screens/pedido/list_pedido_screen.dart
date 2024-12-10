import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:revisao_mobile/components/menu_component.dart';
import 'package:revisao_mobile/controllers/cliente_controller.dart';
import 'package:revisao_mobile/controllers/pedido_controller.dart';
import 'package:revisao_mobile/models/cliente.dart';
import 'package:revisao_mobile/models/pedido.dart';

class ListaPedidoScreen extends StatefulWidget {
  @override
  State<ListaPedidoScreen> createState() => _ListaPedidoScreenState();
}

class _ListaPedidoScreenState extends State<ListaPedidoScreen> {
  var controllerPedido = PedidoController.pedidoController;
  var controllerCliente = ClienteController.clienteController;

  final Map<String, String> statusOptions = {
    'PROCESSAMENTO': 'Em Processamento 🕕',
    'ENVIADO': 'Enviado 🚛',
    'ENTREGUE': 'Entregue 🎉',
    'CANCELADO': 'Cancelado ☹️',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerCliente.listarClientes();
      controllerPedido.listarPedidos();
    });
  }

  void _showUpdateDialog(Pedido pedido) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _descricaoController =
    TextEditingController(text: pedido.descricao);
    final TextEditingController _valorController = TextEditingController(
        text: 'R\$ ${pedido.valor.toStringAsFixed(2).replaceAll('.', ',')}');
    String? _statusSelecionado = pedido.status;
    Cliente? _clienteSelecionado;

    try {
      _clienteSelecionado =
          controllerCliente.clientes.firstWhere((c) => c.id == pedido.clienteId);
    } catch (e) {
      _clienteSelecionado = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Atualizar Pedido"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Campo Descrição
                  TextFormField(
                    controller: _descricaoController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a descrição do Pedido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Campo Status
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Status',
                      labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                    value: _statusSelecionado,
                    isExpanded: true,
                    onChanged: (String? novoStatus) {
                      setState(() {
                        _statusSelecionado = novoStatus;
                      });
                    },
                    items: statusOptions.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione o status do Pedido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Campo Valor
                  TextFormField(
                    controller: _valorController,
                    decoration: InputDecoration(
                      labelText: 'Valor',
                      labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      MoneyInputFormatter(
                        leadingSymbol: 'R\$ ',
                        mantissaLength: 2,
                        thousandSeparator: ThousandSeparator.Period,
                        trailingSymbol: '',
                        useSymbolPadding: true,
                      )
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o valor do Pedido';
                      }
                      String unmasked = value
                          .replaceAll('R\$ ', '')
                          .replaceAll('.', '')
                          .replaceAll(',', '.');
                      if (double.tryParse(unmasked) == null) {
                        return 'Valor inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Campo Cliente
                  DropdownButtonFormField<Cliente>(
                    decoration: InputDecoration(
                      labelText: 'Cliente',
                      labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                    value: _clienteSelecionado,
                    isExpanded: true,
                    onChanged: (Cliente? novoCliente) {
                      setState(() {
                        _clienteSelecionado = novoCliente;
                      });
                    },
                    items: controllerCliente.clientes.map((Cliente cliente) {
                      return DropdownMenuItem<Cliente>(
                        value: cliente,
                        child: Text(cliente.nome),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor, selecione um cliente';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String unmaskedValor = _valorController.text
                      .replaceAll('R\$ ', '')
                      .replaceAll('.', '')
                      .replaceAll(',', '.');
                  double valor = double.parse(unmaskedValor);

                  final pedidoAtualizado = Pedido(
                    id: pedido.id,
                    descricao: _descricaoController.text,
                    status: _statusSelecionado!,
                    valor: valor,
                    clienteId: _clienteSelecionado!.id ?? "",
                  );

                  var response = await controllerPedido.atualizar(pedidoAtualizado);

                  if (response is Pedido) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(child: Text("Pedido atualizado com sucesso")),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        margin: EdgeInsets.all(10),
                      ),
                    );
                    controllerPedido.listarPedidos();
                    Navigator.of(context).pop();
                  } else if (response is String) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(child: Text(response)),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                        margin: EdgeInsets.all(10),
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(child: Text("Ocorreu um erro inesperado.")),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        margin: EdgeInsets.all(10),
                      ),
                    );
                  }
                }
              },
              child: Text(
                "Salvar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Deletar Pedido"),
          content: Text("Tem certeza que deseja deletar este pedido?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                var sucesso = await controllerPedido.deletar(id);
                if (sucesso) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(child: Text("Pedido deletado com sucesso")),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.all(10),
                    ),
                  );
                  controllerPedido.listarPedidos();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.error, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(child: Text("Erro ao deletar o Pedido")),
                        ],
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                      margin: EdgeInsets.all(10),
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(
                "Deletar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Pedidos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      drawer: MenuComponent(),
      body: Obx(() {
        if (controllerPedido.isLoading.value ||
            controllerCliente.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controllerPedido.pedidos.isEmpty) {
          return Center(
            child: Text(
              "Nenhum pedido registrado.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controllerPedido.pedidos.length,
            itemBuilder: (context, index) {
              final pedido = controllerPedido.pedidos[index];
              Cliente? cliente;
              try {
                cliente = controllerCliente.clientes
                    .firstWhere((c) => c.id == pedido.clienteId);
              } catch (e) {
                cliente = null;
              }
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Linha com Descrição e Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              pedido.descricao,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            statusOptions[pedido.status] ?? pedido.status,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Campo Valor
                      Text(
                        'Valor: R\$ ${pedido.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      cliente != null
                          ? Text(
                        'Cliente: ${cliente.nome}',
                        style: TextStyle(fontSize: 16),
                      )
                          : Text(
                        'Cliente: Não encontrado',
                        style:
                        TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      // Botões de Ação
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showUpdateDialog(pedido);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(pedido.id!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
