import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:revisao_mobile/components/menu_component.dart';
import 'package:revisao_mobile/controllers/cliente_controller.dart';
import 'package:revisao_mobile/controllers/pedido_controller.dart';
import 'package:revisao_mobile/models/cliente.dart';
import 'package:revisao_mobile/models/pedido.dart';

class PedidoScreen extends StatefulWidget {
  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  var controllerPedido = PedidoController.pedidoController;
  var controllerCliente = ClienteController.clienteController;

  String? _statusSelecionado;
  Cliente? _clienteSelecionado;

  final Map<String, String> statusOptions = {
    'PROCESSAMENTO': 'Em Processamento',
    'ENVIADO': 'Enviado',
    'ENTREGUE': 'Entregue',
    'CANCELADO': 'Cancelado',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerCliente.listarClientes();
    });
  }

  void _clearFields() {
    _descricaoController.clear();
    _valorController.clear();
    setState(() {
      _statusSelecionado = null;
      _clienteSelecionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Pedido',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      drawer: MenuComponent(),
      body: Obx(() {
        if (controllerPedido.isLoading.value || controllerCliente.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _descricaoController,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
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
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Status',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                        value: _statusSelecionado,
                        hint: Text('Selecione o status'),
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
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _valorController,
                        decoration: InputDecoration(
                          labelText: 'Valor',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          MoneyInputFormatter(
                            leadingSymbol: 'R\$ ',
                            mantissaLength: 2,thousandSeparator: ThousandSeparator.Period,
                            trailingSymbol: '',
                            useSymbolPadding: true
                          )
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o valor do Pedido';
                          }
                          String unmasked = value.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.');
                          if (double.tryParse(unmasked) == null) {
                            return 'Valor inválido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<Cliente>(
                        decoration: InputDecoration(
                          labelText: 'Cliente',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                        value: _clienteSelecionado,
                        hint: Text('Selecione um cliente'),
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
                      SizedBox(height: 24.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            textStyle: TextStyle(fontSize: 16.0),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String unmaskedValor = _valorController.text
                                  .replaceAll('R\$ ', '')
                                  .replaceAll('.', '')
                                  .replaceAll(',', '.');

                              final pedido = Pedido(
                                descricao: _descricaoController.text,
                                status: _statusSelecionado!,
                                valor: double.parse(unmaskedValor),
                                clienteId: _clienteSelecionado!.id ?? "",
                              );

                              var response = await controllerPedido.salvar(pedido);

                              if (response is Pedido) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.check, color: Colors.white),
                                        SizedBox(width: 8),
                                        Expanded(child: Text("Pedido salvo com sucesso")),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                    margin: EdgeInsets.all(10),
                                  ),
                                );
                                _clearFields();
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
                            'Salvar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
