import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart'; // Import para máscara
import 'package:revisao_mobile/components/menu_component.dart';
import 'package:revisao_mobile/controllers/cliente_controller.dart';
import 'package:revisao_mobile/models/cliente.dart';

class ClienteScreen extends StatefulWidget {
  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();

  var controllerCliente = ClienteController.clienteController;

  final maskCPF      = MaskTextInputFormatter(mask: '###.###.###-##' , filter: {"#": RegExp(r'[0-9]')});
  final maskTelefone = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
  }

  void _clearFields() {
    _nomeController.clear();
    _cpfController.clear();
    _telefoneController.clear();
    _enderecoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.error,
        title: Text(
          "Cadastro de Clientes",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: MenuComponent(),
      body: Obx(() {
        if (controllerCliente.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
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
                      // Campo Nome
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome do Cliente';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _cpfController,
                        decoration: InputDecoration(
                          labelText: 'CPF',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [maskCPF],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o CPF do Cliente';
                          }
                          if (!maskCPF.isFill()) {
                            return 'CPF inválido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _telefoneController,
                        decoration: InputDecoration(
                          labelText: 'Telefone',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [maskTelefone],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o telefone do Cliente';
                          }
                          if (!maskTelefone.isFill()) {
                            return 'Telefone inválido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _enderecoController,
                        decoration: InputDecoration(
                          labelText: 'Endereço',
                          labelStyle: TextStyle(color: Theme.of(context).colorScheme.error),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 24.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(// Cor vermelha
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            textStyle: TextStyle(fontSize: 16.0),
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final cliente = Cliente(
                                nome: _nomeController.text,
                                cpf: _cpfController.text,
                                telefone: _telefoneController.text,
                                endereco: _enderecoController.text,
                                pedidos: [],
                              );

                              var response = await controllerCliente.salvar(cliente);

                              if (response is Cliente) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text("Cliente salvo com sucesso"),
                                        ),
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
                                // Erro
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.error,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(response),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 3),
                                    margin: EdgeInsets.all(10),
                                  ),
                                );
                              } else {
                                // Caso inesperado
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                              "Ocorreu um erro inesperado."),
                                        ),
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
                          child: Text('Salvar', style: TextStyle(color: Colors.white),),
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
