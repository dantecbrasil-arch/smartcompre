import '../models/etiqueta_produto.dart';
import 'parsers/classificacao_etiqueta.dart';
import 'parsers/etiqueta_peso_parser.dart';
import 'parsers/etiqueta_unidade_parser.dart';

class EtiquetaParser {
  static EtiquetaProduto extrair(String texto) {
    print(
      'ENTROU ETIQUETA PARSER',
    );

    final tipo =
        ClassificacaoEtiqueta
            .identificar(texto);

    if (tipo == TipoEtiqueta.peso) {
      print(
        'REDIRECIONANDO PARA PESO PARSER',
      );

      return EtiquetaPesoParser.extrair(
        texto,
      );
    }

    if (tipo == TipoEtiqueta.unidade) {
      print(
        'REDIRECIONANDO PARA UNIDADE PARSER',
      );

      return EtiquetaUnidadeParser.extrair(
        texto,
      );
    }

    throw Exception(
      'Tipo de etiqueta nao suportado: $tipo',
    );
  }
}