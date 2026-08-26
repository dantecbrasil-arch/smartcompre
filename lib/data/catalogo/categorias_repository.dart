import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CategoriasRepository {
  static const _key = 'categorias';

  static List<String> categorias = [
    'Mercearia',
    'Laticínios',
    'Carnes',
    'Bebidas',
    'Limpeza',
    'Hortifruti',
    'Farmácia',
    'Outros',
  ];

  static Future<void> carregar() async {
    final prefs =
        await SharedPreferences.getInstance();

    final json =
        prefs.getString(_key);

    if (json != null) {
      categorias =
          List<String>.from(
        jsonDecode(json),
      );
    }
  }

  static Future<void> salvar() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      jsonEncode(categorias),
    );
  }

  static Future<void> adicionar(
    String categoria,
  ) async {
    if (
        categoria.trim().isEmpty ||
        categorias.contains(categoria)) {
      return;
    }

    categorias.add(categoria);

    await salvar();
  }
  static Future<void> editar(
  String antiga,
  String nova,
) async {

  final index =
      categorias.indexOf(antiga);

  if (index == -1) {
    return;
  }

  categorias[index] = nova;

  await salvar();
}
static Future<void> excluir(
  String categoria,
) async {

  if (categoria == 'Outros') {
    return;
  }

  categorias.remove(categoria);

  await salvar();
}
}