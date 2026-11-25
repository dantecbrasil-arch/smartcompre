import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ListasRepository {
  static List<Map<String, dynamic>> listasSalvas = [];

  static Future<void> carregarListas() async {
    final prefs = await SharedPreferences.getInstance();

    final listasJson = prefs.getString('listas_salvas');

    if (listasJson != null) {
      final List<dynamic> dados = jsonDecode(listasJson);

      listasSalvas = dados
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
  }

  static Future<void> salvarListas() async {
    final prefs = await SharedPreferences.getInstance();

    final listasJson = jsonEncode(listasSalvas);

    await prefs.setString('listas_salvas', listasJson);
  }

  static Future<int> contarListasPorTipo(String tipo) async {
    final prefs = await SharedPreferences.getInstance();
    final listasJson = prefs.getString('listas_salvas');

    if (listasJson == null) {
      return 0;
    }

    final dynamic dados = jsonDecode(listasJson);
    if (dados is! List) {
      throw const FormatException('O armazenamento de listas é inválido.');
    }

    return dados.where((item) {
      return item is Map && item['tipo'] == tipo;
    }).length;
  }

  static Future<void> atualizarTipo(String tipoAtual, String tipoNovo) async {
    final prefs = await SharedPreferences.getInstance();
    final listasJson = prefs.getString('listas_salvas');

    if (listasJson == null) {
      return;
    }

    final dynamic dados = jsonDecode(listasJson);
    if (dados is! List) {
      throw const FormatException('O armazenamento de listas é inválido.');
    }

    var alterou = false;
    final listas = dados.map((item) {
      final lista = Map<String, dynamic>.from(item as Map);
      if (lista['tipo'] == tipoAtual) {
        lista['tipo'] = tipoNovo;
        alterou = true;
      }
      return lista;
    }).toList();

    if (!alterou) {
      return;
    }

    final salvo = await prefs.setString('listas_salvas', jsonEncode(listas));
    if (!salvo) {
      throw StateError('Não foi possível atualizar o tipo nas listas salvas.');
    }

    listasSalvas = listas;
  }
}
