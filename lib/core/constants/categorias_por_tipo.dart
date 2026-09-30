import '../tipos_estabelecimento.dart';

class CategoriasPorTipo {
  static const Map<String, List<String>> categorias = {
    TiposEstabelecimento.mercado: [
      'Açougue',
      'Padaria',
      'Hortifruti',
      'Bebidas',
      'Limpeza',
      'Mercearia',
      'Congelados',
    ],

    TiposEstabelecimento.farmacia: [
      'Medicamentos',
      'Higiene',
      'Vitaminas',
      'Cosméticos',
    ],

    TiposEstabelecimento.posto: [
      'Combustível',
      'Lubrificantes',
      'Conveniência',
    ],

    TiposEstabelecimento.autopecas: [
      'Óleo',
      'Filtros',
      'Freios',
      'Pneus',
    ],

    TiposEstabelecimento.petshop: [
      'Ração',
      'Medicamentos',
      'Acessórios',
    ],

    TiposEstabelecimento.construcao: [
      'Ferramentas',
      'Elétrica',
      'Hidráulica',
      'Pintura',
    ],

    TiposEstabelecimento.loja: [
      'Vestuário',
      'Calçados',
      'Acessórios',
    ],

    TiposEstabelecimento.outros: [
      'Outros',
    ],
  };

  static List<String> obter(String tipo) {
    return categorias[tipo] ?? ['Outros'];
  }
}