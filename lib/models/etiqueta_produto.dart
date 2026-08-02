class EtiquetaProduto {
  final String produto;
  final double? precoKg;
  final double? total;

  EtiquetaProduto({
    required this.produto,
    this.precoKg,
    this.total,
  });

  @override
  String toString() {
    return '''
Produto: $produto
Preço/Kg: $precoKg
Total: $total
''';
  }
}