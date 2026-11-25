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

    return lista.map((e) => Estabelecimento.fromMap(e)).toList();
  }

  Future<void> salvar(List<Estabelecimento> itens) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(itens.map((e) => e.toMap()).toList());

    await prefs.setString(_key, jsonString);
  }

  static Future<void> atualizarTipo(String tipoAtual, String tipoNovo) async {
    final repository = EstabelecimentosRepository();
    final estabelecimentos = await repository.carregar();
    var alterou = false;

    final atualizados = estabelecimentos.map((estabelecimento) {
      if (estabelecimento.tipo != tipoAtual) {
        return estabelecimento;
      }

      alterou = true;
      return Estabelecimento(
        id: estabelecimento.id,
        nome: estabelecimento.nome,
        endereco: estabelecimento.endereco,
        cidade: estabelecimento.cidade,
        tipo: tipoNovo,
        placeId: estabelecimento.placeId,
        latitude: estabelecimento.latitude,
        longitude: estabelecimento.longitude,
      );
    }).toList();

    if (alterou) {
      await repository.salvar(atualizados);
    }
  }
}
