import 'package:get/get.dart';
import 'package:revisao_mobile/controllers/cliente_controller.dart';
import 'package:revisao_mobile/controllers/pedido_controller.dart';

class ControllerBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ClienteController>(() => ClienteController());
    Get.lazyPut<PedidoController> (() => PedidoController());
  }
}