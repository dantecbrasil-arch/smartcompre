import '../../models/etiqueta_produto.dart';
import '../../models/opcao_preco.dart';

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
    final opcoesPreco = <OpcaoPreco>[];

    String? tipoPrecoAtual;

    for (final linha in linhas) {
      final l = linha.trim();

      final linhaUpper =
          l.toUpperCase();

      if (linhaUpper.contains('ATACAD')) {
       tipoPrecoAtual = 'ATACADO';
      }

      if (
       linhaUpper.contains('PASSAI') ||
       linhaUpper.contains('PAGSAI') ||
       linhaUpper.contains('PASGAI') ||
       linhaUpper.contains('PABSAI')
      ) {
     tipoPrecoAtual = 'PASSAI';
      }

      if (linhaUpper.contains('VAREJ')) {
       tipoPrecoAtual = 'VAREJO';
      }   

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

  final valorTexto =
      matchNumero.group(1)!;

  numeros.add(valorTexto);

  if (tipoPrecoAtual != null) {

    final valor =
        double.tryParse(
          valorTexto.replaceAll(',', '.'),
        );

    if (valor != null) {

      opcoesPreco.add(
        OpcaoPreco(
          descricao: tipoPrecoAtual!,
          valor: valor,
        ),
      );

      tipoPrecoAtual = null;
    }
  }
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
      opcoesPreco: opcoesPreco,
    );
  }
}