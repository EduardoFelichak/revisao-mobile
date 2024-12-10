class Cliente{
  String? id;
  final String nome;
  final String cpf;
  final String telefone;
  String? endereco;
  var pedidos = [];

  Cliente({
    this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
    this.endereco,
    required this.pedidos,
  });

  Cliente.fromJson(Map<String, dynamic > json) :
        id       = json['id'] ?? "",
        nome     = json['nome'    ],
        cpf      = json['cpf'     ],
        telefone = json['telefone'],
        endereco = json['endereco'] ?? "",
        pedidos  = json['pedidos' ] ?? [];

  Map<String, dynamic>toJson() => {
    'id'       : id,
    'nome'     : nome,
    'cpf'      : cpf,
    'telefone' : telefone,
    'endereco' : endereco,
    'pedidos'  : pedidos,
  };
}