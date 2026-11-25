import 'package:flutter/material.dart';

import '../core/utils/ordenacao_alfabetica.dart';
import '../models/estabelecimento.dart';
import '../repositorios/estabelecimentos_repository.dart';
import '../core/tipos_estabelecimento.dart';

const Set<String> _palavrasDeLigacao = {
  'a',
  'as',
  'ao',
  'aos',
  'com',
  'da',
  'das',
  'de',
  'do',
  'dos',
  'e',
  'em',
  'na',
  'nas',
  'no',
  'nos',
  'o',
  'os',
  'para',
  'por',
};

const Map<String, String> _abreviacoesEndereco = {
  'al': 'Al',
  'av': 'Av',
  'br': 'BR',
  'cep': 'CEP',
  'estr': 'Estr',
  'km': 'km',
  'nº': 'nº',
  'r': 'R',
  'rod': 'Rod',
  'sn': 'S/N',
  'trav': 'Trav',
  'tv': 'Tv',
};

const Set<String> _siglasEstados = {
  'ac',
  'al',
  'am',
  'ap',
  'ba',
  'ce',
  'df',
  'es',
  'go',
  'ma',
  'mg',
  'ms',
  'mt',
  'pa',
  'pb',
  'pe',
  'pi',
  'pr',
  'rj',
  'rn',
  'ro',
  'rr',
  'rs',
  'sc',
  'se',
  'sp',
  'to',
};

bool _ehLetraComCaixa(int rune) {
  final caractere = String.fromCharCode(rune);
  return caractere.toLowerCase() != caractere.toUpperCase();
}

String _letrasMinusculas(String texto) {
  return String.fromCharCodes(
    texto.runes.where(_ehLetraComCaixa),
  ).toLowerCase();
}

String _substituirNucleo(
  String palavra,
  String substituicao,
) {
  final runes = palavra.runes.toList();
  var inicio = -1;
  var fim = -1;

  for (var i = 0; i < runes.length; i++) {
    if (_ehLetraComCaixa(runes[i])) {
      if (inicio == -1) {
        inicio = i;
      }
      fim = i;
    }
  }

  if (inicio == -1) {
    return palavra;
  }

  return '${String.fromCharCodes(runes.take(inicio))}'
      '$substituicao'
      '${String.fromCharCodes(runes.skip(fim + 1))}';
}

String _capitalizarPalavra(String palavra) {
  final resultado = StringBuffer();
  var capitalizarProxima = true;

  for (final rune in palavra.toLowerCase().runes) {
    final caractere = String.fromCharCode(rune);

    if (caractere == '-' ||
        caractere == "'" ||
        caractere == '’') {
      resultado.write(caractere);
      capitalizarProxima = true;
    } else if (_ehLetraComCaixa(rune)) {
      resultado.write(
        capitalizarProxima
            ? caractere.toUpperCase()
            : caractere,
      );
      capitalizarProxima = false;
    } else {
      resultado.write(caractere);
    }
  }

  return resultado.toString();
}

String? _normalizarAbreviacaoEndereco(
  String palavra,
  String letras,
) {
  if (letras == 'al') {
    final abreviacao =
        palavra.contains('.')
            ? 'Al'
            : palavra == palavra.toUpperCase()
            ? 'AL'
            : 'Al';
    return _substituirNucleo(
      palavra,
      abreviacao,
    );
  }

  final abreviacao =
      _abreviacoesEndereco[palavra.toLowerCase()] ??
      _abreviacoesEndereco[letras] ??
      (_siglasEstados.contains(letras)
          ? letras.toUpperCase()
          : null);

  if (abreviacao == null) {
    return null;
  }

  return _substituirNucleo(
    palavra,
    abreviacao,
  );
}

String _normalizarTextoDeTitulo(
  String valor, {
  bool minusculasLigacao = false,
  bool endereco = false,
}) {
  final texto = valor.trim().replaceAll(
        RegExp(r'\s+'),
        ' ',
      );

  if (texto.isEmpty) {
    return '';
  }

  return texto
      .split(' ')
      .asMap()
      .entries
      .map((entrada) {
        final palavra = entrada.value;
        final letras = _letrasMinusculas(palavra);

        if (endereco) {
          final abreviacao =
              _normalizarAbreviacaoEndereco(
            palavra,
            letras,
          );

          if (abreviacao != null) {
            return abreviacao;
          }
        }

        if (minusculasLigacao &&
            entrada.key > 0 &&
            _palavrasDeLigacao.contains(letras)) {
          return palavra.toLowerCase();
        }

        return _capitalizarPalavra(palavra);
      })
      .join(' ');
}

String _normalizarNomeEstabelecimento(String valor) {
  return _normalizarTextoDeTitulo(valor).replaceAllMapped(
    RegExp(r'\biFood\b', caseSensitive: false),
    (_) => 'iFood',
  );
}

String _normalizarCidade(String valor) {
  return _normalizarTextoDeTitulo(
    valor,
    minusculasLigacao: true,
  );
}

String _normalizarEndereco(String valor) {
  return _normalizarTextoDeTitulo(
    valor,
    minusculasLigacao: true,
    endereco: true,
  );
}

class EstabelecimentosPage extends StatefulWidget {
  const EstabelecimentosPage({
    super.key,
  });

  @override
  State<EstabelecimentosPage> createState() =>
      _EstabelecimentosPageState();
}

