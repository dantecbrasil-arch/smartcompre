class ProdutoCatalogo {
  final String nome;
  final String categoria;

  ProdutoCatalogo({
    required this.nome,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'categoria': categoria,
    };
  }

  factory ProdutoCatalogo.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProdutoCatalogo(
      nome: map['nome'] ?? '',
      categoria: map['categoria'] ?? '',
    );
  }
}
