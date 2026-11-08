/// Modelos de dados da PoC "O Melhor Preço".
class Supermercado {
  final String id;
  final String nome;
  final String bairro;

  /// Distância aproximada (km) até o usuário. Na PoC é um valor fixo por
  /// estabelecimento; na versão final virá de GPS/CEP.
  final double distanciaKm;

  const Supermercado({
    required this.id,
    required this.nome,
    required this.bairro,
    required this.distanciaKm,
  });

  factory Supermercado.fromMap(String id, Map<String, dynamic> m) => Supermercado(
        id: id,
        nome: m['nome'] as String,
        bairro: m['bairro'] as String,
        distanciaKm: (m['distanciaKm'] as num).toDouble(),
      );

  Map<String, dynamic> toMap() =>
      {'nome': nome, 'bairro': bairro, 'distanciaKm': distanciaKm};
}

class Produto {
  final String id;
  final String nome;
  final String categoria;

  const Produto({required this.id, required this.nome, required this.categoria});

  factory Produto.fromMap(String id, Map<String, dynamic> m) => Produto(
        id: id,
        nome: m['nome'] as String,
        categoria: m['categoria'] as String,
      );

  Map<String, dynamic> toMap() => {'nome': nome, 'categoria': categoria};
}

class Preco {
  final String produtoId;
  final String supermercadoId;
  final double valor;
  final bool promocao;

  const Preco({
    required this.produtoId,
    required this.supermercadoId,
    required this.valor,
    this.promocao = false,
  });

  factory Preco.fromMap(Map<String, dynamic> m) => Preco(
        produtoId: m['produtoId'] as String,
        supermercadoId: m['supermercadoId'] as String,
        valor: (m['valor'] as num).toDouble(),
        promocao: (m['promocao'] as bool?) ?? false,
      );

  Map<String, dynamic> toMap() => {
        'produtoId': produtoId,
        'supermercadoId': supermercadoId,
        'valor': valor,
        'promocao': promocao,
      };
}

/// Linha da comparação: um supermercado com o preço do produto pesquisado.
class ResultadoComparacao {
  final Supermercado supermercado;
  final Preco preco;
  const ResultadoComparacao(this.supermercado, this.preco);
}
