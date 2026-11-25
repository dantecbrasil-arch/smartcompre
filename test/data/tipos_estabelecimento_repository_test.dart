import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcompre/data/catalogo/categorias_por_tipo_repository.dart';
import 'package:smartcompre/data/listas_repository.dart';
import 'package:smartcompre/data/tipos_estabelecimento_repository.dart';

void main() {
  const tipoPersonalizado = 'Mercado do Bairro';

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ListasRepository.listasSalvas = [];
  });

  test('cria tipos personalizados e impede nomes equivalentes', () async {
    await TiposEstabelecimentoRepository.adicionarTipo('  Loja   de Bairro  ');

    final tipos = await TiposEstabelecimentoRepository.carregarTodos();
    expect(tipos, contains('Loja de Bairro'));

    await expectLater(
      TiposEstabelecimentoRepository.adicionarTipo('loja de bairro'),
      throwsA(isA<TiposEstabelecimentoRepositoryException>()),
    );
  });

  test(
    'bloqueia exclusão e informa a quantidade de listas vinculadas',
    () async {
      SharedPreferences.setMockInitialValues({
        'tipos_estabelecimento_usuario': jsonEncode([tipoPersonalizado]),
        'listas_salvas': jsonEncode([
          {'id': 1, 'tipo': tipoPersonalizado},
          {'id': 2, 'tipo': tipoPersonalizado},
        ]),
      });

      await expectLater(
        TiposEstabelecimentoRepository.excluirTipo(tipoPersonalizado),
        throwsA(
          isA<TiposEstabelecimentoRepositoryException>().having(
            (error) => error.quantidadeListas,
            'quantidadeListas',
            2,
          ),
        ),
      );

      final tipos = await TiposEstabelecimentoRepository.carregarTodos();
      expect(tipos, contains(tipoPersonalizado));
    },
  );

  test(
    'permite excluir sem listas e reclassifica referências sem alterar categorias',
    () async {
      SharedPreferences.setMockInitialValues({
        'tipos_estabelecimento_usuario': jsonEncode([tipoPersonalizado]),
        'listas_salvas': jsonEncode([
          {'id': 2, 'tipo': 'Mercado'},
        ]),
        'estabelecimentos': jsonEncode([
          {
            'id': 'est-1',
            'nome': 'Mercado do Bairro',
            'endereco': 'Rua Um',
            'cidade': 'São Paulo',
            'tipo': tipoPersonalizado,
          },
        ]),
        'catalogo_produtos': jsonEncode([
          {
            'nome': 'Produto cadastrado',
            'categoria': 'Categoria personalizada',
            'tipoEstabelecimento': tipoPersonalizado,
          },
        ]),
        'categorias_por_tipo_usuario': jsonEncode({
          tipoPersonalizado: ['Categoria personalizada'],
        }),
      });

      await TiposEstabelecimentoRepository.excluirTipo(tipoPersonalizado);

      final prefs = await SharedPreferences.getInstance();
      final tipos = await TiposEstabelecimentoRepository.carregarTodos();
      final estabelecimentos =
          jsonDecode(prefs.getString('estabelecimentos')!) as List;
      final produtos =
          jsonDecode(prefs.getString('catalogo_produtos')!) as List;
      final categorias =
          jsonDecode(prefs.getString('categorias_por_tipo_usuario')!)
              as Map<String, dynamic>;

      expect(tipos, isNot(contains(tipoPersonalizado)));
      expect(estabelecimentos.single['tipo'], 'Outros');
      expect(estabelecimentos.single['nome'], 'Mercado do Bairro');
      expect(produtos.single['tipoEstabelecimento'], 'Outros');
      expect(produtos.single['categoria'], 'Categoria personalizada');
      expect(categorias[tipoPersonalizado], ['Categoria personalizada']);
    },
  );

  test(
    'recupera categorias preservadas ao cadastrar novamente o tipo excluído',
    () async {
      SharedPreferences.setMockInitialValues({
        'tipos_estabelecimento_usuario': jsonEncode([tipoPersonalizado]),
        'categorias_por_tipo_usuario': jsonEncode({
          tipoPersonalizado: ['Categoria personalizada'],
        }),
      });

      await TiposEstabelecimentoRepository.excluirTipo(tipoPersonalizado);
      await TiposEstabelecimentoRepository.adicionarTipo(tipoPersonalizado);

      final categorias = await CategoriasPorTipoRepository.obterCategorias(
        tipoPersonalizado,
      );

      expect(categorias, ['Categoria personalizada']);
    },
  );

  test(
    'carrega tipos personalizados persistidos em um novo contexto de armazenamento',
    () async {
      await TiposEstabelecimentoRepository.adicionarTipo(tipoPersonalizado);

      final prefs = await SharedPreferences.getInstance();
      final dadosPersistidos = prefs.getString(
        'tipos_estabelecimento_usuario',
      );
      expect(dadosPersistidos, isNotNull);

      SharedPreferences.setMockInitialValues({
        'tipos_estabelecimento_usuario': dadosPersistidos!,
      });

      final tipos = await TiposEstabelecimentoRepository.carregarTodos();

      expect(tipos, contains(tipoPersonalizado));
    },
  );

  test('renomeia o tipo preservando os demais dados e as categorias', () async {
    SharedPreferences.setMockInitialValues({
      'tipos_estabelecimento_usuario': jsonEncode([tipoPersonalizado]),
      'listas_salvas': jsonEncode([
        {
          'id': 1,
          'tipo': tipoPersonalizado,
          'nomeLista': 'Compras',
          'produtos': [
            {'nome': 'Arroz', 'categoria': 'Mercearia'},
          ],
        },
      ]),
      'estabelecimentos': jsonEncode([
        {
          'id': 'est-1',
          'nome': 'Mercado do Bairro',
          'endereco': 'Rua Um',
          'cidade': 'São Paulo',
          'tipo': tipoPersonalizado,
        },
      ]),
      'catalogo_produtos': jsonEncode([
        {
          'nome': 'Arroz',
          'categoria': 'Mercearia',
          'tipoEstabelecimento': tipoPersonalizado,
        },
      ]),
      'categorias_por_tipo_usuario': jsonEncode({
        tipoPersonalizado: ['Categoria personalizada'],
      }),
    });

    await TiposEstabelecimentoRepository.editarTipo(
      tipoPersonalizado,
      'Mercado da Vila',
    );

    final prefs = await SharedPreferences.getInstance();
    final lista =
        (jsonDecode(prefs.getString('listas_salvas')!) as List).single
            as Map<String, dynamic>;
    final estabelecimento =
        (jsonDecode(prefs.getString('estabelecimentos')!) as List).single
            as Map<String, dynamic>;
    final produto =
        (jsonDecode(prefs.getString('catalogo_produtos')!) as List).single
            as Map<String, dynamic>;
    final categorias =
        jsonDecode(prefs.getString('categorias_por_tipo_usuario')!)
            as Map<String, dynamic>;
    final tipos = await TiposEstabelecimentoRepository.carregarTodos();

    expect(tipos, contains('Mercado da Vila'));
    expect(tipos, isNot(contains(tipoPersonalizado)));
    expect(lista['tipo'], 'Mercado da Vila');
    expect(lista['nomeLista'], 'Compras');
    expect(lista['produtos'], [
      {'nome': 'Arroz', 'categoria': 'Mercearia'},
    ]);
    expect(estabelecimento['tipo'], 'Mercado da Vila');
    expect(produto['tipoEstabelecimento'], 'Mercado da Vila');
    expect(categorias, {
      'Mercado da Vila': ['Categoria personalizada'],
    });
  });

  test(
    'mantém os tipos originais protegidos contra edição e exclusão',
    () async {
      await expectLater(
        TiposEstabelecimentoRepository.editarTipo('Mercado', 'Outro nome'),
        throwsA(isA<TiposEstabelecimentoRepositoryException>()),
      );
      await expectLater(
        TiposEstabelecimentoRepository.excluirTipo('Mercado'),
        throwsA(isA<TiposEstabelecimentoRepositoryException>()),
      );
    },
  );
}
