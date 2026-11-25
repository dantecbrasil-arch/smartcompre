import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/categorias_por_tipo.dart';
import '../../core/utils/categoria_normalizer.dart';

class CategoriaRepositoryException implements Exception {
  final String message;

  const CategoriaRepositoryException(this.message);

  @override
  String toString() => message;
}

class CategoriasPorTipoRepository {
  static const _key = 'categorias_por_tipo_usuario';

  static Future<Map<String, List<String>>> carregar() async {
    final prefs = await SharedPreferences.getInstance();

    final json = prefs.getString(_key);

    if (json == null) {
      return {};
    }

    final Map<String, dynamic> dados = jsonDecode(json);

    return dados.map((key, value) => MapEntry(key, List<String>.from(value)));
  }

  static Future<void> salvar(Map<String, List<String>> dados) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_key, jsonEncode(dados));
  }

  static Future<List<String>> obterCategorias(String tipo) async {
    final dados = await carregar();

    return dados[tipo] ?? [];
  }

  static Future<void> renomearTipo(String tipoAtual, String tipoNovo) async {
    if (tipoAtual == tipoNovo) {
      return;
    }

    final dados = await carregar();
    final categoriasAtuais = dados.remove(tipoAtual);

    if (categoriasAtuais == null) {
      return;
    }

    final categoriasDestino = dados.remove(tipoNovo) ?? [];
    dados[tipoNovo] = [...categoriasDestino, ...categoriasAtuais];
    await salvar(dados);
  }

  static Future<void> adicionarCategoria(String tipo, String categoria) async {
    final nomeNormalizado = normalizarCategoria(categoria);

    if (nomeNormalizado.isEmpty) {
      throw const CategoriaRepositoryException(
        'O nome da categoria não pode ficar vazio.',
      );
    }

    final dados = await carregar();

    final categoriasDoTipo = [
      ...CategoriasPorTipo.obter(tipo),
      ...?dados[tipo],
    ];

    final existe = categoriasDoTipo.any(
      (c) => normalizarCategoria(c) == nomeNormalizado,
    );

    if (existe) {
      throw const CategoriaRepositoryException(
        'Categoria já existe neste tipo de estabelecimento.',
      );
    }

    dados.putIfAbsent(tipo, () => []);
    dados[tipo]!.add(nomeNormalizado);

    dados[tipo]!.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    await salvar(dados);
  }

  static Future<void> excluirCategoria(String tipo, String categoria) async {
    final nomeNormalizado = normalizarCategoria(categoria);

    if (nomeNormalizado.isEmpty) {
      return;
    }

    if (_ehCategoriaPadrao(tipo, nomeNormalizado)) {
      throw const CategoriaRepositoryException(
        'Categorias padrão não podem ser excluídas.',
      );
    }

    final dados = await carregar();

    if (!dados.containsKey(tipo)) {
      return;
    }

    dados[tipo]!.removeWhere((c) => normalizarCategoria(c) == nomeNormalizado);

    await salvar(dados);
  }

  static Future<void> editarCategoria(
    String tipo,
    String antiga,
    String nova,
  ) async {
    final nomeAntigoNormalizado = normalizarCategoria(antiga);
    final nomeNovoNormalizado = normalizarCategoria(nova);

    if (nomeNovoNormalizado.isEmpty) {
      throw const CategoriaRepositoryException(
        'O nome da categoria não pode ficar vazio.',
      );
    }

    if (_ehCategoriaPadrao(tipo, nomeAntigoNormalizado)) {
      throw const CategoriaRepositoryException(
        'Categorias padrão não podem ser editadas.',
      );
    }

    final dados = await carregar();

    if (!dados.containsKey(tipo)) {
      return;
    }

    final categoriasDoTipo = dados[tipo]!;
    final indice = categoriasDoTipo.indexWhere(
      (categoria) => normalizarCategoria(categoria) == nomeAntigoNormalizado,
    );

    if (indice == -1) {
      return;
    }

    if (_ehCategoriaPadrao(tipo, nomeNovoNormalizado)) {
      throw const CategoriaRepositoryException(
        'Categoria já existe neste tipo de estabelecimento.',
      );
    }

    final existe = categoriasDoTipo.asMap().entries.any(
      (entry) =>
          entry.key != indice &&
          normalizarCategoria(entry.value) == nomeNovoNormalizado,
    );

    if (existe) {
      throw const CategoriaRepositoryException(
        'Categoria já existe neste tipo de estabelecimento.',
      );
    }

    categoriasDoTipo[indice] = nomeNovoNormalizado;

    categoriasDoTipo.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    await salvar(dados);
  }

  static bool _ehCategoriaPadrao(String tipo, String categoriaNormalizada) {
    return CategoriasPorTipo.obter(tipo).any(
      (categoria) => normalizarCategoria(categoria) == categoriaNormalizada,
    );
  }
}