class _EstabelecimentosPageState
    extends State<EstabelecimentosPage> {
  final _repository =
      EstabelecimentosRepository();

  List<Estabelecimento> _estabelecimentos = [];
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista =
        await _repository.carregar();

    if (!mounted) return;

    setState(() {
      _estabelecimentos = lista;
    });

    debugPrint(
      'ESTABELECIMENTOS: ${lista.length}',
    );
  }

  Future<void> _abrirCadastro({
  Estabelecimento? estabelecimento,
}) async {
    final nomeController =
    TextEditingController(
  text: estabelecimento?.nome ?? '',
);

final cidadeController =
    TextEditingController(
  text: estabelecimento?.cidade ?? '',
);

final enderecoController =
    TextEditingController(
  text: estabelecimento?.endereco ?? '',
);

String tipoSelecionado =
    estabelecimento?.tipo ??
    TiposEstabelecimento.mercado;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title: const Text(
                'Novo Estabelecimento',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                          nomeController,
                      decoration:
                          const InputDecoration(
                        labelText: 'Nome',
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    DropdownButtonFormField<
                        String>(
                      initialValue:
                          tipoSelecionado,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Tipo',
                      ),
                      items:
                          TiposEstabelecimento
                              .todos
                              .map(
                                (tipo) =>
                                    DropdownMenuItem(
                                  value:
                                      tipo,
                                  child:
                                      Text(
                                    tipo,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) {
                        setDialogState(
                          () {
                            tipoSelecionado =
                                value!;
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextField(
                      controller:
                          cidadeController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Cidade',
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextField(
                      controller:
                          enderecoController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Endereço',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child: const Text(
                    'Cancelar',
                  ),
                ),
                ElevatedButton(
  onPressed: () async {
                  final nomeNormalizado =
                      _normalizarNomeEstabelecimento(
                    nomeController.text,
                  );

                  if (nomeNormalizado.isEmpty) {
      return;
    }

                  final cidadeNormalizada =
                      _normalizarCidade(cidadeController.text);
                  final enderecoNormalizado =
                      _normalizarEndereco(enderecoController.text);

    final lista =
        await _repository.carregar();

    if (estabelecimento != null) {
  final index = lista.indexWhere(
    (e) => e.id == estabelecimento.id,
  );

  if (index != -1) {
    lista[index] = Estabelecimento(
      id: estabelecimento.id,
      nome: nomeNormalizado,
      endereco: enderecoNormalizado,
      cidade: cidadeNormalizada,
      tipo: tipoSelecionado,
      placeId: estabelecimento.placeId,
      latitude: estabelecimento.latitude,
      longitude: estabelecimento.longitude,
    );
  }
} else {
  lista.add(
    Estabelecimento(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      nome: nomeNormalizado,
      endereco: enderecoNormalizado,
      cidade: cidadeNormalizada,
      tipo: tipoSelecionado,
    ),
  );
}

    await _repository.salvar(
      lista,
    );

    if (!context.mounted) return;

    Navigator.pop(
      context,
    );

    await _carregar();
  },
  child: const Text(
    'Salvar',
  ),
),

              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final estabelecimentosFiltrados =
        ordenarAlfabeticamente(
      _estabelecimentos.where((e) {
        final texto =
            '${e.nome} ${e.endereco} ${e.tipo}'
                .toLowerCase();

        return texto.contains(
          _filtro.toLowerCase(),
        );
      }),
      (estabelecimento) => estabelecimento.nome,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estabelecimentos',
        ),
        actions: [
          IconButton(
            onPressed: _abrirCadastro,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: const InputDecoration(
          hintText:
              'Pesquisar estabelecimento',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _filtro = value;
          });
        },
      ),
    ),
    Expanded(
      child: estabelecimentosFiltrados
              .isEmpty
          ? const Center(
              child: Text(
                'Nenhum estabelecimento encontrado',
              ),
            )
          : ListView.builder(
              itemCount:
                  estabelecimentosFiltrados
                      .length,
              itemBuilder:
                  (context, index) {
                final estabelecimento =
                    estabelecimentosFiltrados[
                        index];

                return ListTile(
  leading: const Icon(
    Icons.store,
  ),

  title: Row(
    children: [
      Expanded(
        child: Text(
          estabelecimento.nome,
        ),
      ),

      IconButton(
  onPressed: () async {
    await _abrirCadastro(
      estabelecimento: estabelecimento,
    );
  },
        icon: const Icon(
          Icons.edit,
          color: Colors.blue,
        ),
      ),

      IconButton(
        onPressed: () async {
  final confirmar =
      await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Excluir estabelecimento',
        ),
        content: Text(
          '${estabelecimento.nome}\n\n'
          '📍 ${estabelecimento.endereco}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
                false,
              );
            },
            child: const Text(
              'Cancelar',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                true,
              );
            },
            child: const Text(
              'Excluir',
            ),
          ),
        ],
      );
    },
  );

  if (confirmar != true) {
    return;
  }

  final lista =
      await _repository.carregar();

  lista.removeWhere(
    (e) => e.id == estabelecimento.id,
  );

  await _repository.salvar(
    lista,
  );

  await _carregar();
},
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    ],
  ),

  subtitle: Text(
    '📍 ${estabelecimento.endereco.isEmpty ? "Endereço não informado" : estabelecimento.endereco}\n'
    '🏷 ${estabelecimento.tipo}',
  ),

  onTap: () {
    Navigator.pop(
      context,
      estabelecimento,
    );
  },
);
              },
            ),
    ),
  ],
),
    );
  }
}