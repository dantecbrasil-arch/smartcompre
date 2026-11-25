import 'package:flutter_test/flutter_test.dart';
import 'package:smartcompre/core/utils/categoria_normalizer.dart';

void main() {
  group('normalizarCategoria', () {
    test('converte texto totalmente maiúsculo', () {
      expect(normalizarCategoria('FRALDA'), 'Fralda');
    });

    test('mantém texto totalmente minúsculo no formato padrão', () {
      expect(normalizarCategoria('fralda'), 'Fralda');
    });

    test('normaliza letras alternadas', () {
      expect(normalizarCategoria('fRaLdA'), 'Fralda');
    });

    test('preserva acentos e deixa as letras seguintes minúsculas', () {
      expect(normalizarCategoria('LEITE EM PÓ'), 'Leite em pó');
      expect(normalizarCategoria('AÇÚCAR'), 'Açúcar');
    });

    test('remove espaços no início e no final', () {
      expect(normalizarCategoria('  FRALDA  '), 'Fralda');
    });

    test('substitui espaços duplicados por um espaço', () {
      expect(
        normalizarCategoria(' leite   em   pó '),
        'Leite em pó',
      );
    });

    test('retorna string vazia para entrada vazia', () {
      expect(normalizarCategoria(''), '');
    });

    test('preserva caracteres Unicode fora do plano multilíngue básico', () {
      expect(normalizarCategoria('😀  AÇÚCAR'), '😀 Açúcar');
    });
  });
}
