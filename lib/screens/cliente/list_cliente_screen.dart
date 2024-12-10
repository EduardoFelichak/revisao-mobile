import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:revisao_mobile/components/menu_component.dart';
import 'package:revisao_mobile/controllers/cliente_controller.dart';
import 'package:revisao_mobile/models/cliente.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ListaClienteScreen extends StatefulWidget {
  @override
  State<ListaClienteScreen> createState() => _ListaClienteScreenState();
}

class _ListaClienteScreenState extends State<ListaClienteScreen> {
  var controllerCliente = ClienteController.clienteController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerCliente.listarClientes();
    });
  }

  void _showUpdateDialog(Cliente cliente) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nomeController =
    TextEditingController(text: cliente.nome);
    final TextEditingController _cpfController =
    TextEditingController(text: cliente.cpf);
    final TextEditingController _telefoneController =
    TextEditingController(text: cliente.telefone);
    final TextEditingController _enderecoController =
    TextEditingController(text: cliente.endereco ?? '');

    final maskCPF = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.eager,
    );

    final maskTelefone = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.eager,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Atualizar Cliente"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                      labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error),
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
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _cpfController,
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      border: OutlineInputBorder(),
                      labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskCPF],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o CPF do Cliente';
                      }
                      if (value.length < 14) {
                        return 'CPF inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _telefoneController,
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                      labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [maskTelefone],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o telefone do Cliente';
                      }
                      if (value.length < 15) {
                        return 'Telefone inválido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _enderecoController,
                    decoration: InputDecoration(
                      labelText: 'Endereço',
                      border: OutlineInputBorder(),
                      labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.error),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                    keyboardType: TextInputType.text,
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
                  final clienteAtualizado = Cliente(
                    id: cliente.id,
                    nome: _nomeController.text,
                    cpf: _cpfController.text,
                    telefone: _telefoneController.text,
                    endereco: _enderecoController.text,
                    pedidos: cliente.pedidos,
                  );
                  var response =
                  await controllerCliente.atualizar(clienteAtualizado);
                  if (response is Cliente) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check, color: Colors.white),
                            SizedBox(width: 8),
                            Expanded(child: Text("Cliente atualizado com sucesso")),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        margin: EdgeInsets.all(10),
                      ),
                    );
                    controllerCliente.listarClientes();
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
          title: Text("Deletar Cliente"),
          content: Text("Tem certeza que deseja deletar este cliente? \nTodos os pedidos relacionados a ele serão excluídos também!"),
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
                var sucesso = await controllerCliente.deletar(id);
                if (sucesso) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(child: Text("Cliente deletado com sucesso")),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.all(10),
                    ),
                  );
                  controllerCliente.listarClientes();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.error, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(child: Text("Erro ao deletar o Cliente")),
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
          'Lista de Clientes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      drawer: MenuComponent(),
      body: Obx(() {
        if (controllerCliente.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controllerCliente.clientes.isEmpty) {
          return Center(
            child: Text(
              "Nenhum cliente registrado.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controllerCliente.clientes.length,
            itemBuilder: (context, index) {
              final cliente = controllerCliente.clientes[index];
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              cliente.nome,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            cliente.cpf,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        cliente.telefone,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      cliente.endereco != null && cliente.endereco!.isNotEmpty
                          ? Text(
                        cliente.endereco!,
                        style: TextStyle(fontSize: 16),
                      )
                          : SizedBox.shrink(),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showUpdateDialog(cliente);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(cliente.id!);
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
