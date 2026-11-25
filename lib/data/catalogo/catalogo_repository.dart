import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'produto_catalogo.dart';

class CatalogoRepository {
  static final CatalogoRepository instance = CatalogoRepository._internal();

  CatalogoRepository._internal();

  final List<ProdutoCatalogo> _produtos = [];
  final Map<ProdutoCatalogo, Map<String, dynamic>> _registrosLegadosSemTipo =
      {};

  static const String _chaveCatalogo = 'catalogo_produtos';

  String normalizarNome(String nome) {
    return nome
        .toUpperCase()
        .replaceAll('(KG)', '')
        .replaceAll('KG', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  ProdutoCatalogo? buscarProduto(String nome, String tipoEstabelecimento) {
    try {
      return _produtos.firstWhere(
        (p) =>
            !_registrosLegadosSemTipo.containsKey(p) &&
            p.tipoEstabelecimento == tipoEstabelecimento &&
            normalizarNome(p.nome) == normalizarNome(nome),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> salvarCatalogo() async {
    final prefs = await SharedPreferences.getInstance();

    final listaJson = _produtos
        .map((produto) => _registrosLegadosSemTipo[produto] ?? produto.toMap())
        .toList();

    await prefs.setString(_chaveCatalogo, jsonEncode(listaJson));

    debugPrint('CATALOGO SALVO: ${_produtos.length}');
  }

  Future<void> carregarCatalogo() async {
    final prefs = await SharedPreferences.getInstance();

    final json = prefs.getString(_chaveCatalogo);

    if (json == null) {
      return;
    }

    final lista = jsonDecode(json) as List;

    _produtos.clear();
    _registrosLegadosSemTipo.clear();

    for (final item in lista) {
      final dados = Map<String, dynamic>.from(item);
      final tipo = dados['tipoEstabelecimento'];

      if (tipo is! String || tipo.trim().isEmpty) {
        final produto = ProdutoCatalogo.fromMap({
          ...dados,
          'tipoEstabelecimento': '',
        });

        _produtos.add(produto);
        _registrosLegadosSemTipo[produto] = dados;
        continue;
      }

      _produtos.add(ProdutoCatalogo.fromMap(dados));
    }

    debugPrint('CATALOGO CARREGADO: ${_produtos.length}');
  }

  Future<void> salvarProduto(ProdutoCatalogo produto) async {
    final index = _produtos.indexWhere(
      (p) =>
          !_registrosLegadosSemTipo.containsKey(p) &&
          p.tipoEstabelecimento == produto.tipoEstabelecimento &&
          normalizarNome(p.nome) == normalizarNome(produto.nome),
    );

    if (index >= 0) {
      _produtos[index] = produto;

      debugPrint(
        'CATALOGO ATUALIZADO: '
        '${produto.nome}',
      );
    } else {
      _produtos.add(produto);

      debugPrint(
        'CATALOGO NOVO PRODUTO: '
        '${produto.nome}',
      );
    }

    await salvarCatalogo();

    debugPrint('TOTAL CATALOGO: ${_produtos.length}');
  }

  Future<void> atualizarTipoEstabelecimento(
    String tipoAtual,
    String tipoNovo,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_chaveCatalogo);

    if (json == null) {
      return;
    }

    final dynamic dados = jsonDecode(json);
    if (dados is! List) {
      throw const FormatException('O catálogo armazenado é inválido.');
    }

    var alterou = false;
    final produtos = dados.map((item) {
      final produto = Map<String, dynamic>.from(item as Map);
      if (produto['tipoEstabelecimento'] == tipoAtual) {
        produto['tipoEstabelecimento'] = tipoNovo;
        alterou = true;
      }
      return produto;
    }).toList();

    if (!alterou) {
      return;
    }

    final salvo = await prefs.setString(_chaveCatalogo, jsonEncode(produtos));
    if (!salvo) {
      throw StateError(
        'Não foi possível atualizar o tipo nos produtos do catálogo.',
      );
    }

    await carregarCatalogo();
  }

  List<ProdutoCatalogo> listarProdutos() {
    return _produtos;
  }

  Future<void> limparCatalogo() async {
    _produtos.clear();
    _registrosLegadosSemTipo.clear();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_chaveCatalogo);

    debugPrint('CATALOGO LIMPO');
  }
}
