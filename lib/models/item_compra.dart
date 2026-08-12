class ItemCompra {
  final String produto;
  final String categoria;
  final double? peso;
  final double? precoKg;
  final double? total;

  ItemCompra({
    required this.produto,
    required this.categoria,
    this.peso,
    this.precoKg,
    this.total,
  });
}