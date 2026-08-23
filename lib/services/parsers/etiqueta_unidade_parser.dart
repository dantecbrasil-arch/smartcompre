import '../../models/etiqueta_produto.dart';

class EtiquetaUnidadeParser {
  static EtiquetaProduto extrair(
    String texto,
  ) {
    String produto = '';
    String moeda = 'BRL';
    String total = '';

    final linhas = texto.split('\n');

    final numeros = <String>[];
    final produtos = <String>[];

    for (final linha in linhas) {
      final l = linha.trim();

      if (
          l.contains(r'R$') ||
          l.contains('RS') ||
          l.contains('R5')) {
        moeda = 'BRL';
      } else if (l.contains('€')) {
        moeda = 'EUR';
      } else if (l.contains(r'$')) {
        moeda = 'USD';
      }

      if (
          l.isNotEmpty &&
          !RegExp(r'^\d').hasMatch(l)) {
        produtos.add(l);
      }

      final matchNumero =
          RegExp(r'(\d+[,.]\d+)')
              .firstMatch(l);

      if (matchNumero != null) {
        numeros.add(
          matchNumero.group(1)!,
        );
      }
    }

    if (produtos.isNotEmpty) {
      produtos.sort(
        (a, b) =>
            b.length.compareTo(a.length),
      );

      produto = produtos.first;
    }

    if (numeros.isNotEmpty) {
      total = numeros.first;
    }

    return EtiquetaProduto(
      produto: produto,
      moeda: moeda,
      peso: null,
      precoKg: null,
      total: total.isNotEmpty
          ? double.tryParse(
              total.replaceAll(',', '.'),
            )
          : null,
    );
  }
}