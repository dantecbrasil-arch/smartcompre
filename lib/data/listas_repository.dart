import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ListasRepository {
  static List<Map<String, dynamic>> listasSalvas = [];

  static Future<void> carregarListas() async {
    final prefs = await SharedPreferences.getInstance();

    final listasJson = prefs.getString('listas_salvas');

    if (listasJson != null) {

print('CARREGANDO: $listasJson');

      final List<dynamic> dados = jsonDecode(listasJson);

      listasSalvas =
          dados.map((item) => Map<String, dynamic>.from(item)).toList();
    }
  }

  static Future<void> salvarListas() async {
    final prefs = await SharedPreferences.getInstance();

    final listasJson = jsonEncode(listasSalvas);

    print('SALVANDO: $listasJson');

    await prefs.setString(
      'listas_salvas',
      listasJson,
    );
  }
}