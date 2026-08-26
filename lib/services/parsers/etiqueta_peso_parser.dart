import '../../models/etiqueta_produto.dart';

class EtiquetaPesoParser {

  static EtiquetaProduto extrair(
    String texto,
  ) {

    String produto = '';
    String moeda = 'BRL';
    String peso = '';
    String precoKg = '';
    String total = '';

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
  
  }

    
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

  if (
      l.isNotEmpty &&
      !l.contains('DATA') &&
      !l.contains('PESO') &&
      !l.contains('PES0') &&
      !l.contains('PRECO') &&
      !l.contains('PREÇO') &&
      !l.contains('TOTAL') &&
      !RegExp(r'^\d').hasMatch(l)
  ) {
    produtos.add(l);
  }
  if (
    l.toUpperCase().contains('(L)') ||
    RegExp(
      r'\d+[.,]\d+.*k',
      caseSensitive: false,
    ).hasMatch(
      l.replaceAll(' ', ''),
    )
) {

  final match =
      RegExp(r'(\d+[.,]\d+)')
          .firstMatch(l);

  if (match != null) {

    print(
      'PESO ENCONTRADO => ${match.group(1)}',
    );

  final valor =
      double.tryParse(
        match.group(1)!
            .replaceAll(',', '.'),
      ) ?? 0;

  if (valor > 0.05) {
    pesos.add(match.group(1)!);
  }
}
}
final matchNumero =
    RegExp(r'(\d+[,. ]\d+)')
        .firstMatch(l);

if (matchNumero != null) {

  numeros.add(
  matchNumero.group(1)!
      .replaceAll(' ', '.'),
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

if (pesos.isNotEmpty) {

  final match =
      RegExp(r'(\d+[.,]\d+)')
          .firstMatch(
            pesos.first,
          );

  if (match != null) {
    peso = match.group(1)!;
  }
}

final numerosSemPeso =
    List<String>.from(numeros);


if (peso.isNotEmpty) {

  numerosSemPeso.removeWhere(
    (n) => n == peso,
  );

}

if (numerosSemPeso.isNotEmpty) {

  final primeiro =
      double.tryParse(
        numerosSemPeso.first
            .replaceAll(',', '.'),
      ) ?? 0;

  if (primeiro < 1) {
    numerosSemPeso.removeAt(0);
  }
}



if (numerosSemPeso.isNotEmpty) {
  precoKg = numerosSemPeso[0];
}

if (numerosSemPeso.length > 1) {
  total = numerosSemPeso[1];
}

    return EtiquetaProduto(
      produto: produto,
      moeda: moeda,
      peso: peso.isNotEmpty
          ? double.tryParse(
              peso.replaceAll(',', '.'),
            )
          : null,
      precoKg: precoKg.isNotEmpty
          ? double.tryParse(
              precoKg.replaceAll(',', '.'),
            )
          : null,
      total: total.isNotEmpty
          ? double.tryParse(
              total.replaceAll(',', '.'),
            )
          : null,
    );
  }
}