class Pedido {
  String? id;
  final String descricao;
  final String status;
  double valor;
  String clienteId;

  Pedido({
    this.id,
    required this.descricao,
    required this.status,
    required this.valor,
    required this.clienteId,
  });

  Pedido.fromJson(Map<String, dynamic> json) :
        id        = json['id'] ?? "",
        descricao = json['descricao'],
        status    = json['status'],
        valor     = json['valor'],
        clienteId = json['clienteId'] ?? "";

  Map<String, dynamic> toJson() => {
    'id'        : id,
    'descricao' : descricao,
    'status'    : status,
    'valor'     : valor,
    'clienteId' : clienteId,
  };
}