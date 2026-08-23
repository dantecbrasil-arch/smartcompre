import 'opcao_preco.dart';

class EtiquetaProduto {
  final String produto;
  final String? moeda;
  final double? peso;
  final double? precoKg;
  final double? total;

  final List<OpcaoPreco> opcoesPreco;

  EtiquetaProduto({
    required this.produto,
    this.peso,
    this.precoKg,
    this.total,
    this.moeda,
    this.opcoesPreco = const [],
  });

  bool get temMultiplosPrecos =>
      opcoesPreco.length > 1;

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
