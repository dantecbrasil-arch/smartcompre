import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/estabelecimento.dart';

class EstabelecimentosRepository {
  static const _key = 'estabelecimentos';

  Future<List<Estabelecimento>> carregar() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      return [];
    }

    final List lista = jsonDecode(jsonString);

    return lista
        .map((e) => Estabelecimento.fromMap(e))
        .toList();
  }

  Future<void> salvar(
    List<Estabelecimento> itens,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      itens.map((e) => e.toMap()).toList(),
    );

    await prefs.setString(
      _key,
      jsonString,
    );
  }
}