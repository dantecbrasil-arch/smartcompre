import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/tipos_estabelecimento.dart';
import 'catalogo/catalogo_repository.dart';
import 'catalogo/categorias_por_tipo_repository.dart';
import 'listas_repository.dart';
import '../repositorios/estabelecimentos_repository.dart';

class TiposEstabelecimentoRepositoryException implements Exception {
  final String message;
  final int? quantidadeListas;

  const TiposEstabelecimentoRepositoryException(
    this.message, {
    this.quantidadeListas,
  });

  @override
  String toString() => message;
}

class TiposEstabelecimentoRepository {
  static const _key = 'tipos_estabelecimento_usuario';

  static Future<List<String>> carregarTodos() async {
    final personalizados = await carregarPersonalizados();
    final tipos = [...TiposEstabelecimento.todos];
    final chaves = tipos.map(_chave).toSet();

    for (final tipo in personalizados) {
      if (tipo.isNotEmpty && chaves.add(_chave(tipo))) {
        tipos.add(tipo);
      }
    }

    return tipos;
  }

  static Future<List<String>> carregarPersonalizados() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);

    if (json == null) {
      return [];
    }

    final List<dynamic> dados = jsonDecode(json);
    return dados
        .whereType<String>()
        .map(_normalizarNome)
        .where((tipo) => tipo.isNotEmpty)
        .toList();
  }

  static Future<int> contarListasVinculadas(String tipo) {
    return ListasRepository.contarListasPorTipo(tipo);
  }

  static Future<void> adicionarTipo(String valor) async {
    final nome = _validarNome(valor);
    final personalizados = await carregarPersonalizados();
    final tipos = await carregarTodos();

    if (tipos.any((tipo) => _chave(tipo) == _chave(nome))) {
      throw const TiposEstabelecimentoRepositoryException(
        'Já existe um tipo de estabelecimento com esse nome.',
      );
    }

    personalizados.add(nome);
    await _salvarPersonalizados(personalizados);
  }

  static Future<void> editarTipo(String atual, String novoValor) async {
    final personalizados = await carregarPersonalizados();
    final indice = personalizados.indexWhere(
      (tipo) => _chave(tipo) == _chave(atual),
    );

    if (indice == -1) {
      _lancarSeTipoNativo(atual);
      throw const TiposEstabelecimentoRepositoryException(
        'Tipo personalizado não encontrado.',
      );
    }

    final novoNome = _validarNome(novoValor);
    final tipos = await carregarTodos();
    final chaveAtual = _chave(personalizados[indice]);

    if (tipos.any(
      (tipo) => _chave(tipo) != chaveAtual && _chave(tipo) == _chave(novoNome),
    )) {
      throw const TiposEstabelecimentoRepositoryException(
        'Já existe um tipo de estabelecimento com esse nome.',
      );
    }

    final nomeAtual = personalizados[indice];

    await ListasRepository.atualizarTipo(nomeAtual, novoNome);
    await EstabelecimentosRepository.atualizarTipo(nomeAtual, novoNome);
    await CatalogoRepository.instance.atualizarTipoEstabelecimento(
      nomeAtual,
      novoNome,
    );
    await CategoriasPorTipoRepository.renomearTipo(nomeAtual, novoNome);

    personalizados[indice] = novoNome;
    await _salvarPersonalizados(personalizados);
  }

  static Future<void> excluirTipo(String tipo) async {
    final personalizados = await carregarPersonalizados();
    final indice = personalizados.indexWhere(
      (personalizado) => _chave(personalizado) == _chave(tipo),
    );

    if (indice == -1) {
      _lancarSeTipoNativo(tipo);
      throw const TiposEstabelecimentoRepositoryException(
        'Tipo personalizado não encontrado.',
      );
    }

    final tipoExistente = personalizados[indice];
    final quantidadeListas = await contarListasVinculadas(tipoExistente);

    if (quantidadeListas > 0) {
      final mensagem = quantidadeListas == 1
          ? 'Não é possível excluir "$tipoExistente": existe 1 lista '
                'vinculada a este tipo.'
          : 'Não é possível excluir "$tipoExistente": existem '
                '$quantidadeListas listas vinculadas a este tipo.';
      throw TiposEstabelecimentoRepositoryException(
        mensagem,
        quantidadeListas: quantidadeListas,
      );
    }

    await EstabelecimentosRepository.atualizarTipo(
      tipoExistente,
      TiposEstabelecimento.outros,
    );
    await CatalogoRepository.instance.atualizarTipoEstabelecimento(
      tipoExistente,
      TiposEstabelecimento.outros,
    );

    personalizados.removeAt(indice);
    await _salvarPersonalizados(personalizados);
  }

  static String _validarNome(String valor) {
    final nome = _normalizarNome(valor);

    if (nome.isEmpty) {
      throw const TiposEstabelecimentoRepositoryException(
        'O nome do tipo não pode ficar vazio.',
      );
    }

    return nome;
  }

  static String _normalizarNome(String valor) {
    return valor.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String _chave(String valor) {
    return _normalizarNome(valor).toLowerCase();
  }

  static void _lancarSeTipoNativo(String tipo) {
    if (TiposEstabelecimento.todos.any(
      (nativo) => _chave(nativo) == _chave(tipo),
    )) {
      throw const TiposEstabelecimentoRepositoryException(
        'Tipos originais do aplicativo não podem ser editados ou excluídos.',
      );
    }
  }

  static Future<void> _salvarPersonalizados(List<String> personalizados) async {
    final prefs = await SharedPreferences.getInstance();
    final salvo = await prefs.setString(_key, jsonEncode(personalizados));

    if (!salvo) {
      throw const TiposEstabelecimentoRepositoryException(
        'Não foi possível salvar os tipos de estabelecimento.',
      );
    }
  }
}
