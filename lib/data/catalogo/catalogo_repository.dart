import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'produto_catalogo.dart';

class CatalogoRepository {
  static final CatalogoRepository instance =
      CatalogoRepository._internal();

  CatalogoRepository._internal();

  final List<ProdutoCatalogo> _produtos = [];

  static const String _chaveCatalogo =
    'catalogo_produtos';

    String normalizarNome(
  String nome,
) {
  return nome
      .toUpperCase()
      .replaceAll('(KG)', '')
      .replaceAll('KG', '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}


  ProdutoCatalogo? buscarProduto(String nome) {
    try {
      return _produtos.firstWhere(
        (p) =>
    normalizarNome(p.nome) ==
    normalizarNome(nome),

      );
    } catch (_) {
      return null;
    }
  }

    Future<void> salvarCatalogo() async {
    final prefs =
        await SharedPreferences.getInstance();

    final listaJson =
        _produtos
            .map((p) => p.toMap())
            .toList();

    await prefs.setString(
      _chaveCatalogo,
      jsonEncode(listaJson),
    );

    debugPrint(
      'CATALOGO SALVO: ${_produtos.length}',
    );
  } 

  Future<void> carregarCatalogo() async {
  final prefs =
      await SharedPreferences.getInstance();

  final json =
      prefs.getString(_chaveCatalogo);

  if (json == null) {
    return;
  }

  final lista =
      jsonDecode(json) as List;

  _produtos.clear();

  _produtos.addAll(
    lista.map(
      (item) => ProdutoCatalogo.fromMap(
        Map<String, dynamic>.from(item),
      ),
    ),
  );

  debugPrint(
    'CATALOGO CARREGADO: ${_produtos.length}',
  );
}

  Future<void> salvarProduto(
  ProdutoCatalogo produto,
) async {

  final index = _produtos.indexWhere(
  (p) =>
      normalizarNome(p.nome) ==
      normalizarNome(produto.nome),
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

  debugPrint(
    'TOTAL CATALOGO: ${_produtos.length}',
  );
}

  List<ProdutoCatalogo> listarProdutos() {
    return _produtos;
  }

Future<void> limparCatalogo() async {
  _produtos.clear();

  final prefs =
      await SharedPreferences.getInstance();

  await prefs.remove(_chaveCatalogo);

  debugPrint(
    'CATALOGO LIMPO',
  );
}
}