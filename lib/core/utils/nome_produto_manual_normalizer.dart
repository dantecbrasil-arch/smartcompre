String normalizarNomeProdutoManual(String nome) {
  final texto = nome.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  if (texto.isEmpty) {
    return '';
  }

  final resultado = StringBuffer();
  var inicioPalavra = true;

  for (final rune in texto.runes) {
    final caractere = String.fromCharCode(rune);

    if (caractere == ' ') {
      resultado.write(caractere);
      inicioPalavra = true;
      continue;
    }

    final ehLetra = caractere.toLowerCase() != caractere.toUpperCase();

    if (inicioPalavra && ehLetra) {
      resultado.write(caractere.toUpperCase());
      inicioPalavra = false;
    } else {
      resultado.write(caractere);
      if (ehLetra) {
        inicioPalavra = false;
      }
    }
  }

  return resultado.toString();
}
