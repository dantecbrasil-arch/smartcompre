import '../models/etiqueta_produto.dart';
import 'parsers/classificacao_etiqueta.dart';

class EtiquetaParser {
  static EtiquetaProduto extrair(String texto) {
    String produto = '';
    String precoKg = '';
    String total = '';
    String moeda = 'BRL';
    String peso = '';

    final tipo =
    ClassificacaoEtiqueta
        .identificar(texto);

    print(
      'TIPO IDENTIFICADO: $tipo',
    );


    final textoUpper = texto.toUpperCase();

final ehEtiquetaPeso =
    textoUpper.contains('PESO') ||
    textoUpper.contains('PES0') ||
    textoUpper.contains('TARA') ||
    textoUpper.contains('TOTAL');

    print(
  'TIPO ETIQUETA: '
  '${ehEtiquetaPeso ? "PESO" : "UNIDADE"}',
);

    final linhas = texto.split('\n');

    final numeros = <String>[];
    final precosUnidade = <String>[];
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
          !l.toUpperCase().contains('UNIDADE') &&
          !l.toUpperCase().contains('VAREJO') &&
          !l.toUpperCase().contains('ATACADO') &&
          !l.toUpperCase().contains('A PARTIR') &&
          !l.startsWith('*') &&
          !RegExp(r'\d{2}/\d{2}/\d{2}').hasMatch(l) && 
          !RegExp(r'^\d').hasMatch(l) &&
          !RegExp(r'\d{6,}').hasMatch(l)
      ) { 
        produtos.add(l);
}

      if (
    RegExp(
      r'^\d+[.,]\d+(kg|ks|ka)$',
      caseSensitive: false,
    ).hasMatch(
      l.replaceAll(' ', ''),
    )
) {
  pesos.add(
    l.replaceAll(' ', ''),
  );
}

      final matchNumero =
    RegExp(r'(\d+[,.]\d+)')
        .firstMatch(l);

if (matchNumero != null) {

  final valor =
      matchNumero.group(1)!;

  numeros.add(valor);

  if (!ehEtiquetaPeso) {
    precosUnidade.add(valor);
  }
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
    if (ehEtiquetaPeso) {

  final numerosSemPeso =
      List<String>.from(numeros);

  if (peso.isNotEmpty &&
      numerosSemPeso.isNotEmpty &&
      numerosSemPeso.first == peso) {
    numerosSemPeso.removeAt(0);
  }

  if (numerosSemPeso.isNotEmpty) {
    precoKg = numerosSemPeso[0];
  }

  if (numerosSemPeso.length > 1) {
    total = numerosSemPeso[1];
  }

} else {

  if (numeros.isNotEmpty) {
    total = numeros.first;
  }
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