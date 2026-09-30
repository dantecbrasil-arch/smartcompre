import '../core/constants/categorias_por_tipo.dart';

class EstabelecimentosService {

  List<String> obterCategoriasPorTipo(
    String tipo,
  ) {
    return CategoriasPorTipo.obter(tipo);
  }
}