class ItemCompra {
  final String produto;
  final String categoria;
  final String? moeda;
  final double? peso;
  final double? precoKg;
  final double? total;
  final int quantidade;

  ItemCompra({
    required this.produto,
    required this.categoria,
    this.peso,
    this.precoKg,
    this.total,
    this.moeda,
    this.quantidade = 1,
  });
}