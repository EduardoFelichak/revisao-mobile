import 'package:get/get.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';

class ClienteController extends GetxController {

  ClienteService _clienteService = ClienteService();

  var isLoading = false.obs;
  var clientes = <Cliente>[].obs;
  static ClienteController get clienteController => Get.find();

  Future<dynamic> salvar(Cliente cliente) async {
    isLoading.value = true;
    var resposta = await _clienteService.salvarCliente(cliente);
    isLoading.value = false;
    update();
    return resposta;
  }

  Future<void> listarClientes() async {
    isLoading.value = true;
    try {
      var lista = await _clienteService.listarClientes();
      if (lista != null) {
        clientes.assignAll(lista);
      } else {
        clientes.clear();
      }
    } catch (e) {
      clientes.clear();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<dynamic> atualizar(Cliente cliente) async {
    isLoading.value = true;
    var resposta = await _clienteService.atualizarCliente(cliente);
    isLoading.value = false;
    update();
    return resposta;
  }

  Future<bool> deletar(String id) async {
    isLoading.value = true;
    var sucesso = await _clienteService.deletarCliente(id);
    isLoading.value = false;
    update();
    return sucesso;
  }
}
