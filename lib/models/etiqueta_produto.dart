class EtiquetaProduto {
  final String produto;
  final String? moeda;
  final double? peso;
  final double? precoKg;
  final double? total;

  EtiquetaProduto({
    required this.produto,
    this.peso,
    this.precoKg,
    this.total,
    this.moeda,
  });

  @override
  String toString() {
    return '''
Produto: $produto
Moeda: $moeda
Preço/Kg: $precoKg
Total: $total
''';
  }
}