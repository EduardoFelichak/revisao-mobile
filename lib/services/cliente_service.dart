import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:revisao_mobile/models/cliente.dart';

class ClienteService {
  dynamic _response;
  String url = "http://localhost:8080/clientes";

  ClienteService(){
    _response = "";
  }

  Future<dynamic> salvarCliente(Cliente cliente) async{
    try {
      _response = await http.post(Uri.parse(url),
        body: json.encode(cliente.toJson()),
          headers: {
            "Accept"       : "application/json",
            "content-type" : "application/json"
          }
      );

      if (_response.statusCode == 200 || _response.statusCode == 201) {
        return Cliente.fromJson(json.decode(_response.body));
      } else {
        final decodedBody = utf8.decode(_response.bodyBytes);

        String errorMessage = 'Erro ao salvar o Cliente';
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

  Future<List<Cliente>> listarClientes() async{
    try {
      _response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept"       : "application/json",
          "content-type" : "application/json"
        },
      );

      if (_response.statusCode == 200 || _response.statusCode == 201) {
        List<dynamic> jsonListClientes = json.decode(utf8.decode(_response.bodyBytes));
        return jsonListClientes.map((item) => Cliente.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch(e) {
      return [];
    }
  }

  Future<dynamic> atualizarCliente(Cliente cliente) async {
    if (cliente.id == null) {
      throw ArgumentError("Cliente ID não pode ser nulo ou vazio para atualização.");
    }
    try {
      _response = await http.put(
          Uri.parse(url),
          body: json.encode(cliente.toJson()),
          headers: {
            "Accept"       : "application/json",
            "content-type" : "application/json"
          }
      );

      if (_response.statusCode == 200 || _response.statusCode == 201) {
        return Cliente.fromJson(json.decode(_response.body));
      } else {
        final decodedBody = utf8.decode(_response.bodyBytes);

        String errorMessage = 'Erro ao atualizar o Cliente';
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

  Future<bool> deletarCliente(String id) async {
    if (id.isEmpty) {
      throw ArgumentError("ID do Cliente não pode ser vazio para deleção.");
    }

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
  }
}