class ItemCompra {
  final String produto;
  final String categoria;
  final double? precoKg;
  final double? total;

  ItemCompra({
    required this.produto,
    required this.categoria,
    this.precoKg,
    this.total,
  });
}