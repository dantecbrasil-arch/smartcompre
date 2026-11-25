import 'package:flutter_test/flutter_test.dart';
import 'package:smartcompre/core/utils/nome_produto_manual_normalizer.dart';

void main() {
  group('normalizarNomeProdutoManual', () {
    test('converte cada palavra para formato de título', () {
      expect(normalizarNomeProdutoManual('ARROZ TIO JOÃO'), 'Arroz Tio João');
      expect(normalizarNomeProdutoManual('leite integral'), 'Leite Integral');
      expect(normalizarNomeProdutoManual('CAFÉ PILÃO'), 'Café Pilão');
      expect(normalizarNomeProdutoManual('óleo de soja'), 'Óleo De Soja');
    });

    test('remove espaços redundantes sem perder acentos', () {
      expect(normalizarNomeProdutoManual('  CAFÉ   EM\tPÓ  '), 'Café Em Pó');
    });

    test('retorna vazio para entrada sem conteúdo', () {
      expect(normalizarNomeProdutoManual(' \t '), '');
    });
  });
}
