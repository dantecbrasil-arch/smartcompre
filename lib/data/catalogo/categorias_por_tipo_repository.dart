import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CategoriasPorTipoRepository {
  static const _key =
      'categorias_por_tipo_usuario';

  static Future<
      Map<String, List<String>>> carregar() async {
    final prefs =
        await SharedPreferences.getInstance();

    final json =
        prefs.getString(_key);

    if (json == null) {
      return {};
    }

    final Map<String, dynamic> dados =
        jsonDecode(json);

    return dados.map(
      (key, value) => MapEntry(
        key,
        List<String>.from(value),
      ),
    );
  }

  static Future<void> salvar(
    Map<String, List<String>> dados,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _key,
      jsonEncode(dados),
    );
  }

  static Future<List<String>>
      obterCategorias(
    String tipo,
  ) async {
    final dados = await carregar();

    return dados[tipo] ?? [];
  }

  static Future<void> adicionarCategoria(
    String tipo,
    String categoria,
  ) async {
    final dados = await carregar();

    dados.putIfAbsent(tipo, () => []);

    final existe = dados[tipo]!.any(
      (c) =>
          c.toLowerCase() ==
          categoria.toLowerCase(),
    );

    if (existe) {
      return;
    }

    dados[tipo]!.add(categoria);

        dados[tipo]!.sort(
      (a, b) => a
          .toLowerCase()
          .compareTo(
            b.toLowerCase(),
          ),
    );

    await salvar(dados);
  }

  static Future<void> excluirCategoria(
    String tipo,
    String categoria,
  ) async {
    final dados = await carregar();

    if (!dados.containsKey(tipo)) {
      return;
    }

    dados[tipo]!.removeWhere(
      (c) =>
          c.toLowerCase() ==
          categoria.toLowerCase(),
    );

    await salvar(dados);
  }
  static Future<void> editarCategoria(
  String tipo,
  String antiga,
  String nova,
) async {
  final dados = await carregar();

  if (!dados.containsKey(tipo)) {
    return;
  }

  final indice =
      dados[tipo]!.indexWhere(
    (c) =>
        c.toLowerCase() ==
        antiga.toLowerCase(),
  );

  if (indice == -1) {
    return;
  }

  dados[tipo]![indice] = nova;

  dados[tipo]!.sort(
    (a, b) => a
        .toLowerCase()
        .compareTo(
          b.toLowerCase(),
        ),
  );

  await salvar(dados);
}
}