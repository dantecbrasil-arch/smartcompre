import '../models/etiqueta_produto.dart';

class EtiquetaParser {
  static EtiquetaProduto extrair(String texto) {
    String produto = '';
    String precoKg = '';
    String total = '';
    String moeda = 'BRL';
    String peso = '';

    final linhas = texto.split('\n');

    final numeros = <String>[];
    final pesos = <String>[];
    final produtos = <String>[]; 

    for (final linha in linhas) {
      final l = linha.trim();

      if (
          l.contains(r'R$') ||
          l.contains('RS') ||
          l.contains('R5')
      ) {

       moeda = 'BRL';
      } else if (l.contains('€')) {
       moeda = 'EUR';
      } else if (l.contains('\$')) {
       moeda = 'USD';
      }

      if (l.isNotEmpty &&
          !l.contains('DATA') &&
          !l.contains('PESO') &&
          !l.contains('PES0') &&
          !l.contains('PRECO') &&
          !l.contains('PREÇO') &&
          !l.contains('TOTAL') &&
          !RegExp(r'\d{2}/\d{2}/\d{2}').hasMatch(l)) {

        produtos.add(l);
}

      if (
          l.contains('(L)') ||
          l.contains('ka (L)') ||
          l.contains('kg (L)') ||
          l.contains('ks (L)')
      ) {
        pesos.add(l);
      }


      if (RegExp(r'^\d+[,\.]\d+$').hasMatch(l)) {
        numeros.add(l);
      }
    }

    
    if (produtos.isNotEmpty) {

      produtos.sort(
        (a, b) => b.length.compareTo(a.length),
      );

      produto = produtos.first;

      print('PRODUTO ESCOLHIDO: $produto');
    }

    if (pesos.isNotEmpty) {

      final match =
          RegExp(r'(\d+[.,]\d+)')
              .firstMatch(pesos.first);

      if (match != null) {
        peso = match.group(1)!;
      }

      print('PESO BRUTO: $peso');
    }

    print('PESO ENCONTRADO: $peso');
    print(
    'PESO DOUBLE: ${double.tryParse(peso.replaceAll(",", "."))}',
  );
    if (numeros.isNotEmpty) {
      precoKg = numeros[0];
    }

    if (numeros.length > 1) {
      total = numeros[1];
    }

    return EtiquetaProduto(
      produto: produto,
      moeda: moeda,
      peso: peso.isNotEmpty ? double.tryParse(peso.replaceAll(',', '.')) : null,
      precoKg: precoKg.isNotEmpty
          ? double.tryParse(precoKg.replaceAll(',', '.'))
          : null,
      total: total.isNotEmpty
          ? double.tryParse(total.replaceAll(',', '.'))
          : null,
    );
  }
}