class ProdutoCatalogo {
  final String nome;
  final String categoria;
  final String tipoEstabelecimento;

  ProdutoCatalogo({
    required this.nome,
    required this.categoria,
    required this.tipoEstabelecimento,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'categoria': categoria,
      'tipoEstabelecimento':
          tipoEstabelecimento,
    };
  }

  factory ProdutoCatalogo.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProdutoCatalogo(
      nome: map['nome'] ?? '',
      categoria: map['categoria'] ?? '',

      // Compatibilidade com catálogo antigo
      tipoEstabelecimento:
          map['tipoEstabelecimento'] ??
          'Mercado',
    );
  }
}
