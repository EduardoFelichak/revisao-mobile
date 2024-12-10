import 'package:get/get.dart';
import '../models/pedido.dart';
import '../services/pedido_service.dart';

class PedidoController extends GetxController {
  PedidoService _pedidoService = PedidoService();

  var isLoading = false.obs;
  var pedidos = <Pedido>[].obs;
  static PedidoController get pedidoController => Get.find();

  Future<dynamic> salvar(Pedido pedido) async {
    isLoading.value = true;
    var resposta = await _pedidoService.salvarPedido(pedido);
    isLoading.value = false;
    update();
    return resposta;
  }

  Future<void> listarPedidos() async {
    isLoading.value = true;
    try {
      var lista = await _pedidoService.listarPedidos();
      if (lista != null) {
        pedidos.assignAll(lista);
      } else {
        pedidos.clear();
      }
    } catch (e) {
      pedidos.clear();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<dynamic> atualizar(Pedido pedido) async {
    isLoading.value = true;
    var resposta = await _pedidoService.atualizarPedido(pedido);
    isLoading.value = false;
    update();
    return resposta;
  }

  Future<bool> deletar(String id) async {
    isLoading.value = true;
    var sucesso = await _pedidoService.deletarPedido(id);
    isLoading.value = false;
    update();
    return sucesso;
  }
}
