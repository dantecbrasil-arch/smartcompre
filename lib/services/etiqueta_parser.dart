import '../models/etiqueta_produto.dart';

class EtiquetaParser {
  static EtiquetaProduto extrair(String texto) {
    String produto = '';
    String precoKg = '';
    String total = '';

    final linhas = texto.split('\n');

    final numeros = <String>[];

    for (final linha in linhas) {
      final l = linha.trim();

      if (produto.isEmpty &&
          l.isNotEmpty &&
          !l.contains('DATA') &&
          !l.contains('PESO') &&
          !l.contains('PRECO') &&
          !l.contains('TOTAL') &&
          !RegExp(r'\d{2}/\d{2}/\d{2}').hasMatch(l)) {
        produto = l;
      }

      if (RegExp(r'^\d+[,\.]\d+$').hasMatch(l)) {
        numeros.add(l);
      }
    }

    if (numeros.isNotEmpty) {
      precoKg = numeros[0];
    }

    if (numeros.length > 1) {
      total = numeros[1];
    }

    return EtiquetaProduto(
      produto: produto,
      precoKg: precoKg.isNotEmpty
          ? double.tryParse(precoKg.replaceAll(',', '.'))
          : null,
      total: total.isNotEmpty
          ? double.tryParse(total.replaceAll(',', '.'))
          : null,
    );
  }
}