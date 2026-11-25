String normalizarCategoria(String categoria) {
  final texto = categoria.trim().replaceAll(
        RegExp(r'\s+'),
        ' ',
      );

  if (texto.isEmpty) {
    return '';
  }

  final minusculo = texto.toLowerCase();
  final resultado = StringBuffer();
  var primeiraLetraMaiuscula = false;

  for (final rune in minusculo.runes) {
    final caractere = String.fromCharCode(rune);

    if (!primeiraLetraMaiuscula &&
        caractere.toUpperCase() != caractere.toLowerCase()) {
      resultado.write(caractere.toUpperCase());
      primeiraLetraMaiuscula = true;
    } else {
      resultado.write(caractere);
    }
  }

  return resultado.toString();
}
