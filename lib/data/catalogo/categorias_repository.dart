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
}