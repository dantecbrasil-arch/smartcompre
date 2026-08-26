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

  categorias.sort(
    (a, b) =>
        a.toLowerCase().compareTo(
          b.toLowerCase(),
        ),
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
    if (categoria.trim().isEmpty) {
  return;
}

final existe =
    categorias.any(
  (c) =>
      c.toLowerCase() ==
      categoria.toLowerCase(),
);

if (existe) {
  throw Exception(
    'Categoria já existe',
  );
}

    categorias.add(categoria);

    categorias.sort(
  (a, b) =>
      a.toLowerCase().compareTo(
        b.toLowerCase(),
      ),
);

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

categorias.sort(
  (a, b) =>
      a.toLowerCase().compareTo(
        b.toLowerCase(),
      ),
);

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