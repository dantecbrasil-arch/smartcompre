const Map<String, String> _gruposDeDiacriticos = {
  'a': 'àáâãäåāăąǎǟǡǻȁȃȧạảấầẩẫậắằẳẵặ',
  'c': 'çćĉċč',
  'd': 'ďđ',
  'e': 'èéêëēĕėęěȅȇẹẻẽếềểễệ',
  'g': 'ĝğġģ',
  'h': 'ĥħ',
  'i': 'ìíîïĩīĭįǐȉȋịỉı',
  'j': 'ĵ',
  'k': 'ķ',
  'l': 'ĺļľŀł',
  'n': 'ñńņňŋ',
  'o': 'òóôõöøōŏőǒǫǭȍȏȫȭȯȱọỏốồổỗộơớờởỡợ',
  'r': 'ŕŗř',
  's': 'śŝşš',
  't': 'ţťŧ',
  'u': 'ùúûüũūŭůűųǔǖǘǚǜȕȗụủứừửữựư',
  'w': 'ŵ',
  'y': 'ýÿŷȳẏỳỵỷỹ',
  'z': 'źżž',
};

final Map<String, String> _diacriticosParaBase = {
  for (final grupo in _gruposDeDiacriticos.entries)
    for (final rune in grupo.value.runes)
      String.fromCharCode(rune): grupo.key,
};

bool _ehMarcaCombinante(int rune) {
  return (rune >= 0x0300 && rune <= 0x036f) ||
      (rune >= 0x1ab0 && rune <= 0x1aff) ||
      (rune >= 0x1dc0 && rune <= 0x1dff) ||
      (rune >= 0x20d0 && rune <= 0x20ff) ||
      (rune >= 0xfe20 && rune <= 0xfe2f);
}

String _chaveAlfabetica(String texto) {
  final resultado = StringBuffer();

  for (final rune in texto.toLowerCase().runes) {
    if (_ehMarcaCombinante(rune)) {
      continue;
    }

    final caractere = String.fromCharCode(rune);
    resultado.write(
      _diacriticosParaBase[caractere] ?? caractere,
    );
  }

  return resultado.toString();
}

List<T> ordenarAlfabeticamente<T>(
  Iterable<T> itens,
  String Function(T) obterTexto,
) {
  final entradas = itens.toList().asMap().entries.toList();

  entradas.sort((a, b) {
    final comparacao = _chaveAlfabetica(
      obterTexto(a.value),
    ).compareTo(
      _chaveAlfabetica(obterTexto(b.value)),
    );

    return comparacao != 0
        ? comparacao
        : a.key.compareTo(b.key);
  });

  return entradas
      .map((entrada) => entrada.value)
      .toList();
}

class ResultadoCategoriasOrdenadas {
  final List<String> categorias;
  final String? categoriaSelecionada;

  const ResultadoCategoriasOrdenadas({
    required this.categorias,
    required this.categoriaSelecionada,
  });
}

String _chaveDuplicidadeCategoria(String categoria) {
  return categoria
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ')
      .toLowerCase();
}

ResultadoCategoriasOrdenadas combinarCategoriasOrdenadas(
  Iterable<String> categoriasPadrao,
  Iterable<String> categoriasPersonalizadas, {
  String? categoriaSelecionada,
}) {
  final categoriasUnicas = <String>[];
  final indicesPorChave = <String, int>{};

  void adicionarSeUnica(String categoria) {
    final chave = _chaveDuplicidadeCategoria(categoria);

    if (indicesPorChave.containsKey(chave)) {
      return;
    }

    indicesPorChave[chave] = categoriasUnicas.length;
    categoriasUnicas.add(categoria);
  }

  for (final categoria in categoriasPadrao) {
    adicionarSeUnica(categoria);
  }

  for (final categoria in categoriasPersonalizadas) {
    adicionarSeUnica(categoria);
  }

  String? categoriaSelecionadaDisponivel;

  if (categoriaSelecionada != null) {
    final chaveSelecionada =
        _chaveDuplicidadeCategoria(categoriaSelecionada);
    final indiceExistente = indicesPorChave[chaveSelecionada];

    if (indiceExistente != null) {
      categoriaSelecionadaDisponivel =
          categoriasUnicas[indiceExistente];
    } else {
      adicionarSeUnica(categoriaSelecionada);
      categoriaSelecionadaDisponivel = categoriaSelecionada;
    }
  }

  return ResultadoCategoriasOrdenadas(
    categorias: ordenarAlfabeticamente(
      categoriasUnicas,
      (categoria) => categoria,
    ),
    categoriaSelecionada: categoriaSelecionadaDisponivel,
  );
}
