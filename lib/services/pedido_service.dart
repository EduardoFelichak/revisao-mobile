import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pedido.dart';

class PedidoService {
  dynamic _response;
  String url = "http://localhost:8080/pedidos";
  String urlClientes = "http://localhost:8080/clientes";

  PedidoService(){
    _response = "";
  }

  Future<dynamic> salvarPedido(Pedido pedido) async{
    try {
      _response = await http.post(Uri.parse(url),
          body: json.encode(pedido.toJson()),
          headers: {
            "Accept"       : "application/json",
            "content-type" : "application/json"
          }
      );

      if (_response.statusCode == 200 || _response.statusCode == 201) {
        return Pedido.fromJson(json.decode(_response.body));
      } else {
        final decodedBody = utf8.decode(_response.bodyBytes);

        String errorMessage = 'Erro ao salvar o Pedido';
        try{
          final errorJson = json.decode(decodedBody);
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          } else if (errorJson['error'] != null) {
            errorMessage = errorJson['error'];
          }
        } catch (e) {
          errorMessage = decodedBody;
        }

        return errorMessage;
      }
    } catch(e) {
      return 'Erro de conexão: ${e.toString()}';
    }
  }

  Future<List<Pedido>> listarPedidos() async {
    try {
      _response = await http.get(
        Uri.parse(urlClientes),
        headers: {
          "Accept"       : "application/json",
          "content-type" : "application/json"
        },
      );

      if (_response.statusCode == 200 || _response.statusCode == 201) {
        List<dynamic> jsonListClientes = json.decode(utf8.decode(_response.bodyBytes));
        List<Pedido> pedidos = [];
        for (var cliente in jsonListClientes) {
          if (cliente['pedidos'] != null) {
            for (var pedidoJson in cliente['pedidos']) {
              Pedido pedido = Pedido.fromJson(pedidoJson);
              pedido.clienteId = cliente['id'] ?? "";
              pedidos.add(pedido);
            }
          }
        }
        return pedidos;
      } else {
        return [];
      }
    } catch(e) {
      return [];
    }
  }

  Future<dynamic> atualizarPedido(Pedido pedido) async {
    if (pedido.id == null) {
      throw ArgumentError("Pedido ID não pode ser nulo ou vazio para atualização.");
    }
    try {
      _response = await http.put(
          Uri.parse(url),
          body: json.encode(pedido.toJson()),
          headers: {
            "Accept"       : "application/json",
            "content-type" : "application/json"
          }
      );

      if (_response.statusCode == 200 || _response.statusCode == 201) {
        return Pedido.fromJson(json.decode(_response.body));
      } else {
        final decodedBody = utf8.decode(_response.bodyBytes);

        String errorMessage = 'Erro ao atualizar o Pedido';
        try{
          final errorJson = json.decode(decodedBody);
          if (errorJson['message'] != null) {
            errorMessage = errorJson['message'];
          } else if (errorJson['error'] != null) {
            errorMessage = errorJson['error'];
          }
        } catch (e) {
          errorMessage = decodedBody;
        }

        return errorMessage;
      }
    } catch(e) {
      return 'Erro de conexão: ${e.toString()}';
    }
  }

  Future<bool> deletarPedido(String id) async {
    if (id.isEmpty) {
      throw ArgumentError("ID do Pedido não pode ser vazio para deleção.");
    }

    try {
      _response = await http.delete(
          Uri.parse("$url/$id"),
          headers: {
            "Accept"       : "application/json",
            "content-type" : "application/json"
          }
      );

      if (_response.statusCode == 200 || _response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch(e) {
      return false;
    }
  }
}
