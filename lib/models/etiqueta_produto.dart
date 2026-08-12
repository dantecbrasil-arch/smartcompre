class EtiquetaProduto {
  final String produto;
  final double? peso;
  final double? precoKg;
  final double? total;

  EtiquetaProduto({
    required this.produto,
    this.peso,
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