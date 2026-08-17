enum TipoEtiqueta {
  peso,
  unidade,
}
class ClassificacaoEtiqueta {

  static TipoEtiqueta identificar(
    String texto,
  ) {

    final t =
        texto.toUpperCase();

    if (
        t.contains('PESO') ||
        t.contains('PES0') ||
        t.contains('TARA')
    ) {
      return TipoEtiqueta.peso;
    }

    return TipoEtiqueta.unidade;
  }
}